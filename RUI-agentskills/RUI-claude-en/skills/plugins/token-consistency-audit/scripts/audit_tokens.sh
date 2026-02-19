#!/usr/bin/env bash
set -euo pipefail

OUT_DIR="${RUI_OUT_DIR:-}"
if [[ -z "$OUT_DIR" ]]; then
  echo "RUI_OUT_DIR is required" >&2
  exit 1
fi

python3 - <<'PY' "$OUT_DIR"
import json
import sys
from pathlib import Path

out_dir = Path(sys.argv[1])
json_path = out_dir / "tokens.json"
css_path = out_dir / "tokens.css"
report_path = out_dir / "token-consistency.report.json"

json_exists = json_path.exists()
css_exists = css_path.exists()
json_size = json_path.stat().st_size if json_exists else 0
css_size = css_path.stat().st_size if css_exists else 0

report = {
    "plugin": "token-consistency-audit",
    "status": "pass" if (json_exists and css_exists) else "warn",
    "checks": {
        "tokens_json_exists": json_exists,
        "tokens_css_exists": css_exists,
        "tokens_json_size": json_size,
        "tokens_css_size": css_size,
    },
}
report_path.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
PY
