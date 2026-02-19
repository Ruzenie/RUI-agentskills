#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../../.." && pwd)"

usage() {
  cat <<'USAGE'
run_phase4_refactor.sh

Usage:
  bash skills/ui-fullflow-orchestrator/scripts/run_phase4_refactor.sh \
    --workspace-root /path/to/workspace \
    --out-dir /path/to/Ruiagents/xxx \
    --refactor-threshold 200 \
    --render-threshold 30 \
    --duplicate-threshold 3 \
    --props-depth-threshold 3
USAGE
}

WORKSPACE_ROOT=""
OUT_DIR=""
REFACTOR_THRESHOLD="200"
RENDER_THRESHOLD="30"
DUPLICATE_THRESHOLD="3"
PROPS_DEPTH_THRESHOLD="3"
ARG_REFACTOR_THRESHOLD_SET="0"
ARG_RENDER_THRESHOLD_SET="0"
ARG_DUPLICATE_THRESHOLD_SET="0"
ARG_PROPS_DEPTH_THRESHOLD_SET="0"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --workspace-root) WORKSPACE_ROOT="$2"; shift 2 ;;
    --out-dir) OUT_DIR="$2"; shift 2 ;;
    --refactor-threshold) REFACTOR_THRESHOLD="$2"; ARG_REFACTOR_THRESHOLD_SET="1"; shift 2 ;;
    --render-threshold) RENDER_THRESHOLD="$2"; ARG_RENDER_THRESHOLD_SET="1"; shift 2 ;;
    --duplicate-threshold) DUPLICATE_THRESHOLD="$2"; ARG_DUPLICATE_THRESHOLD_SET="1"; shift 2 ;;
    --props-depth-threshold) PROPS_DEPTH_THRESHOLD="$2"; ARG_PROPS_DEPTH_THRESHOLD_SET="1"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown arg: $1" >&2; usage; exit 1 ;;
  esac
done

if [[ -z "$WORKSPACE_ROOT" || -z "$OUT_DIR" ]]; then
  echo "Error: 缺少 --workspace-root 或 --out-dir" >&2
  usage
  exit 1
fi

eval "$(python3 "$REPO_ROOT/skills/skill-structure-governor/scripts/config_loader.py" --repo-root "$REPO_ROOT" --workspace-root "$WORKSPACE_ROOT" --print-env)"
if [[ "$ARG_REFACTOR_THRESHOLD_SET" != "1" && -n "${RUI_CFG_REFACTOR_FILE_LINES:-}" ]]; then
  REFACTOR_THRESHOLD="$RUI_CFG_REFACTOR_FILE_LINES"
fi
if [[ "$ARG_RENDER_THRESHOLD_SET" != "1" && -n "${RUI_CFG_REFACTOR_RENDER_LINES:-}" ]]; then
  RENDER_THRESHOLD="$RUI_CFG_REFACTOR_RENDER_LINES"
fi
if [[ "$ARG_DUPLICATE_THRESHOLD_SET" != "1" && -n "${RUI_CFG_REFACTOR_PATTERN_REPEAT:-}" ]]; then
  DUPLICATE_THRESHOLD="$RUI_CFG_REFACTOR_PATTERN_REPEAT"
fi
if [[ "$ARG_PROPS_DEPTH_THRESHOLD_SET" != "1" && -n "${RUI_CFG_REFACTOR_PROP_DRILL:-}" ]]; then
  PROPS_DEPTH_THRESHOLD="$RUI_CFG_REFACTOR_PROP_DRILL"
fi

for v in "$REFACTOR_THRESHOLD" "$RENDER_THRESHOLD" "$DUPLICATE_THRESHOLD" "$PROPS_DEPTH_THRESHOLD"; do
  if ! [[ "$v" =~ ^[0-9]+$ ]]; then
    echo "Error: 阈值参数必须是非负整数" >&2
    exit 1
  fi
done

REPORT_JSON="$OUT_DIR/phase4.refactor.report.json"
REPORT_MD="$OUT_DIR/phase4.refactor.report.md"

