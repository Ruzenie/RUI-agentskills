#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
from copy import deepcopy
from dataclasses import dataclass
from pathlib import Path
from typing import Any, Dict

DEFAULT_CONFIG: Dict[str, Any] = {
    "version": "1.0.0",
    "refactor_thresholds": {
        "file_lines": 200,
        "render_logic_lines": 30,
        "pattern_repeat": 3,
        "prop_drill_depth": 3,
        "jsx_nesting_depth": 5,
    },
    "quality_gates": {
        "requirement_completeness_min": 70,
        "design_score_min_5": 4.0,
        "component_reuse_rate_min": 40,
        "cyclomatic_complexity_max": 10,
        "ts_type_coverage_min": 90,
        "color_contrast_min": "4.5:1",
    },
    "design_tokens": {
        "default_direction": "Data Clarity",
        "default_density": "comfortable",
        "default_icon_style": "outline",
    },
    "pipeline": {
        "default_framework": "react",
        "default_project_type": "saas-modern",
        "auto_complete": False,
        "acceptance_level": "strict",
    },
    "artifacts": {
        "output_dir": "Ruiagents",
        "keep_history": True,
        "max_history_count": 10,
    },
    "logging": {
        "level": "info",
        "save_intermediate": True,
        "profiling": False,
    },
}


def _deep_merge(base: Dict[str, Any], override: Dict[str, Any]) -> Dict[str, Any]:
    out = deepcopy(base)
    for k, v in (override or {}).items():
        if isinstance(v, dict) and isinstance(out.get(k), dict):
            out[k] = _deep_merge(out[k], v)
        else:
            out[k] = v
    return out


def _load_json_compatible_yaml(path: Path) -> Dict[str, Any]:
    # JSON is YAML 1.2 subset. We keep config files JSON-compatible to avoid extra dependency.
    raw = path.read_text(encoding="utf-8").strip()
    if not raw:
        return {}
    try:
        data = json.loads(raw)
        if isinstance(data, dict):
            return data
    except Exception:
        pass
    return {}


@dataclass
class RuiConfig:
    data: Dict[str, Any]

    @classmethod
    def load(cls, repo_root: str, workspace_root: str | None = None) -> "RuiConfig":
        merged = deepcopy(DEFAULT_CONFIG)
        candidates = [
            Path(repo_root) / ".rui-config.yaml",
            Path(workspace_root) / ".rui-config.yaml" if workspace_root else None,
            Path.home() / ".rui-config.yaml",
        ]
        for candidate in candidates:
            if candidate and candidate.exists():
                merged = _deep_merge(merged, _load_json_compatible_yaml(candidate))
        return cls(merged)

    def to_env(self) -> str:
        cfg = self.data
        lines = []
        lines.append(f"RUI_CFG_REFACTOR_FILE_LINES={int(cfg['refactor_thresholds'].get('file_lines', 200))}")
        lines.append(f"RUI_CFG_REFACTOR_RENDER_LINES={int(cfg['refactor_thresholds'].get('render_logic_lines', 30))}")
        lines.append(f"RUI_CFG_REFACTOR_PATTERN_REPEAT={int(cfg['refactor_thresholds'].get('pattern_repeat', 3))}")
        lines.append(f"RUI_CFG_REFACTOR_PROP_DRILL={int(cfg['refactor_thresholds'].get('prop_drill_depth', 3))}")
        lines.append(f"RUI_CFG_ACCEPTANCE_LEVEL={cfg['pipeline'].get('acceptance_level', 'strict')}")
        lines.append(f"RUI_CFG_AUTO_COMPLETE={'1' if cfg['pipeline'].get('auto_complete') else '0'}")
        lines.append(f"RUI_CFG_DENSITY={cfg['design_tokens'].get('default_density', 'comfortable')}")
        lines.append(f"RUI_CFG_ICON_STYLE={cfg['design_tokens'].get('default_icon_style', 'outline')}")
        lines.append(f"RUI_CFG_GATE_REQUIREMENTS={int(cfg['quality_gates'].get('requirement_completeness_min', 70))}")
        lines.append(f"RUI_CFG_GATE_DESIGN={float(cfg['quality_gates'].get('design_score_min_5', 4.0))}")
        lines.append(f"RUI_CFG_GATE_REUSE={int(cfg['quality_gates'].get('component_reuse_rate_min', 40))}")
        lines.append(f"RUI_CFG_GATE_COMPLEXITY={int(cfg['quality_gates'].get('cyclomatic_complexity_max', 10))}")
        lines.append(f"RUI_CFG_GATE_TS={int(cfg['quality_gates'].get('ts_type_coverage_min', 90))}")
        return "\n".join(lines)


def main() -> None:
    parser = argparse.ArgumentParser(description="Load .rui-config.yaml (JSON-compatible YAML)")
    parser.add_argument("--repo-root", required=True)
    parser.add_argument("--workspace-root", default="")
    parser.add_argument("--print-json", action="store_true")
    parser.add_argument("--print-env", action="store_true")
    args = parser.parse_args()

    cfg = RuiConfig.load(args.repo_root, args.workspace_root or None)
    if args.print_env:
        print(cfg.to_env())
    else:
        print(json.dumps(cfg.data, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
