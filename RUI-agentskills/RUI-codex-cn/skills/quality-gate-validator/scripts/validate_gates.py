#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import re
import subprocess
from datetime import datetime, timezone
from pathlib import Path
from typing import Any, Dict, List, Tuple


def load(path: Path, default: Dict[str, Any] | List[Any] | None = None):
    if default is None:
        default = {}
    if not path.exists():
        return default
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except Exception:
        return default


def load_json_compatible_yaml(path: Path) -> Dict[str, Any]:
    if not path.exists():
        return {}
    raw = path.read_text(encoding="utf-8").strip()
    if not raw:
        return {}
    try:
        obj = json.loads(raw)
        return obj if isinstance(obj, dict) else {}
    except Exception:
        return {}


def merge_dict(base: Dict[str, Any], override: Dict[str, Any]) -> Dict[str, Any]:
    out = dict(base)
    for k, v in (override or {}).items():
        if isinstance(v, dict) and isinstance(out.get(k), dict):
            out[k] = merge_dict(out[k], v)
        else:
            out[k] = v
    return out


def load_thresholds(repo_root: Path, workspace_root: Path) -> Dict[str, Any]:
    defaults = {
        "requirement_completeness_min": 70,
        "design_score_min_5": 4.0,
        "component_reuse_rate_min": 40,
        "cyclomatic_complexity_max": 10,
        "ts_type_coverage_min": 90,
        "color_contrast_min": "4.5:1",
    }
    merged = dict(defaults)
    for candidate in [repo_root / ".rui-config.yaml", workspace_root / ".rui-config.yaml", Path.home() / ".rui-config.yaml"]:
        cfg = load_json_compatible_yaml(candidate)
        gates = cfg.get("quality_gates") if isinstance(cfg, dict) else {}
        if isinstance(gates, dict):
            merged = merge_dict(merged, gates)
    return merged


def gate_row(name: str, threshold: str, actual: Any, passed: bool, evidence: str) -> Dict[str, Any]:
    return {
        "gate": name,
        "threshold": threshold,
        "actual": actual,
        "status": "✅ PASS" if passed else "❌ FAIL",
        "evidence": evidence,
    }


def detect_runner(workspace_root: Path) -> List[str]:
    if (workspace_root / "pnpm-lock.yaml").exists():
        return ["pnpm"]
    if (workspace_root / "yarn.lock").exists():
        return ["yarn"]
    return ["npm"]


def run_tool_checks(workspace_root: Path) -> Tuple[List[Dict[str, Any]], Dict[str, bool]]:
    checks: List[Dict[str, Any]] = []
    gate_flags = {
        "lint_gate": True,
        "typecheck_gate": True,
        "test_gate": True,
        "a11y_gate": True,
        "performance_gate": True,
    }
    package_json = workspace_root / "package.json"
    if not package_json.exists():
        checks.append({"name": "toolchain", "status": "skipped", "reason": "package.json_not_found"})
        return checks, gate_flags

    try:
        pkg = json.loads(package_json.read_text(encoding="utf-8"))
    except Exception:
        checks.append({"name": "toolchain", "status": "skipped", "reason": "package_json_invalid"})
        return checks, gate_flags

    scripts = (pkg or {}).get("scripts") or {}
    runner = detect_runner(workspace_root)
    matrix = [
        ("lint", "lint", "lint_gate"),
        ("typecheck", "typecheck", "typecheck_gate"),
        ("test", "test", "test_gate"),
        ("a11y", "a11y", "a11y_gate"),
        ("lighthouse", "lighthouse", "performance_gate"),
    ]
    for name, script_key, gate_key in matrix:
        if script_key not in scripts:
            checks.append({"name": name, "script": script_key, "status": "skipped", "reason": "script_not_found"})
            continue
        cmd = [*runner, "run", script_key]
        try:
            proc = subprocess.run(cmd, cwd=workspace_root, capture_output=True, text=True, timeout=300)
            passed = proc.returncode == 0
            checks.append({
                "name": name,
                "script": script_key,
                "status": "passed" if passed else "failed",
                "exit_code": proc.returncode,
                "stdout_tail": (proc.stdout or "")[-500:],
                "stderr_tail": (proc.stderr or "")[-500:],
            })
            if not passed:
                gate_flags[gate_key] = False
        except Exception as exc:
            checks.append({"name": name, "script": script_key, "status": "failed", "error": str(exc)})
            gate_flags[gate_key] = False
    return checks, gate_flags