python3 - <<'PY' "$WORKSPACE_ROOT" "$REFACTOR_THRESHOLD" "$RENDER_THRESHOLD" "$DUPLICATE_THRESHOLD" "$PROPS_DEPTH_THRESHOLD" "$REPORT_JSON" "$REPORT_MD"
import json
import re
import sys
from collections import Counter
from datetime import datetime, timezone
from pathlib import Path

workspace_root = Path(sys.argv[1]).resolve()
file_line_threshold = int(sys.argv[2])
render_threshold = int(sys.argv[3])
duplicate_threshold = int(sys.argv[4])
props_depth_threshold = int(sys.argv[5])
report_json = Path(sys.argv[6])
report_md = Path(sys.argv[7])

if not workspace_root.exists():
    raise SystemExit(f"workspace root 不存在: {workspace_root}")

source_ext = {".ts", ".tsx", ".js", ".jsx", ".css", ".scss", ".vue", ".svelte"}
logic_ext = {".ts", ".tsx", ".js", ".jsx", ".vue", ".svelte"}
skip_dirs = {".git", "node_modules", "dist", "build", ".next", "coverage", "Ruiagents"}

jsx_like_pattern = re.compile(r"<[A-Za-z][A-Za-z0-9_.:-]*([\s>/]|$)")
forward_prop_pattern = re.compile(r"\b([A-Za-z_][A-Za-z0-9_]*)\s*=\s*\{\1\}")
spread_prop_pattern = re.compile(r"\{\s*\.\.\.([A-Za-z_][A-Za-z0-9_]*)\s*\}")

files = []
for p in workspace_root.rglob("*"):
    if not p.is_file():
        continue
    if any(part in skip_dirs for part in p.parts):
        continue
    if p.suffix.lower() in source_ext:
        files.append(p)

findings = []
metric_counts = {
    "file_lines": 0,
    "render_logic_lines": 0,
    "repeated_pattern_count": 0,
    "props_drilling_depth": 0,
}

def is_noise_line(text: str) -> bool:
    s = text.strip()
    return (
        not s
        or s.startswith("//")
        or s.startswith("/*")
        or s.startswith("*")
        or s.startswith("<!--")
        or s.startswith("import ")
        or s.startswith("export ")
    )

for file_path in files:
    try:
        lines = file_path.read_text(encoding="utf-8", errors="ignore").splitlines()
    except Exception:
        continue

    relative_file = str(file_path.relative_to(workspace_root))

    # 1) 单文件行数
    line_count = len(lines)
    if line_count > file_line_threshold:
        findings.append(
            {
                "file": relative_file,
                "metric": "file_lines",
                "actual": line_count,
                "threshold": file_line_threshold,
                "reason": f"文件行数超过阈值 {file_line_threshold}",
            }
        )
        metric_counts["file_lines"] += 1

    # 后续三项仅对逻辑文件执行
    if file_path.suffix.lower() not in logic_ext:
        continue

    # 2) 渲染逻辑行数（启发式：JSX/模板行）
    render_line_count = 0
    for line in lines:
        if is_noise_line(line):
            continue
        if jsx_like_pattern.search(line):
            render_line_count += 1
    if render_line_count > render_threshold:
        findings.append(
            {
                "file": relative_file,
                "metric": "render_logic_lines",
                "actual": render_line_count,
                "threshold": render_threshold,
                "reason": f"渲染逻辑行数超过阈值 {render_threshold}",
            }
        )
        metric_counts["render_logic_lines"] += 1

    # 3) 相同模式重复次数（启发式）
    normalized_counter = Counter()
    for line in lines:
        if is_noise_line(line):
            continue
        normalized = re.sub(r"\s+", " ", line.strip())
        if len(normalized) < 24:
            continue
        if "<" not in normalized and "className=" not in normalized and "class=" not in normalized:
            continue
        normalized_counter[normalized] += 1

    if normalized_counter:
        repeated_pattern, repeated_count = max(normalized_counter.items(), key=lambda x: x[1])
    else:
        repeated_pattern, repeated_count = "", 0

    if repeated_count >= duplicate_threshold:
        findings.append(
            {
                "file": relative_file,
                "metric": "repeated_pattern_count",
                "actual": repeated_count,
                "threshold": duplicate_threshold,
                "reason": f"检测到重复模式次数 >= {duplicate_threshold}",
                "sample": (repeated_pattern[:117] + "...") if len(repeated_pattern) > 120 else repeated_pattern,
            }
        )
        metric_counts["repeated_pattern_count"] += 1

    # 4) Props 穿透层级（启发式：同名 props 原样透传次数）
    forward_counter = Counter()
    for line in lines:
        if is_noise_line(line):
            continue
        for m in forward_prop_pattern.finditer(line):
            forward_counter[m.group(1)] += 1
        for m in spread_prop_pattern.finditer(line):
            forward_counter[m.group(1)] += 1

    prop_name = ""
    forward_depth = 0
    if forward_counter:
        prop_name, forward_depth = max(forward_counter.items(), key=lambda x: x[1])

    if forward_depth > props_depth_threshold:
        findings.append(
            {
                "file": relative_file,
                "metric": "props_drilling_depth",
                "actual": forward_depth,
                "threshold": props_depth_threshold,
                "reason": f"疑似 props 穿透层级超过阈值 {props_depth_threshold}",
                "prop": prop_name,
            }
        )
        metric_counts["props_drilling_depth"] += 1

