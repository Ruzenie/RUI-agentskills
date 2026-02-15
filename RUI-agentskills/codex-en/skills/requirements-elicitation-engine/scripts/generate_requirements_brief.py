#!/usr/bin/env python3
"""Generate requirement artifacts: PRD draft, follow-up questions, and style profile."""

from __future__ import annotations

import argparse
import json
import re
from dataclasses import dataclass
from pathlib import Path
from typing import Dict, List, Tuple


@dataclass(frozen=True)
class Dimension:
    key: str
    label: str
    keywords: Tuple[str, ...]
    questions: Tuple[str, ...]


DIMENSIONS: Tuple[Dimension, ...] = (
    Dimension(
        key="basic_info",
        label="enenenenenen",
        keywords=("enen", "enen", "enen", "enen", "dashboard", "landing", "admin", "enen", "dashboard", "enenen", "saas", "enen"),
        questions=(
            "enenenentargetenenen  enenenen/enenenen/adminenen/dataenen ",
            "targetenenenen  Ben/Cen/enenenen ",
            "enenenenenenen enen3-5enenenenen ",
        ),
    ),
    Dimension(
        key="tech_stack",
        label="enenen",
        keywords=("react", "vue", "angular", "svelte", "tailwind", "typescript", "vite"),
        questions=(
            "enenenenenenenenen  React/Vue/Angular/Svelte/Vanilla ",
            "styleenenenenenenen  Tailwind/CSS Modules/SCSS ",
            "enenenen TypeScript enenenen ",
        ),
    ),
    Dimension(
        key="design",
        label="enenstyle",
        keywords=("enen", "enen", "enen", "enen", "dark", "light", "brand", "style", "enenen", "enenenen"),
        questions=(
            "enenvisualstyleenenen  enen/enen/enen/enenenen ",
            "enenenenenenen enenenenenenenenen ",
            "enenenenenenenenenenenenen ",
        ),
    ),
    Dimension(
        key="functionality",
        label="enenenen",
        keywords=("login", "enen", "enen", "enen", "enen", "enen", "enen", "enen", "icon", "enen", "enen"),
        questions=(
            "enenenenenenenenenenenen  enenenenenen ",
            "enenenenenen enen enenenenvalidateenenen ",
            "enenenendataenenenen enenenenenenen ",
        ),
    ),
    Dimension(
        key="quality",
        label="enenenenen",
        keywords=("enen", "seo", "wcag", "enenen", "enen", "enenen", "deadline", "enen", "enen", "enenen"),
        questions=(
            "enentargetenenen  enen/enenenen ",
            "enenenenenenenen  Chrome/Firefox/Safari/Edge ",
            "enenenenenenenenenenenen ",
        ),
    ),
    Dimension(
        key="responsive_adaptation",
        label="enenenenenen",
        keywords=("enenen", "enenen", "enen", "enen", "enen", "h5", "enenen", "enen", "pc"),
        questions=(
            "enenenenenenenenenenenen  enen/enen/enen ",
            "enenenenenenenenen  en 768/1024/1280 ",
            "enenenenenenenenenenenenenenenenenen ",
        ),
    ),
    Dimension(
        key="content_management",
        label="enenadmin",
        keywords=("cms", "enen", "enenen", "enen", "enen", "enen", "enen", "enenen"),
        questions=(
            "enenenenenenenenen  enenenen/CMS/API ",
            "enenenenenenenenenenenenen ",
            "enenenenenenenenenenenenenenen ",
        ),
    ),
    Dimension(
        key="integration_deployment",
        label="enenenenen",
        keywords=("enen", "vercel", "netlify", "docker", "ci", "cd", "enenen", "enen", "enen", "enen", "enen", "enen", "api", "sdk"),
        questions=(
            "enenenenenenenenenenen  enen/enen/enen/IM ",
            "enenenenenenen  Vercel/Netlify/enenenenen/enen ",
            "enenenen CI/CD enenenenen ",
        ),
    ),
)


def normalize_text(text: str) -> str:
    return re.sub(r"\s+", " ", text).strip().lower()


def extract_project_name(text: str) -> str:
    zh_match = re.search(r"([\u4e00-\u9fffA-Za-z0-9_-]{2,20})(?:enen|enen|enen|enen|dashboard|enen)", text)
    if zh_match:
        return zh_match.group(1)
    return "ui-project"


def detect_framework(text: str) -> str:
    if "react" in text:
        return "react"
    if "vue" in text:
        return "vue"
    if "angular" in text:
        return "angular"
    if "svelte" in text:
        return "svelte"
    return "react"


def detect_style(text: str) -> str:
    if "enen" in text or "glass" in text:
        return "glassmorphism"
    if "enen" in text or "minimal" in text:
        return "minimal"
    if "enen" in text:
        return "corporate"
    if "enen" in text:
        return "tech"
    return "modern"


def dimension_hits(text: str) -> Dict[str, int]:
    hits: Dict[str, int] = {}
    for dim in DIMENSIONS:
        hits[dim.key] = sum(1 for kw in dim.keywords if kw in text)
    return hits