def collect_source_files(workspace_root: Path, exts: set[str]) -> List[Path]:
    skip_dirs = {".git", "node_modules", "dist", "build", ".next", "coverage", "Ruiagents"}
    out: List[Path] = []
    if not workspace_root.exists():
        return out
    for p in workspace_root.rglob("*"):
        if not p.is_file():
            continue
        if any(part in skip_dirs for part in p.parts):
            continue
        if p.suffix.lower() in exts:
            out.append(p)
    return out


def measure_component_reuse(workspace_root: Path) -> Dict[str, Any]:
    files = collect_source_files(workspace_root, {".tsx", ".jsx", ".vue", ".svelte"})
    if not files:
        return {"available": False, "reuse_rate": None, "evidence": "no_component_source_files", "summary": {}}

    html_tags = {
        "div", "span", "p", "a", "ul", "ol", "li", "button", "input", "textarea", "label", "select", "option",
        "form", "section", "header", "footer", "main", "aside", "nav", "article", "img", "svg", "path", "g", "canvas",
        "table", "thead", "tbody", "tr", "td", "th", "h1", "h2", "h3", "h4", "h5", "h6",
    }
    tag_counter: Dict[str, int] = {}
    pattern = re.compile(r"<([A-Za-z][A-Za-z0-9_-]*)\\b")

    for file_path in files:
        content = file_path.read_text(encoding="utf-8", errors="ignore")
        for match in pattern.findall(content):
            tag = match.strip()
            lower = tag.lower()
            is_custom = tag[:1].isupper() or ("-" in tag and lower not in html_tags)
            if not is_custom:
                continue
            tag_counter[tag] = tag_counter.get(tag, 0) + 1

    total_usage = sum(tag_counter.values())
    if total_usage == 0:
        return {
            "available": False,
            "reuse_rate": None,
            "evidence": "no_custom_component_usage_detected",
            "summary": {"component_files": len(files)},
        }

    reused_occurrences = sum(count for count in tag_counter.values() if count > 1)
    reuse_rate = round((reused_occurrences / total_usage) * 100.0, 2)
    top_components = sorted(tag_counter.items(), key=lambda x: x[1], reverse=True)[:5]
    return {
        "available": True,
        "reuse_rate": reuse_rate,
        "evidence": "astless_component_tag_scan",
        "summary": {
            "component_files": len(files),
            "unique_components": len(tag_counter),
            "total_component_usage": total_usage,
            "reused_occurrences": reused_occurrences,
            "top_components": top_components,
        },
    }


def measure_cyclomatic_complexity(workspace_root: Path) -> Dict[str, Any]:
    files = collect_source_files(workspace_root, {".ts", ".tsx", ".js", ".jsx", ".vue", ".svelte"})
    if not files:
        return {"available": False, "max_complexity": None, "evidence": "no_logic_source_files", "summary": {}}

    keyword_patterns = [
        re.compile(r"\\bif\\b"),
        re.compile(r"\\bfor\\b"),
        re.compile(r"\\bwhile\\b"),
        re.compile(r"\\bcase\\b"),
        re.compile(r"\\bcatch\\b"),
        re.compile(r"&&"),
        re.compile(r"\\|\\|"),
        re.compile(r"\\?.*:"),
    ]

    max_complexity = 1
    max_file = ""
    for file_path in files:
        content = file_path.read_text(encoding="utf-8", errors="ignore")
        complexity = 1
        for pattern in keyword_patterns:
            complexity += len(pattern.findall(content))
        if complexity > max_complexity:
            max_complexity = complexity
            max_file = str(file_path.relative_to(workspace_root))

    return {
        "available": True,
        "max_complexity": max_complexity,
        "evidence": "keyword_based_static_scan",
        "summary": {
            "logic_files": len(files),
            "max_complexity_file": max_file,
        },
    }


