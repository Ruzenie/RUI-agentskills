#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../../.." && pwd)"

usage() {
  cat <<'USAGE'
run_phase5_acceptance.sh

Usage:
  bash skills/ui-fullflow-orchestrator/scripts/run_phase5_acceptance.sh \
    --out-dir /path/to/Ruiagents/xxx \
    --workspace-root /path/to/workspace \
    --acceptance-level strict

Options:
  --out-dir <path>                 输出目录（必须）
  --workspace-root <path>          工作区目录（用于自动验收命令）
  --acceptance-level <id>          strict|normal|loose（默认 strict）
USAGE
}

OUT_DIR=""
WORKSPACE_ROOT=""
ACCEPTANCE_LEVEL="strict"
ARG_ACCEPTANCE_LEVEL_SET="0"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --out-dir) OUT_DIR="$2"; shift 2 ;;
    --workspace-root) WORKSPACE_ROOT="$2"; shift 2 ;;
    --acceptance-level) ACCEPTANCE_LEVEL="$2"; ARG_ACCEPTANCE_LEVEL_SET="1"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown arg: $1" >&2; usage; exit 1 ;;
  esac
done

if [[ -z "$OUT_DIR" ]]; then
  echo "Error: 缺少 --out-dir" >&2
  usage
  exit 1
fi

if [[ -z "$WORKSPACE_ROOT" ]]; then
  WORKSPACE_ROOT="$(pwd -P)"
fi
eval "$(python3 "$REPO_ROOT/skills/skill-structure-governor/scripts/config_loader.py" --repo-root "$REPO_ROOT" --workspace-root "$WORKSPACE_ROOT" --print-env)"
if [[ "$ARG_ACCEPTANCE_LEVEL_SET" != "1" && -n "${RUI_CFG_ACCEPTANCE_LEVEL:-}" ]]; then
  ACCEPTANCE_LEVEL="$RUI_CFG_ACCEPTANCE_LEVEL"
fi

if [[ "$ACCEPTANCE_LEVEL" != "strict" && "$ACCEPTANCE_LEVEL" != "normal" && "$ACCEPTANCE_LEVEL" != "loose" ]]; then
  echo "Error: --acceptance-level 仅支持 strict|normal|loose" >&2
  exit 1
fi

REPORT_JSON="$OUT_DIR/phase5.acceptance.report.json"
REPORT_MD="$OUT_DIR/phase5.acceptance.report.md"
SCORECARD_JSON="$OUT_DIR/self-eval.scorecard.json"
GATE_REPORT_JSON="$OUT_DIR/gate-validation-report.json"
PHASE4_REPORT_JSON="$OUT_DIR/phase4.refactor.report.json"

python3 - <<'PY' "$ACCEPTANCE_LEVEL" "$REPORT_JSON" "$REPORT_MD" "$SCORECARD_JSON" "$GATE_REPORT_JSON" "$PHASE4_REPORT_JSON" "$WORKSPACE_ROOT"
import json
import subprocess
import sys
from datetime import datetime, timezone
from pathlib import Path

acceptance_level = sys.argv[1]
report_json = Path(sys.argv[2])
report_md = Path(sys.argv[3])
scorecard_path = Path(sys.argv[4])
gate_report_path = Path(sys.argv[5])
phase4_report_path = Path(sys.argv[6])
workspace_root = Path(sys.argv[7]).resolve() if sys.argv[7] else Path(".").resolve()


def load_json(path: Path, default: dict):
    if not path.exists():
        return default
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except Exception:
        return default

scorecard = load_json(scorecard_path, {})
gate_report = load_json(gate_report_path, {})
phase4_report = load_json(phase4_report_path, {})

gates = scorecard.get("gates") or {}
readiness = scorecard.get("readiness") or {}
phase4_status = phase4_report.get("status") or (phase4_report.get("summary") or {}).get("status") or "pending"
phase4_executed = phase4_status in {"completed", "completed_with_findings"}

tool_checks = []
if workspace_root.exists() and (workspace_root / "package.json").exists():
    try:
        package = json.loads((workspace_root / "package.json").read_text(encoding="utf-8"))
    except Exception:
        package = {}
    scripts = (package or {}).get("scripts") or {}
    if (workspace_root / "pnpm-lock.yaml").exists():
        runner = ["pnpm"]
    elif (workspace_root / "yarn.lock").exists():
        runner = ["yarn"]
    else:
        runner = ["npm"]

    def run_script(name: str, script_key: str):
        if script_key not in scripts:
            tool_checks.append({"name": name, "script": script_key, "status": "skipped", "reason": "script_not_found"})
            return
        cmd = [*runner, "run", script_key]
        try:
            proc = subprocess.run(cmd, cwd=workspace_root, capture_output=True, text=True, timeout=300)
            tool_checks.append({
                "name": name,
                "script": script_key,
                "status": "passed" if proc.returncode == 0 else "failed",
                "exit_code": proc.returncode,
                "stdout_tail": (proc.stdout or "")[-500:],
                "stderr_tail": (proc.stderr or "")[-500:],
            })
        except Exception as exc:
            tool_checks.append({"name": name, "script": script_key, "status": "failed", "error": str(exc)})

    run_script("lint", "lint")
    run_script("typecheck", "typecheck")
    run_script("test", "test")
    run_script("a11y", "a11y")
    run_script("lighthouse", "lighthouse")
else:
    tool_checks = [{"name": "toolchain", "status": "skipped", "reason": "package.json_not_found"}]

gate_details = gate_report.get("details") or []
failed_gates = [row for row in gate_details if str(row.get("status", "")).startswith("❌")]
failed_gate_count = len(failed_gates)
failed_tool_checks = [x for x in tool_checks if x.get("status") == "failed"]

