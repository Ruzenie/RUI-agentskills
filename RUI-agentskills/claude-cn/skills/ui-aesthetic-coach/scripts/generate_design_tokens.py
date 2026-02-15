#!/usr/bin/env python3
"""Generate deterministic design tokens (JSON/CSS) for UI themes."""

from __future__ import annotations

import argparse
import json
import re
from copy import deepcopy
from pathlib import Path
from typing import Any, Dict, List, Tuple

TokenMap = Dict[str, Dict[str, str]]

DIRECTION_PRESETS: Dict[str, TokenMap] = {
    "Editorial Minimal": {
        "color": {
            "bg": "#f8f7f4",
            "surface": "#ffffff",
            "surface_alt": "#f2f1ed",
            "text": "#161616",
            "text_muted": "#5f5a55",
            "border": "#ddd8d2",
            "primary": "#242424",
            "primary_hover": "#0f0f0f",
            "primary_text": "#ffffff",
            "focus": "#5a5a5a",
            "success": "#1f7a4d",
            "warning": "#a4640e",
            "error": "#b63e2e",
        },
        "typography": {
            "font_sans": '"IBM Plex Sans", "Segoe UI", sans-serif',
            "font_display": '"Fraunces", "Times New Roman", serif',
            "size_xs": "12px",
            "size_sm": "14px",
            "size_md": "16px",
            "size_lg": "20px",
            "size_xl": "28px",
            "size_2xl": "36px",
            "line_height_body": "1.6",
            "line_height_title": "1.2",
            "weight_regular": "400",
            "weight_medium": "500",
            "weight_bold": "700",
        },
        "spacing": {},
        "radius": {"sm": "6px", "md": "10px", "lg": "14px", "pill": "999px"},
        "shadow": {
            "sm": "0 1px 2px rgba(0,0,0,0.06)",
            "md": "0 8px 20px rgba(0,0,0,0.10)",
            "lg": "0 16px 40px rgba(0,0,0,0.14)",
        },
        "component": {
            "control_height_sm": "32px",
            "control_height_md": "40px",
            "control_height_lg": "48px",
            "border_width": "1px",
        },
    },
    "Data Clarity": {
        "color": {
            "bg": "#f4f7fb",
            "surface": "#ffffff",
            "surface_alt": "#edf2f8",
            "text": "#0f172a",
            "text_muted": "#475569",
            "border": "#d3dce8",
            "primary": "#2563eb",
            "primary_hover": "#1d4ed8",
            "primary_text": "#ffffff",
            "focus": "#3b82f6",
            "success": "#0f9f6e",
            "warning": "#d97706",
            "error": "#dc2626",
        },
        "typography": {
            "font_sans": '"IBM Plex Sans", "Segoe UI", sans-serif',
            "font_display": '"IBM Plex Sans", "Segoe UI", sans-serif',
            "size_xs": "12px",
            "size_sm": "14px",
            "size_md": "16px",
            "size_lg": "20px",
            "size_xl": "24px",
            "size_2xl": "30px",
            "line_height_body": "1.55",
            "line_height_title": "1.25",
            "weight_regular": "400",
            "weight_medium": "500",
            "weight_bold": "700",
        },
        "spacing": {},
        "radius": {"sm": "8px", "md": "12px", "lg": "16px", "pill": "999px"},
        "shadow": {
            "sm": "0 1px 3px rgba(15,23,42,0.08)",
            "md": "0 10px 24px rgba(15,23,42,0.12)",
            "lg": "0 20px 48px rgba(15,23,42,0.16)",
        },
        "component": {
            "control_height_sm": "32px",
            "control_height_md": "40px",
            "control_height_lg": "48px",
            "border_width": "1px",
        },
    },
    "Friendly Utility": {
        "color": {
            "bg": "#f8faf8",
            "surface": "#ffffff",
            "surface_alt": "#eef4ee",
            "text": "#1f2937",
            "text_muted": "#5b6573",
            "border": "#d9e1dc",
            "primary": "#0f766e",
            "primary_hover": "#0b5f59",
            "primary_text": "#ffffff",
            "focus": "#14b8a6",
            "success": "#15803d",
            "warning": "#b45309",
            "error": "#b91c1c",
        },
        "typography": {
            "font_sans": '"Manrope", "Segoe UI", sans-serif',
            "font_display": '"Manrope", "Segoe UI", sans-serif',
            "size_xs": "12px",
            "size_sm": "14px",
            "size_md": "16px",
            "size_lg": "20px",
            "size_xl": "26px",
            "size_2xl": "34px",
            "line_height_body": "1.6",
            "line_height_title": "1.25",
            "weight_regular": "400",
            "weight_medium": "600",
            "weight_bold": "700",
        },
        "spacing": {},
        "radius": {"sm": "10px", "md": "14px", "lg": "18px", "pill": "999px"},
        "shadow": {
            "sm": "0 1px 3px rgba(2,6,23,0.07)",
            "md": "0 12px 28px rgba(2,6,23,0.11)",
            "lg": "0 24px 56px rgba(2,6,23,0.14)",
        },
        "component": {
            "control_height_sm": "34px",
            "control_height_md": "42px",
            "control_height_lg": "50px",
            "border_width": "1px",
        },
    },
    "Bold Productive": {
        "color": {
            "bg": "#f6f7fb",
            "surface": "#ffffff",
            "surface_alt": "#e9edf8",
            "text": "#111827",
            "text_muted": "#4b5563",
            "border": "#d8deef",
            "primary": "#ea580c",
            "primary_hover": "#c2410c",
            "primary_text": "#ffffff",
            "focus": "#fb923c",
            "success": "#16a34a",
            "warning": "#ca8a04",
            "error": "#dc2626",
        },
        "typography": {
            "font_sans": '"Sora", "Segoe UI", sans-serif',
            "font_display": '"Sora", "Segoe UI", sans-serif',
            "size_xs": "12px",
            "size_sm": "14px",
            "size_md": "16px",
            "size_lg": "21px",
            "size_xl": "30px",
            "size_2xl": "40px",
            "line_height_body": "1.55",
            "line_height_title": "1.15",
            "weight_regular": "400",
            "weight_medium": "600",
            "weight_bold": "700",
        },
        "spacing": {},
        "radius": {"sm": "8px", "md": "12px", "lg": "16px", "pill": "999px"},
        "shadow": {
            "sm": "0 2px 4px rgba(17,24,39,0.10)",
            "md": "0 12px 30px rgba(17,24,39,0.14)",
            "lg": "0 24px 60px rgba(17,24,39,0.18)",
        },
        "component": {
            "control_height_sm": "32px",
            "control_height_md": "40px",
            "control_height_lg": "48px",
            "border_width": "1px",
        },
    },
    "Neo Brutal Light": {
        "color": {
            "bg": "#fffdf8",
            "surface": "#ffffff",
            "surface_alt": "#fff4cc",
            "text": "#111111",
            "text_muted": "#3f3f46",
            "border": "#111111",
            "primary": "#ff3b30",
            "primary_hover": "#d82b21",
            "primary_text": "#ffffff",
            "focus": "#111111",
            "success": "#0e9f6e",
            "warning": "#d97706",
            "error": "#dc2626",
        },
        "typography": {
            "font_sans": '"Archivo", "Segoe UI", sans-serif',
            "font_display": '"Archivo", "Segoe UI", sans-serif',
            "size_xs": "12px",
            "size_sm": "14px",
            "size_md": "16px",
            "size_lg": "22px",
            "size_xl": "32px",
            "size_2xl": "44px",
            "line_height_body": "1.5",
            "line_height_title": "1.1",
            "weight_regular": "500",
            "weight_medium": "700",
            "weight_bold": "800",
        },
        "spacing": {},
        "radius": {"sm": "0px", "md": "2px", "lg": "4px", "pill": "999px"},
        "shadow": {
            "sm": "4px 4px 0 rgba(17,17,17,1)",
            "md": "8px 8px 0 rgba(17,17,17,1)",
            "lg": "12px 12px 0 rgba(17,17,17,1)",
        },
        "component": {
            "control_height_sm": "34px",
            "control_height_md": "42px",
            "control_height_lg": "50px",
            "border_width": "2px",
        },
    },
    "Calm Glass": {
        "color": {
            "bg": "#eef3ff",
            "surface": "#ffffffcc",
            "surface_alt": "#f6f8ff99",
            "text": "#152238",
            "text_muted": "#46556f",
            "border": "#c7d2e5",
            "primary": "#6366f1",
            "primary_hover": "#4f46e5",
            "primary_text": "#ffffff",
            "focus": "#818cf8",
            "success": "#16a34a",
            "warning": "#ca8a04",
            "error": "#dc2626",
        },
        "typography": {
            "font_sans": '"Plus Jakarta Sans", "Segoe UI", sans-serif',
            "font_display": '"Plus Jakarta Sans", "Segoe UI", sans-serif',
            "size_xs": "12px",
            "size_sm": "14px",
            "size_md": "16px",
            "size_lg": "20px",
            "size_xl": "28px",
            "size_2xl": "36px",
            "line_height_body": "1.6",
            "line_height_title": "1.2",
            "weight_regular": "400",
            "weight_medium": "500",
            "weight_bold": "700",
        },
        "spacing": {},
        "radius": {"sm": "12px", "md": "16px", "lg": "22px", "pill": "999px"},
        "shadow": {
            "sm": "0 2px 8px rgba(35,46,73,0.10)",
            "md": "0 16px 38px rgba(35,46,73,0.15)",
            "lg": "0 28px 68px rgba(35,46,73,0.18)",
        },
        "component": {
            "control_height_sm": "34px",
            "control_height_md": "42px",
            "control_height_lg": "50px",
            "border_width": "1px",
        },
    },
}