def build_followup_questions(hits: Dict[str, int], max_questions: int) -> List[str]:
    questions: List[str] = []
    for dim in DIMENSIONS:
        if hits[dim.key] == 0:
            questions.extend(dim.questions)
    if not questions:
        # Still keep a small clarification set for robustness.
        questions = [
            "enconfirmenenenenenenenen P0/P1/P2  ",
            "enconfirmenenenenenenenenenen ",
            "enconfirmenenenen enen enen enenen  ",
        ]
    return questions[:max_questions]


def summarize_coverage(hits: Dict[str, int]) -> Dict[str, object]:
    covered = [dim.label for dim in DIMENSIONS if hits.get(dim.key, 0) > 0]
    missing = [dim.label for dim in DIMENSIONS if hits.get(dim.key, 0) == 0]
    ratio = len(covered) / len(DIMENSIONS) if DIMENSIONS else 0.0
    # en Kimi enenenenenen 70 enenen“enenenenenenen”enenenen
    score = int(round(ratio * 100))
    return {
        "dimension_total": len(DIMENSIONS),
        "dimension_covered": len(covered),
        "covered_dimensions": covered,
        "missing_dimensions": missing,
        "completeness_score": score,
    }


def build_prd_markdown(project_name: str, brief: str, framework: str, style: str, questions: List[str]) -> str:
    q_md = "\n".join(f"- [ ] {q}" for q in questions)
    return f"""# enenenenenenenenen PRD \n\n## enenenen\n- enenenen: {project_name}\n- enenenenen: {framework}\n- visualstyleenen: {style}\n\n## 1. enenenen\n{brief}\n\n## 2. enenenenenen\n- enenenenenenenenen enenenenenenenen \n- enenenenenen enenenenconfirmenenenenexecuteen \n\n## 3. enconfirmenen enenen \n{q_md}\n\n## 4. enenenacceptanceenen\n- enenenenenenenenenenenenen \n- enenexecuteenenenen enen/visual/enen/enen/enenenen  \n- enenenenacceptanceenenenenenenenenen \n"""


def build_style_profile_yaml(project_name: str, framework: str, style: str) -> str:
    return f"""project: {project_name}\nframework: {framework}\nstyle:\n  preferred: {style}\n  density: comfortable\ncode:\n  typescript_strict: true\n  no_any: true\n  component_split_threshold: 200\n  render_logic_threshold: 30\nquality:\n  accessibility: wcag-aa\n  browser_support:\n    - chrome\n    - firefox\n    - safari\n    - edge\n"""


def main() -> None:
    parser = argparse.ArgumentParser(description="Generate requirement elicitation artifacts")
    parser.add_argument("--brief", help="Requirement brief text")
    parser.add_argument("--brief-file", help="Path to brief text file")
    parser.add_argument("--out-dir", required=True, help="Output directory")
    parser.add_argument("--project-name", help="Optional project name override")
    parser.add_argument("--max-questions", type=int, default=5, help="Max follow-up questions")
    parser.add_argument("--json", action="store_true", help="Print result as JSON")
    args = parser.parse_args()

    brief = ""
    if args.brief_file:
        brief = Path(args.brief_file).read_text(encoding="utf-8").strip()
    elif args.brief:
        brief = args.brief.strip()

    if not brief:
        raise SystemExit("brief is required: use --brief or --brief-file")

    norm = normalize_text(brief)
    project_name = args.project_name or extract_project_name(brief)
    framework = detect_framework(norm)
    style = detect_style(norm)

    hits = dimension_hits(norm)
    questions = build_followup_questions(hits, args.max_questions)
    coverage = summarize_coverage(hits)

    out_dir = Path(args.out_dir)
    out_dir.mkdir(parents=True, exist_ok=True)

    prd_path = out_dir / "requirements.prd.md"
    questions_path = out_dir / "requirements.questions.md"
    profile_path = out_dir / "style-profile.yaml"

    prd_path.write_text(build_prd_markdown(project_name, brief, framework, style, questions), encoding="utf-8")
    questions_path.write_text("\n".join(f"- {q}" for q in questions) + "\n", encoding="utf-8")
    profile_path.write_text(build_style_profile_yaml(project_name, framework, style), encoding="utf-8")

    result = {
        "project_name": project_name,
        "framework": framework,
        "style": style,
        "dimension_hits": hits,
        "dimension_total": coverage["dimension_total"],
        "dimension_covered": coverage["dimension_covered"],
        "covered_dimensions": coverage["covered_dimensions"],
        "missing_dimensions": coverage["missing_dimensions"],
        "completeness_score": coverage["completeness_score"],
        "question_count": len(questions),
        "artifacts": {
            "requirements_prd": str(prd_path),
            "requirements_questions": str(questions_path),
            "style_profile": str(profile_path),
        },
    }

    if args.json:
        print(json.dumps(result, ensure_ascii=False, indent=2))
    else:
        print(f"project: {project_name}")
        print(f"framework: {framework}")
        print(f"style: {style}")
        print(f"questions: {len(questions)}")
        print(f"out: {out_dir}")


if __name__ == "__main__":
    main()