requirements_gate = bool(gates.get("requirements_gate"))
design_gate = bool(gates.get("design_gate"))
style_scope_gate = bool(gates.get("style_scope_gate"))
must_pass_gate = bool(gates.get("must_pass_gate"))
ready_for_delivery = bool(readiness.get("ready_for_delivery"))

checks = [
    {
        "name": "phase4_executed",
        "expected": "phase4 status in completed/completed_with_findings",
        "actual": phase4_status,
        "passed": phase4_executed,
    },
    {
        "name": "requirements_gate",
        "expected": True,
        "actual": requirements_gate,
        "passed": requirements_gate,
    },
    {
        "name": "design_gate",
        "expected": True,
        "actual": design_gate,
        "passed": design_gate,
    },
    {
        "name": "style_scope_gate",
        "expected": True,
        "actual": style_scope_gate,
        "passed": style_scope_gate,
    },
    {
        "name": "must_pass_gate",
        "expected": True,
        "actual": must_pass_gate,
        "passed": must_pass_gate,
    },
    {
        "name": "ready_for_delivery",
        "expected": True,
        "actual": ready_for_delivery,
        "passed": ready_for_delivery,
    },
    {
        "name": "failed_gate_count",
        "expected": "0 (strict) / <=1 (normal) / <=2 (loose)",
        "actual": failed_gate_count,
        "passed": (
            failed_gate_count == 0 if acceptance_level == "strict"
            else (failed_gate_count <= 1 if acceptance_level == "normal" else failed_gate_count <= 2)
        ),
    },
    {
        "name": "tool_checks",
        "expected": "关键脚本 lint/typecheck/test 通过或可用性受限时跳过",
        "actual": {"failed": len(failed_tool_checks), "total": len(tool_checks)},
        "passed": len(failed_tool_checks) == 0,
    },
]

if acceptance_level == "strict":
    overall_passed = (
        phase4_executed
        and requirements_gate
        and design_gate
        and style_scope_gate
        and must_pass_gate
        and ready_for_delivery
        and failed_gate_count == 0
        and len(failed_tool_checks) == 0
    )
elif acceptance_level == "normal":
    overall_passed = (
        phase4_executed
        and requirements_gate
        and style_scope_gate
        and must_pass_gate
        and failed_gate_count <= 1
        and len(failed_tool_checks) == 0
    )
else:  # loose
    overall_passed = (
        phase4_executed
        and requirements_gate
        and failed_gate_count <= 2
        and len(failed_tool_checks) <= 1
    )

status = "completed" if overall_passed else "completed_with_risk"

risks = []
if not phase4_executed:
    risks.append("Phase4 未执行完成，验收依据不足")
if not requirements_gate:
    risks.append("需求完备度门禁未通过")
if acceptance_level in {"strict", "normal"} and not style_scope_gate:
    risks.append("样式边界门禁未通过")
if acceptance_level in {"strict", "normal"} and not must_pass_gate:
    risks.append("必过技能链未全部通过")
if acceptance_level == "strict" and not design_gate:
    risks.append("审美门禁未通过")
if acceptance_level == "strict" and not ready_for_delivery:
    risks.append("ready_for_delivery=false")
if failed_gate_count > (0 if acceptance_level == "strict" else (1 if acceptance_level == "normal" else 2)):
    risks.append(f"失败门禁数量超出 {acceptance_level} 阈值")
if failed_tool_checks:
    risks.append(f"自动验收命令失败 {len(failed_tool_checks)} 项（见 tool_checks）")

recommendations = []
if overall_passed:
    recommendations.append("Phase5 验收通过，可进入交付流程。")
else:
    recommendations.append("优先修复 gate-validation-report.json 中失败项。")
    recommendations.append("根据 acceptance-level 调整阈值，或补齐缺失质量证据后重跑 Phase5。")

report = {
    "phase": "phase5_acceptance",
    "status": status,
    "acceptance_level": acceptance_level,
    "summary": {
        "overall_passed": overall_passed,
        "failed_gate_count": failed_gate_count,
        "phase4_status": phase4_status,
        "timestamp": datetime.now(timezone.utc).isoformat(),
    },
    "checks": checks,
    "tool_checks": tool_checks,
    "failed_gates": failed_gates,
    "risks": risks,
    "recommendations": recommendations,
    "sources": {
        "scorecard": scorecard_path.name,
        "gate_validation": gate_report_path.name,
        "phase4_report": phase4_report_path.name,
    },
}

report_json.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

md = []
md.append("# Phase 5 Acceptance Report")
md.append("")
md.append(f"- status: {status}")
md.append(f"- acceptance_level: {acceptance_level}")
md.append(f"- overall_passed: {overall_passed}")
md.append(f"- failed_gate_count: {failed_gate_count}")
md.append(f"- phase4_status: {phase4_status}")
md.append("")
md.append("## Checks")
for idx, c in enumerate(checks, start=1):
    mark = "PASS" if c.get("passed") else "FAIL"
    md.append(f"{idx}. [{mark}] {c['name']} (actual={c['actual']}, expected={c['expected']})")
md.append("")
md.append("## Tool Checks")
for idx, t in enumerate(tool_checks, start=1):
    md.append(f"{idx}. [{t.get('status')}] {t.get('name')} ({t.get('script', '-')})")
md.append("")
md.append("## Risks")
if risks:
    for idx, r in enumerate(risks, start=1):
        md.append(f"{idx}. {r}")
else:
    md.append("- none")
md.append("")
md.append("## Recommendations")
for idx, rec in enumerate(recommendations, start=1):
    md.append(f"{idx}. {rec}")
md.append("")

report_md.write_text("\n".join(md), encoding="utf-8")
PY

echo "$REPORT_JSON"