def parse_percent(text: str) -> float | None:
    m = re.search(r"(\\d+(?:\\.\\d+)?)%", text or "")
    if not m:
        return None
    try:
        return float(m.group(1))
    except Exception:
        return None


def measure_ts_coverage(workspace_root: Path) -> Dict[str, Any]:
    ts_files = [
        p for p in collect_source_files(workspace_root, {".ts", ".tsx"})
        if not p.name.endswith(".d.ts")
    ]
    if not ts_files:
        return {"available": False, "coverage": None, "evidence": "no_ts_files", "summary": {}}

    package_json = workspace_root / "package.json"
    runner = detect_runner(workspace_root)
    if package_json.exists():
        try:
            pkg = json.loads(package_json.read_text(encoding="utf-8"))
            scripts = (pkg or {}).get("scripts") or {}
            if "type-coverage" in scripts:
                cmd = [*runner, "run", "type-coverage"]
                proc = subprocess.run(cmd, cwd=workspace_root, capture_output=True, text=True, timeout=300)
                pct = parse_percent((proc.stdout or "") + "\n" + (proc.stderr or ""))
                if pct is not None:
                    return {
                        "available": True,
                        "coverage": round(pct, 2),
                        "evidence": "script:type-coverage",
                        "summary": {"runner": runner[0], "exit_code": proc.returncode},
                    }
        except Exception:
            pass

    # Fallback: static explicit-type ratio from source text.
    var_decl = re.compile(r"\\b(?:const|let|var)\\s+[A-Za-z_$][\\w$]*")
    typed_var_decl = re.compile(r"\\b(?:const|let|var)\\s+[A-Za-z_$][\\w$]*\\s*:\\s*[^=;]+")
    fn_params = re.compile(r"(?:function\\s+[A-Za-z_$][\\w$]*|function|=>)\\s*\\(([^)]*)\\)")
    total_points = 0
    typed_points = 0

    for file_path in ts_files:
        content = file_path.read_text(encoding="utf-8", errors="ignore")
        vars_total = len(var_decl.findall(content))
        vars_typed = len(typed_var_decl.findall(content))
        total_points += vars_total
        typed_points += vars_typed

        for raw in fn_params.findall(content):
            params = [p.strip() for p in raw.split(",") if p.strip() and p.strip() not in {"...args", "args"}]
            if not params:
                continue
            total_points += len(params)
            typed_points += len([p for p in params if ":" in p])

    if total_points == 0:
        return {
            "available": False,
            "coverage": None,
            "evidence": "no_type_points_detected",
            "summary": {"ts_files": len(ts_files)},
        }

    pct = round((typed_points / total_points) * 100.0, 2)
    return {
        "available": True,
        "coverage": pct,
        "evidence": "static_explicit_type_ratio",
        "summary": {
            "ts_files": len(ts_files),
            "typed_points": typed_points,
            "total_points": total_points,
        },
    }


def bool_or_true_if_none(v: float | int | None, fn) -> bool:
    if v is None:
        return True
    return bool(fn(v))


