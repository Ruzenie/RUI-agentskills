#!/usr/bin/env python3
from __future__ import annotations

import json
import sys
from pathlib import Path


def load(path: Path):
    with open(path, "r", encoding="utf-8") as f:
        return json.load(f)


def must(condition: bool, message: str) -> None:
    if not condition:
        raise SystemExit(message)


def main() -> None:
    if len(sys.argv) != 2:
        raise SystemExit("Usage: assert_fullflow_artifacts.py <out-dir>")

    out_dir = Path(sys.argv[1]).resolve()
    must(out_dir.exists(), f"out_dir not found: {out_dir}")

    flow_state = load(out_dir / "flow.state.json")
    flow_metrics = load(out_dir / "flow.metrics.json")
    state_machine_validation = load(out_dir / "state-machine.validation.json")
    adapter_manifest = load(out_dir / "framework.adapter.manifest.json")
    gate_report = load(out_dir / "gate-validation-report.json")

    must("state_machine_validation" in flow_state, "flow.state.json missing state_machine_validation")
    must("transition_log" in flow_state, "flow.state.json missing transition_log")
    must(isinstance(flow_state.get("skills_status"), dict), "flow.state.json skills_status invalid")
    for k, meta in flow_state.get("skills_status", {}).items():
        must("duration_ms" in meta, f"skills_status missing duration_ms: {k}")

    pe = (flow_metrics.get("metrics") or {}).get("pipeline_execution") or {}
    ru = (flow_metrics.get("metrics") or {}).get("resource_usage") or {}
    must("skill_breakdown" in pe, "flow.metrics missing skill_breakdown")
    must("timeline" in pe, "flow.metrics missing timeline")
    must(ru.get("peak_memory_mb") is not None, "flow.metrics peak_memory_mb should not be None")
    must(ru.get("disk_io_mb") is not None, "flow.metrics disk_io_mb should not be None")

    must("overall_valid" in state_machine_validation, "state-machine.validation missing overall_valid")
    must(adapter_manifest.get("adapter"), "framework.adapter.manifest missing adapter")

    summary = gate_report.get("summary") or {}
    must("overall_passed" in summary, "gate-validation-report missing summary.overall_passed")

    version_index = out_dir / ".versions" / "index.json"
    must(version_index.exists(), ".versions/index.json missing")
    index_obj = load(version_index)
    must(isinstance(index_obj.get("versions"), list) and len(index_obj.get("versions")) >= 1, "version index is empty")

    print("assertions passed")


if __name__ == "__main__":
    main()
