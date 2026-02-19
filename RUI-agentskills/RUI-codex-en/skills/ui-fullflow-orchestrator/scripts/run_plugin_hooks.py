#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import os
import subprocess
from datetime import datetime, timezone
from pathlib import Path
from typing import Any, Dict, List

DONE_STATUSES = {"completed", "completed_with_findings", "completed_with_risk"}


def load_json(path: Path, default: Any) -> Any:
    if not path.exists():
        return default
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
        return data
    except Exception:
        return default


def load_plugin(path: Path) -> Dict[str, Any]:
    data = load_json(path, {})
    return data if isinstance(data, dict) else {}


def dependencies_passed(plugin: Dict[str, Any], flow_state: Dict[str, Any]) -> tuple[bool, List[str]]:
    deps = plugin.get("dependencies") or []
    if not deps:
        return True, []
    if not flow_state:
        return True, []
    skills = flow_state.get("skills_status") if isinstance(flow_state, dict) else {}
    if not isinstance(skills, dict):
        skills = {}

    missing = []
    for dep in deps:
        meta = skills.get(dep) if isinstance(dep, str) else None
        status = (meta or {}).get("status") if isinstance(meta, dict) else None
        if status not in DONE_STATUSES:
            missing.append(str(dep))
    return len(missing) == 0, missing


def find_artifact(path_text: str, out_dir: Path, workspace_root: Path, plugin_dir: Path) -> bool:
    candidate = Path(path_text)
    checks = []
    if candidate.is_absolute():
        checks.append(candidate)
    else:
        checks.extend([out_dir / candidate, workspace_root / candidate, plugin_dir / candidate])
    return any(p.exists() for p in checks)


def main() -> None:
    parser = argparse.ArgumentParser(description="Run plugin hooks")
    parser.add_argument("--repo-root", required=True)
    parser.add_argument("--phase", required=True)
    parser.add_argument("--when", required=True)
    parser.add_argument("--workspace-root", required=True)
    parser.add_argument("--out-dir", required=True)
    parser.add_argument("--state-file", default="")
    parser.add_argument("--report", required=True)
    args = parser.parse_args()

    repo_root = Path(args.repo_root)
    workspace_root = Path(args.workspace_root).resolve()
    out_dir = Path(args.out_dir).resolve()
    plugins_root = repo_root / "skills" / "plugins"
    report_path = Path(args.report)
    state_file = Path(args.state_file) if args.state_file else None
    flow_state = load_json(state_file, {}) if state_file else {}

    rows: List[Dict[str, Any]] = []
    if plugins_root.exists():
        for plugin_yaml in sorted(plugins_root.glob("*/plugin.yaml")):
            plugin = load_plugin(plugin_yaml)
            if not plugin:
                continue
            hooks = plugin.get("hooks") or []
            plugin_name = str(plugin.get("name") or plugin_yaml.parent.name)
            dep_ok, dep_missing = dependencies_passed(plugin, flow_state)
            expected_artifacts = [x for x in (plugin.get("artifacts") or []) if isinstance(x, str) and x.strip()]

            for hook in hooks:
                if hook.get("phase") != args.phase or hook.get("when") != args.when:
                    continue

                action_rel = str(hook.get("action") or "").strip()
                action = plugin_yaml.parent / action_rel
                row: Dict[str, Any] = {
                    "plugin": plugin_name,
                    "phase": args.phase,
                    "when": args.when,
                    "action": action_rel,
                    "status": "skipped",
                    "timestamp": datetime.now(timezone.utc).isoformat(),
                    "dependencies": plugin.get("dependencies") or [],
                    "artifacts": expected_artifacts,
                }

                if not dep_ok:
                    row["status"] = "skipped"
                    row["reason"] = f"dependencies_not_ready: {', '.join(dep_missing)}"
                    rows.append(row)
                    continue

                if not action.exists() or not action.is_file():
                    row["status"] = "skipped"
                    row["reason"] = "action_not_found"
                    rows.append(row)
                    continue

                cmd = [str(action)] if os.access(action, os.X_OK) else ["bash", str(action)]
                env = dict(os.environ)
                env.update(
                    {
                        "RUI_OUT_DIR": str(out_dir),
                        "RUI_WORKSPACE_ROOT": str(workspace_root),
                        "RUI_PHASE": args.phase,
                        "RUI_WHEN": args.when,
                        "RUI_PLUGIN_NAME": plugin_name,
                    }
                )

                try:
                    proc = subprocess.run(
                        cmd,
                        cwd=workspace_root,
                        capture_output=True,
                        text=True,
                        timeout=120,
                        env=env,
                    )
                    row["status"] = "completed" if proc.returncode == 0 else "failed"
                    row["exit_code"] = proc.returncode
                    row["stdout"] = (proc.stdout or "")[:500]
                    row["stderr"] = (proc.stderr or "")[:500]
                except Exception as exc:
                    row["status"] = "failed"
                    row["error"] = str(exc)

                if row["status"] == "completed" and expected_artifacts:
                    missing_artifacts = [
                        item
                        for item in expected_artifacts
                        if not find_artifact(item, out_dir, workspace_root, plugin_yaml.parent)
                    ]
                    if missing_artifacts:
                        row["status"] = "failed"
                        row["reason"] = "artifacts_missing"
                        row["missing_artifacts"] = missing_artifacts

                rows.append(row)

    summary = {
        "total": len(rows),
        "completed": len([x for x in rows if x.get("status") == "completed"]),
        "failed": len([x for x in rows if x.get("status") == "failed"]),
        "skipped": len([x for x in rows if x.get("status") == "skipped"]),
    }
    report = {
        "phase": args.phase,
        "when": args.when,
        "generated_at": datetime.now(timezone.utc).isoformat(),
        "summary": summary,
        "hooks": rows,
    }
    report_path.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(report, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
