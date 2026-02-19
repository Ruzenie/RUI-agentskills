#!/usr/bin/env bash
set -euo pipefail

OUT_DIR="${RUI_OUT_DIR:-}"
if [[ -z "$OUT_DIR" ]]; then
  echo "RUI_OUT_DIR is required" >&2
  exit 1
fi

cat > "$OUT_DIR/custom-report.json" <<JSON
{
  "plugin": "${RUI_PLUGIN_NAME:-my-custom-skill}",
  "phase": "${RUI_PHASE:-phase4_self_review}",
  "when": "${RUI_WHEN:-before}",
  "status": "prepared",
  "message": "pre-refactor hook executed"
}
JSON
