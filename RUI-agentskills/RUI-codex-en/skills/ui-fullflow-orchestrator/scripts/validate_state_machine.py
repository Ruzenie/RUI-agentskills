#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
from datetime import datetime, timezone
from pathlib import Path
from typing import Any, Dict, List, Tuple


DONE_STATUSES = {"completed", "completed_with_findings", "completed_with_risk"}


def load_json(path: Path, default: Any) -> Any:
    if not path.exists():
        return default
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
        return data
    except Exception:
        return default


def validate_skill_states(skills: Dict[str, Any], states: List[str]) -> List[str]:
    issues: List[str] = []
    state_set = set(states)
    for name, meta in (skills or {}).items():
        status = str((meta or {}).get("status", ""))
        if status and status not in state_set:
            issues.append(f"技能 {name} 使用了未定义状态: {status}")
    return issues


def validate_phase_transitions(transition_log: List[Dict[str, Any]], phase_sequence: List[str]) -> List[str]:
    issues: List[str] = []
    phase_nodes = ["pending", *phase_sequence, "completed", "failed"]
    rank = {name: idx for idx, name in enumerate(phase_nodes)}
    allowed_pairs = set()
    for idx in range(len(phase_sequence) - 1):
        allowed_pairs.add((phase_sequence[idx], phase_sequence[idx + 1]))
    allowed_pairs.update(
        {
            ("pending", phase_sequence[0] if phase_sequence else "completed"),
            ("phase5_acceptance", "completed"),
            ("phase5_acceptance", "failed"),
        }
    )

    for row in transition_log or []:
        src = str(row.get("from", ""))
        dst = str(row.get("to", ""))
        if src not in rank:
            issues.append(f"transition.from 不在状态机节点中: {src}")
            continue
        if dst not in rank:
            issues.append(f"transition.to 不在状态机节点中: {dst}")
            continue
        if rank[dst] < rank[src] and dst != "failed":
            issues.append(f"检测到回退流转: {src} -> {dst}")
        if (src, dst) not in allowed_pairs and dst != "failed":
            issues.append(f"检测到未声明的阶段流转: {src} -> {dst}")
    return issues


def validate_constraints(
    constraints: Dict[str, str],
    stage_status: List[Dict[str, Any]],
    current_phase: str,
) -> List[str]:
    issues: List[str] = []
    status_map = {str(x.get("phase", "")): str(x.get("status", "")) for x in (stage_status or [])}

    def phase_done(phase_name: str) -> bool:
        return status_map.get(phase_name, "") in DONE_STATUSES

    if constraints.get("phase2_can_start") == "phase1_all_completed":
        if current_phase in {"phase2_architecture", "phase3_implementation", "phase4_self_review", "phase5_acceptance", "completed"} and not phase_done("phase1_requirements"):
            issues.append("违反约束: phase2 启动前 phase1 未完成")

    if constraints.get("phase3_can_start") == "phase2_all_completed":
        if current_phase in {"phase3_implementation", "phase4_self_review", "phase5_acceptance", "completed"} and not phase_done("phase2_architecture"):
            issues.append("违反约束: phase3 启动前 phase2 未完成")

    if constraints.get("phase4_can_start") == "phase3_all_completed":
        if current_phase in {"phase4_self_review", "phase5_acceptance", "completed"} and not phase_done("phase3_implementation"):
            issues.append("违反约束: phase4 启动前 phase3 未完成")

    if constraints.get("phase5_can_start") == "phase4_all_completed":
        if current_phase in {"phase5_acceptance", "completed"} and not phase_done("phase4_self_review"):
            issues.append("违反约束: phase5 启动前 phase4 未完成")

    return issues


def main() -> None:
    parser = argparse.ArgumentParser(description="Validate flow state with state machine rules")
    parser.add_argument("--state-file", required=True)
    parser.add_argument("--rules-file", required=True)
    parser.add_argument("--stage-status", default="")
    parser.add_argument("--report", required=True)
    args = parser.parse_args()

    state_file = Path(args.state_file)
    rules_file = Path(args.rules_file)
    report_file = Path(args.report)
    stage_status_file = Path(args.stage_status) if args.stage_status else None

    state = load_json(state_file, {})
    rules = load_json(rules_file, {})
    stage_status = load_json(stage_status_file, []) if stage_status_file else []

    rule_states = list(rules.get("states") or ["pending", "in_progress", "completed", "failed", "skipped"])
    phase_sequence = list(
        rules.get("phase_sequence")
        or ["phase1_requirements", "phase2_architecture", "phase3_implementation", "phase4_self_review", "phase5_acceptance"]
    )
    constraints = dict(rules.get("constraints") or {})
    transition_log = list(state.get("transition_log") or [])
    current_phase = str(state.get("current_phase") or "")
    skills_status = dict(state.get("skills_status") or {})

    issues: List[str] = []
    checks: List[Dict[str, Any]] = []

    skill_state_issues = validate_skill_states(skills_status, rule_states)
    checks.append({"check": "skill_states", "passed": len(skill_state_issues) == 0, "issues": skill_state_issues})
    issues.extend(skill_state_issues)

    transition_issues = validate_phase_transitions(transition_log, phase_sequence)
    checks.append({"check": "phase_transitions", "passed": len(transition_issues) == 0, "issues": transition_issues})
    issues.extend(transition_issues)

    constraint_issues = validate_constraints(constraints, stage_status, current_phase)
    checks.append({"check": "phase_constraints", "passed": len(constraint_issues) == 0, "issues": constraint_issues})
    issues.extend(constraint_issues)

    report = {
        "validated_at": datetime.now(timezone.utc).isoformat(),
        "state_file": str(state_file),
        "rules_file": str(rules_file),
        "current_phase": current_phase,
        "overall_valid": len(issues) == 0,
        "checks": checks,
        "issues": issues,
    }
    report_file.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(report, ensure_ascii=False, indent=2))

    if issues:
        raise SystemExit(2)


if __name__ == "__main__":
    main()