DENSITY_PRESETS: Dict[str, Dict[str, Any]] = {
    "compact": {
        "space": [4, 6, 8, 12, 16, 24, 32, 40],
        "control": {"sm": "30px", "md": "36px", "lg": "44px"},
    },
    "comfortable": {
        "space": [4, 8, 12, 16, 24, 32, 48, 64],
        "control": {"sm": "32px", "md": "40px", "lg": "48px"},
    },
    "spacious": {
        "space": [4, 10, 14, 20, 28, 40, 56, 72],
        "control": {"sm": "34px", "md": "44px", "lg": "54px"},
    },
}


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Generate design tokens from direction or scoring result.")
    parser.add_argument(
        "--direction",
        choices=sorted(DIRECTION_PRESETS.keys()),
        help="Visual direction preset",
    )
    parser.add_argument(
        "--density",
        choices=sorted(DENSITY_PRESETS.keys()),
        default="comfortable",
        help="Component density preset",
    )
    parser.add_argument("--brand-color", help="Primary brand color in #RRGGBB")
    parser.add_argument("--from-score-json", help="Path to score_ui_brief JSON output")
    parser.add_argument(
        "--format",
        choices=["json", "css", "both"],
        default="both",
        help="Output format",
    )
    parser.add_argument("--json-out", help="Write JSON output to file")
    parser.add_argument("--css-out", help="Write CSS output to file")
    return parser.parse_args()


