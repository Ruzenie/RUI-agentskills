#!/usr/bin/env bash
set -euo pipefail

OUT_DIR="${RUI_OUT_DIR:-}"
if [[ -z "$OUT_DIR" ]]; then
  echo "RUI_OUT_DIR is required" >&2
  exit 1
fi

if [[ -f "$OUT_DIR/custom-report.json" ]]; then
  python3 - <<'PY' "$OUT_DIR/custom-report.json"
import json
import sys
p = sys.argv[1]
with open(p, 'r', encoding='utf-8') as f:
    d = json.load(f)
d['status'] = 'completed'
d['phase'] = 'phase5_acceptance'
d['when'] = 'after'
d['message'] = 'post-acceptance hook executed'
with open(p, 'w', encoding='utf-8') as f:
    json.dump(d, f, ensure_ascii=False, indent=2)
    f.write('\n')
PY
else
  cat > "$OUT_DIR/custom-report.json" <<JSON
{
  "plugin": "${RUI_PLUGIN_NAME:-my-custom-skill}",
  "phase": "${RUI_PHASE:-phase5_acceptance}",
  "when": "${RUI_WHEN:-after}",
  "status": "completed",
  "message": "post-acceptance hook executed"
}
JSON
fi
