#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
flow_status.sh

Usage:
  bash skills/ui-fullflow-orchestrator/scripts/flow_status.sh [options]

Options:
  --state-file <path>     指定 flow.state.json 文件
  --workflow-dir <path>   指定某次输出目录（包含 flow.state.json）
  --workflow-id <id>      在 Ruiagents 目录中按 workflow_id 搜索
  --format <fmt>          输出格式: table|json|markdown (默认 table)
USAGE
}

STATE_FILE=""
WORKFLOW_DIR=""
WORKFLOW_ID=""
FORMAT="table"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --state-file) STATE_FILE="$2"; shift 2 ;;
    --workflow-dir) WORKFLOW_DIR="$2"; shift 2 ;;
    --workflow-id) WORKFLOW_ID="$2"; shift 2 ;;
    --format) FORMAT="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Error: unknown arg $1" >&2; usage; exit 1 ;;
  esac
done

if [[ -n "$WORKFLOW_DIR" && -z "$STATE_FILE" ]]; then
  STATE_FILE="$WORKFLOW_DIR/flow.state.json"
fi

if [[ -z "$STATE_FILE" ]]; then
  if [[ -n "$WORKFLOW_ID" ]]; then
    if [[ ! -d "Ruiagents" ]]; then
      echo "Error: Ruiagents 目录不存在，无法按 workflow_id 搜索" >&2
      exit 1
    fi
    while IFS= read -r f; do
      id="$(python3 - <<'PY' "$f"
import json, sys
path = sys.argv[1]
with open(path, "r", encoding="utf-8") as fp:
    data = json.load(fp)
print(data.get("workflow_id", ""))
PY
)"
      if [[ "$id" == "$WORKFLOW_ID" ]]; then
        STATE_FILE="$f"
        break
      fi
    done < <(find Ruiagents -type f -name "flow.state.json" | sort)
  fi
fi

if [[ -z "$STATE_FILE" ]]; then
  if [[ -d "Ruiagents" ]]; then
    STATE_FILE="$(find Ruiagents -type f -name "flow.state.json" -print0 | xargs -0 ls -1t 2>/dev/null | head -n 1 || true)"
  fi
fi

if [[ -z "${STATE_FILE:-}" || ! -f "$STATE_FILE" ]]; then
  echo "Error: 未找到 flow.state.json，请使用 --state-file 指定" >&2
  exit 1
fi

if [[ "$FORMAT" != "table" && "$FORMAT" != "json" && "$FORMAT" != "markdown" ]]; then
  echo "Error: --format 仅支持 table|json|markdown" >&2
  exit 1
fi

python3 - <<'PY' "$STATE_FILE" "$FORMAT"
import json
import sys

state_file = sys.argv[1]
fmt = sys.argv[2]

with open(state_file, "r", encoding="utf-8") as fp:
    data = json.load(fp)

skills = data.get("skills_status", {})
rows = []
status_map = {
    "completed": "✅ completed",
    "completed_with_findings": "⚠️ completed_with_findings",
    "completed_with_risk": "⚠️ completed_with_risk",
    "pending": "⏳ pending",
    "in_progress": "⏳ in_progress",
    "failed": "❌ failed",
    "skipped": "⏭ skipped",
}

def format_duration(value):
    if value is None:
        return "-"
    try:
        ms = int(value)
    except (TypeError, ValueError):
        return "-"
    if ms < 0:
        return "-"
    if ms < 1000:
        return f"{ms}ms"
    return f"{ms / 1000:.2f}s"

for name, meta in skills.items():
    out = meta.get("output") or []
    output = ", ".join(out[:3]) if out else "-"
    status_raw = meta.get("status", "-")
    rows.append((
        name,
        status_map.get(status_raw, status_raw),
        meta.get("mode", "-"),
        format_duration(meta.get("duration_ms")),
        output
    ))
rows.sort(key=lambda x: x[0])

if fmt == "json":
    print(json.dumps(data, ensure_ascii=False, indent=2))
    raise SystemExit(0)

if fmt == "markdown":
    print(f"# Flow Status: {data.get('workflow_id', '-')}")
    print("")
    print(f"- current_phase: {data.get('current_phase', '-')}")
    print(f"- updated_at: {data.get('updated_at', '-')}")
    print(f"- blockers: {len(data.get('blockers', []))}")
    print("")
    print("| Skill | Status | Mode | Duration | Output |")
    print("|---|---|---|---|---|")
    for r in rows:
        print(f"| {r[0]} | {r[1]} | {r[2]} | {r[3]} | {r[4]} |")
    raise SystemExit(0)

print(f"Workflow: {data.get('workflow_id', '-')}")
print(f"Current Phase: {data.get('current_phase', '-')}")
print(f"Updated At: {data.get('updated_at', '-')}")
print(f"Blockers: {len(data.get('blockers', []))}")
print("")
print("Skill                              Status                     Mode      Duration   Output")
print("---------------------------------  -------------------------  --------  ---------  ------------------------------")
for name, status, mode, duration, output in rows:
    print(f"{name:<33}  {status:<25}  {mode:<8}  {duration:<9}  {output}")
PY