def normalize_hex(color: str) -> str:
    if not color:
        return color
    color = color.strip().lower()
    if re.fullmatch(r"#[0-9a-f]{6}", color):
        return color
    raise ValueError("--brand-color must be in #RRGGBB format")


def hex_to_rgb(color: str) -> Tuple[int, int, int]:
    value = color.lstrip("#")
    return int(value[0:2], 16), int(value[2:4], 16), int(value[4:6], 16)


def rgb_to_hex(rgb: Tuple[int, int, int]) -> str:
    r, g, b = rgb
    return f"#{r:02x}{g:02x}{b:02x}"


def shift_color(color: str, amount: float) -> str:
    r, g, b = hex_to_rgb(color)
    if amount >= 0:
        r = int(r + (255 - r) * amount)
        g = int(g + (255 - g) * amount)
        b = int(b + (255 - b) * amount)
    else:
        amt = abs(amount)
        r = int(r * (1 - amt))
        g = int(g * (1 - amt))
        b = int(b * (1 - amt))
    return rgb_to_hex((max(0, min(255, r)), max(0, min(255, g)), max(0, min(255, b))))


def choose_direction(args: argparse.Namespace, score_data: Dict[str, Any] | None) -> str:
    if args.direction:
        return args.direction
    if score_data:
        name = score_data.get("recommended_direction", {}).get("name")
        if isinstance(name, str) and name in DIRECTION_PRESETS:
            return name
    return "Data Clarity"


def load_score(path: str | None) -> Dict[str, Any] | None:
    if not path:
        return None
    data = json.loads(Path(path).read_text(encoding="utf-8"))
    if not isinstance(data, dict):
        raise ValueError("score json must be an object")
    return data


