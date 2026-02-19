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
metrics_path = out_dir / "flow.metrics.json"
report_path = out_dir / "perf-budget.report.json"

disk_io = None
peak_mem = None
if metrics_path.exists():
    try:
        obj = json.loads(metrics_path.read_text(encoding="utf-8"))
        ru = (obj.get("metrics") or {}).get("resource_usage") or {}
        disk_io = ru.get("disk_io_mb")
        peak_mem = ru.get("peak_memory_mb")
    except Exception:
        pass

budget_disk = 10.0
budget_mem = 512.0
passed = True
if isinstance(disk_io, (int, float)) and disk_io > budget_disk:
    passed = False
if isinstance(peak_mem, (int, float)) and peak_mem > budget_mem:
    passed = False

report = {
    "plugin": "perf-budget-guard",
    "status": "pass" if passed else "warn",
    "budgets": {"disk_io_mb_max": budget_disk, "peak_memory_mb_max": budget_mem},
    "actual": {"disk_io_mb": disk_io, "peak_memory_mb": peak_mem},
}
report_path.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
PY