status = "completed_with_findings" if findings else "completed"

summary = {
    "phase": "phase4_self_review",
    "status": status,
    "workspace_root": str(workspace_root),
    "thresholds": {
        "file_lines": file_line_threshold,
        "render_logic_lines": render_threshold,
        "repeated_pattern_count": duplicate_threshold,
        "props_drilling_depth": props_depth_threshold,
    },
    "total_source_files": len(files),
    "findings_count": len(findings),
    "metric_counts": metric_counts,
    "timestamp": datetime.now(timezone.utc).isoformat(),
}

recommendations = []
if metric_counts["file_lines"] > 0:
    recommendations.append("优先处理超长文件，按页面结构与组件职责拆分。")
if metric_counts["render_logic_lines"] > 0:
    recommendations.append("将冗长渲染逻辑提取为子组件，降低主组件复杂度。")
if metric_counts["repeated_pattern_count"] > 0:
    recommendations.append("提取重复 UI 模式为复用组件或渲染函数。")
if metric_counts["props_drilling_depth"] > 0:
    recommendations.append("对疑似 props 穿透链路引入 Context/组合式状态收敛。")
if not recommendations:
    recommendations.append("未命中重构阈值，可进入验收阶段。")

report_obj = {
    "summary": summary,
    "findings": findings,
    "recommendations": recommendations,
    "status": status,
}

report_json.write_text(json.dumps(report_obj, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

md_lines = [
    "# Phase 4 Refactor Report",
    "",
    f"- status: {status}",
    f"- total_source_files: {len(files)}",
    f"- thresholds: file_lines={file_line_threshold}, render_logic_lines={render_threshold}, repeated_pattern_count={duplicate_threshold}, props_drilling_depth={props_depth_threshold}",
    f"- findings_count: {len(findings)}",
    "",
    "## Metric Counts",
    f"- file_lines: {metric_counts['file_lines']}",
    f"- render_logic_lines: {metric_counts['render_logic_lines']}",
    f"- repeated_pattern_count: {metric_counts['repeated_pattern_count']}",
    f"- props_drilling_depth: {metric_counts['props_drilling_depth']}",
    "",
    "## Findings",
]
if findings:
    for idx, item in enumerate(findings, start=1):
        extra = []
        if item.get("prop"):
            extra.append(f"prop={item['prop']}")
        if item.get("sample"):
            extra.append(f"sample={item['sample']}")
        extra_text = f" [{'; '.join(extra)}]" if extra else ""
        md_lines.append(
            f"{idx}. {item['file']} - {item['metric']}: {item['reason']} (actual={item['actual']}, threshold={item['threshold']}){extra_text}"
        )
else:
    md_lines.append("- none")
md_lines.append("")
md_lines.append("## Recommendations")
for idx, rec in enumerate(recommendations, start=1):
    md_lines.append(f"{idx}. {rec}")
md_lines.append("")
report_md.write_text("\n".join(md_lines), encoding="utf-8")
PY

echo "$REPORT_JSON"