def main() -> None:
    parser = argparse.ArgumentParser(description="Validate quality gates")
    parser.add_argument("--out-dir", required=True)
    parser.add_argument("--workspace-root", default="")
    parser.add_argument("--repo-root", default="")
    parser.add_argument("--report", required=True)
    parser.add_argument("--tool-checks", choices=["auto", "on", "off"], default="auto")
    args = parser.parse_args()

    out_dir = Path(args.out_dir)
    workspace_root = Path(args.workspace_root).resolve() if args.workspace_root else Path(".").resolve()
    repo_root = Path(args.repo_root).resolve() if args.repo_root else Path(__file__).resolve().parents[3]
    report = Path(args.report)

    scorecard = load(out_dir / "self-eval.scorecard.json", {})
    req = load(out_dir / "requirements.summary.json", {})
    aesthetic = load(out_dir / "aesthetic.score.json", {})
    scope_lock = load(out_dir / "style.scope.lock.json", {})
    icon_analysis = load(out_dir / "icon.need.analysis.json", {})
    p5 = load(out_dir / "phase5.acceptance.report.json", {})

    cfg_thresholds = load_thresholds(repo_root, workspace_root)
    scorecard_thresholds = (scorecard.get("thresholds") or {})
    thresholds = merge_dict(cfg_thresholds, {
        "requirement_completeness_min": scorecard_thresholds.get("requirement_completeness_min", cfg_thresholds["requirement_completeness_min"]),
        "design_score_min_5": scorecard_thresholds.get("design_score_min_5", cfg_thresholds["design_score_min_5"]),
        "component_reuse_rate_min": scorecard_thresholds.get("component_reuse_rate_min", cfg_thresholds["component_reuse_rate_min"]),
        "cyclomatic_complexity_max": scorecard_thresholds.get("cyclomatic_complexity_max", cfg_thresholds["cyclomatic_complexity_max"]),
        "ts_type_coverage_min": scorecard_thresholds.get("ts_type_coverage_min", cfg_thresholds["ts_type_coverage_min"]),
    })

    gates = scorecard.get("gates") or {}
    metrics = scorecard.get("metrics") or {}

    req_min = int(thresholds.get("requirement_completeness_min", 70))
    design_min = float(thresholds.get("design_score_min_5", 4.0))
    reuse_min = int(thresholds.get("component_reuse_rate_min", 40))
    complexity_max = int(thresholds.get("cyclomatic_complexity_max", 10))
    ts_min = int(thresholds.get("ts_type_coverage_min", 90))

    req_score = int(req.get("completeness_score", metrics.get("requirement_completeness", 0)) or 0)
    design_score = float(metrics.get("design_score_5", 0) or 0)
    if design_score <= 0:
        design_raw = float(aesthetic.get("total_score", 0) or 0)
        design_score = round((design_raw / 35.0) * 5.0, 2) if design_raw > 0 else 0.0

    style_scope_gate = bool(gates.get("style_scope_gate")) if "style_scope_gate" in gates else bool(scope_lock.get("scope_locked", False) or not scope_lock)
    icon_gate = bool(gates.get("icon_gate")) if "icon_gate" in gates else bool(not icon_analysis or icon_analysis.get("needed", False))
    must_pass_gate = bool(gates.get("must_pass_gate")) if "must_pass_gate" in gates else True

    reuse_metric = measure_component_reuse(workspace_root)
    complexity_metric = measure_cyclomatic_complexity(workspace_root)
    ts_metric = measure_ts_coverage(workspace_root)

    tool_checks: List[Dict[str, Any]] = []
    tool_gate_flags = {"lint_gate": True, "typecheck_gate": True, "test_gate": True, "a11y_gate": True, "performance_gate": True}
    if args.tool_checks == "on":
        tool_checks, tool_gate_flags = run_tool_checks(workspace_root)
    elif args.tool_checks == "auto":
        if p5 and isinstance(p5.get("tool_checks"), list):
            tool_checks = p5.get("tool_checks") or []
            for row in tool_checks:
                if row.get("status") == "failed":
                    name = row.get("name")
                    if name == "lint":
                        tool_gate_flags["lint_gate"] = False
                    elif name == "typecheck":
                        tool_gate_flags["typecheck_gate"] = False
                    elif name == "test":
                        tool_gate_flags["test_gate"] = False
                    elif name == "a11y":
                        tool_gate_flags["a11y_gate"] = False
                    elif name == "lighthouse":
                        tool_gate_flags["performance_gate"] = False

    details = [
        gate_row("requirement_completeness", f">= {req_min}", req_score, req_score >= req_min, "requirements.summary.json"),
        gate_row("design_score", f">= {design_min}", design_score, design_score >= design_min, "aesthetic.score.json"),
        gate_row("style_scope_gate", "scorecard.gates.style_scope_gate = true", gates.get("style_scope_gate", "derived"), style_scope_gate, "self-eval.scorecard.json/style.scope.lock.json"),
        gate_row("icon_gate", "scorecard.gates.icon_gate = true", gates.get("icon_gate", "derived"), icon_gate, "self-eval.scorecard.json/icon.need.analysis.json"),
        gate_row("must_pass_gate", "scorecard.gates.must_pass_gate = true", gates.get("must_pass_gate", "derived"), must_pass_gate, "flow.state.json/self-eval.scorecard.json"),
        gate_row(
            "component_reuse_rate",
            f">= {reuse_min}",
            reuse_metric.get("reuse_rate") if reuse_metric.get("reuse_rate") is not None else "N/A",
            bool_or_true_if_none(reuse_metric.get("reuse_rate"), lambda x: x >= reuse_min),
            f"{reuse_metric.get('evidence')} | {reuse_metric.get('summary')}",
        ),
        gate_row(
            "cyclomatic_complexity",
            f"<= {complexity_max}",
            complexity_metric.get("max_complexity") if complexity_metric.get("max_complexity") is not None else "N/A",
            bool_or_true_if_none(complexity_metric.get("max_complexity"), lambda x: x <= complexity_max),
            f"{complexity_metric.get('evidence')} | {complexity_metric.get('summary')}",
        ),
        gate_row(
            "ts_type_coverage",
            f">= {ts_min}",
            ts_metric.get("coverage") if ts_metric.get("coverage") is not None else "N/A",
            bool_or_true_if_none(ts_metric.get("coverage"), lambda x: x >= ts_min),
            f"{ts_metric.get('evidence')} | {ts_metric.get('summary')}",
        ),
        gate_row("lint_gate", "lint pass when script exists", tool_gate_flags["lint_gate"], tool_gate_flags["lint_gate"], "package.json scripts/tool_checks"),
        gate_row("typecheck_gate", "typecheck pass when script exists", tool_gate_flags["typecheck_gate"], tool_gate_flags["typecheck_gate"], "package.json scripts/tool_checks"),
        gate_row("test_gate", "test pass when script exists", tool_gate_flags["test_gate"], tool_gate_flags["test_gate"], "package.json scripts/tool_checks"),
        gate_row("a11y_gate", "a11y pass when script exists", tool_gate_flags["a11y_gate"], tool_gate_flags["a11y_gate"], "package.json scripts/tool_checks"),
        gate_row("performance_gate", "lighthouse pass when script exists", tool_gate_flags["performance_gate"], tool_gate_flags["performance_gate"], "package.json scripts/tool_checks"),
    ]

    if p5:
        p5_status = p5.get("status")
        details.append(gate_row("phase5_acceptance", "status in {completed}", p5_status, p5_status == "completed", "phase5.acceptance.report.json"))

    failed = [x for x in details if str(x.get("status", "")).startswith("❌")]
    result = {
        "validation_id": f"gate-val-{datetime.now(timezone.utc).strftime('%Y%m%d-%H%M%S')}",
        "timestamp": datetime.now(timezone.utc).isoformat(),
        "summary": {
            "total_gates": len(details),
            "passed": len(details) - len(failed),
            "failed": len(failed),
            "pass_rate": f"{((len(details)-len(failed))/len(details))*100:.1f}%",
            "overall_passed": len(failed) == 0,
        },
        "details": details,
        "tool_checks": tool_checks,
        "measured_metrics": {
            "component_reuse": reuse_metric,
            "cyclomatic_complexity": complexity_metric,
            "ts_coverage": ts_metric,
        },
        "recommendations": [f"修复 {x['gate']} 未通过项" for x in failed],
    }

    report.write_text(json.dumps(result, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(result, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