def apply_density(tokens: TokenMap, density: str) -> None:
    preset = DENSITY_PRESETS[density]
    spaces = preset["space"]
    tokens["spacing"] = {
        "1": f"{spaces[0]}px",
        "2": f"{spaces[1]}px",
        "3": f"{spaces[2]}px",
        "4": f"{spaces[3]}px",
        "5": f"{spaces[4]}px",
        "6": f"{spaces[5]}px",
        "7": f"{spaces[6]}px",
        "8": f"{spaces[7]}px",
    }
    tokens["component"]["control_height_sm"] = preset["control"]["sm"]
    tokens["component"]["control_height_md"] = preset["control"]["md"]
    tokens["component"]["control_height_lg"] = preset["control"]["lg"]


def apply_brand_color(tokens: TokenMap, brand_color: str | None) -> None:
    if not brand_color:
        return
    color = normalize_hex(brand_color)
    tokens["color"]["primary"] = color
    tokens["color"]["primary_hover"] = shift_color(color, -0.12)
    tokens["color"]["focus"] = shift_color(color, 0.20)


def apply_issue_tuning(tokens: TokenMap, score_data: Dict[str, Any] | None) -> List[str]:
    notes: List[str] = []
    if not score_data:
        return notes

    issue_keys = {
        item.get("key")
        for item in score_data.get("top_issues", [])
        if isinstance(item, dict) and isinstance(item.get("key"), str)
    }

    if "typography" in issue_keys:
        tokens["typography"]["line_height_body"] = "1.65"
        tokens["typography"]["size_md"] = "16px"
        notes.append("Applied readability-biased typography tuning.")

    if "color" in issue_keys:
        tokens["color"]["text"] = "#0f172a"
        tokens["color"]["text_muted"] = "#475569"
        notes.append("Applied stronger neutral contrast for text clarity.")

    if "spacing" in issue_keys:
        tokens["spacing"]["4"] = "18px"
        tokens["spacing"]["6"] = "36px"
        notes.append("Applied wider mid-scale spacing to improve rhythm.")

    if "components" in issue_keys:
        tokens["component"]["border_width"] = "1.5px"
        notes.append("Applied stricter component border definition.")

    return notes


def build_token_payload(args: argparse.Namespace) -> Dict[str, Any]:
    score_data = load_score(args.from_score_json)
    direction = choose_direction(args, score_data)

    tokens = deepcopy(DIRECTION_PRESETS[direction])
    apply_density(tokens, args.density)
    apply_brand_color(tokens, args.brand_color)
    tuning_notes = apply_issue_tuning(tokens, score_data)

    meta = {
        "direction": direction,
        "density": args.density,
        "source": "score-json" if score_data else "preset",
    }
    if args.brand_color:
        meta["brand_color"] = normalize_hex(args.brand_color)

    return {
        "meta": meta,
        "tokens": tokens,
        "notes": tuning_notes,
    }


def flatten_tokens(prefix: str, values: Dict[str, str]) -> List[str]:
    lines = []
    for key, value in values.items():
        name = key.replace("_", "-")
        lines.append(f"  --{prefix}-{name}: {value};")
    return lines


def render_css(payload: Dict[str, Any]) -> str:
    tokens: TokenMap = payload["tokens"]
    lines = [":root {"]
    lines.extend(flatten_tokens("color", tokens["color"]))
    lines.extend(flatten_tokens("font", tokens["typography"]))
    lines.extend(flatten_tokens("space", tokens["spacing"]))
    lines.extend(flatten_tokens("radius", tokens["radius"]))
    lines.extend(flatten_tokens("shadow", tokens["shadow"]))
    lines.extend(flatten_tokens("component", tokens["component"]))
    lines.append("}")
    return "\n".join(lines)


def write_if_path(path: str | None, content: str) -> None:
    if not path:
        return
    Path(path).write_text(content + "\n", encoding="utf-8")


def main() -> int:
    args = parse_args()
    payload = build_token_payload(args)

    json_text = json.dumps(payload, ensure_ascii=False, indent=2)
    css_text = render_css(payload)

    write_if_path(args.json_out, json_text)
    write_if_path(args.css_out, css_text)

    if args.format == "json":
        print(json_text)
    elif args.format == "css":
        print(css_text)
    else:
        print("# JSON")
        print(json_text)
        print("\n# CSS")
        print(css_text)

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
