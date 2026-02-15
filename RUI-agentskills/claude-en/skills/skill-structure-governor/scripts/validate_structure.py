#!/usr/bin/env python3
"""Validate multilingual and multi-platform skill packaging structure."""

from __future__ import annotations

import re
import json
from pathlib import Path


def fail(msg: str) -> None:
    print(f"FAIL: {msg}")


def main() -> int:
    root = Path(__file__).resolve().parents[3]
    skills_dir = root / "skills"

    required_files = [
        skills_dir / "variants" / "CN" / "SKILLS.md",
        skills_dir / "variants" / "EN" / "SKILLS.md",
        skills_dir / "variants" / "manifest.json",
        skills_dir / "variants" / "skills.bilingual.json",
        skills_dir / "skill-structure-governor" / "scripts" / "export_skill_bundles.py",
        skills_dir / "platforms" / "codex" / "AGENTS.template.md",
        skills_dir / "platforms" / "codex" / "AGENTS.template.en.md",
        skills_dir / "platforms" / "claude" / "CLAUDE.template.md",
        skills_dir / "platforms" / "claude" / "CLAUDE.template.en.md",
        skills_dir / "structure" / "skills-structure-notes.md",
    ]

    missing = [p for p in required_files if not p.exists()]
    for p in missing:
        fail(f"missing required file: {p.relative_to(root)}")

    skill_dirs = []
    for child in skills_dir.iterdir():
        if not child.is_dir():
            continue
        if child.name in {"contracts", "variants", "platforms", "structure"}:
            continue
        if (child / "SKILL.md").exists():
            skill_dirs.append(child.name)

    readme_path = skills_dir / "README.md"
    if not readme_path.exists():
        fail("missing skills/README.md")
        print("SUMMARY: FAIL")
        return 1

    readme_text = readme_path.read_text(encoding="utf-8")
    numbers = [int(n) for n in re.findall(r"\b\d+\b", readme_text)]
    if not numbers:
        fail("cannot parse any numeric skill count hint from skills/README.md")
        print("SUMMARY: FAIL")
        return 1

    declared_count = numbers[0]
    actual_count = len(skill_dirs)
    if declared_count != actual_count:
        fail(
            f"skill count mismatch: declared={declared_count}, actual={actual_count}"
        )

    manifest_path = skills_dir / "variants" / "manifest.json"
    if manifest_path.exists():
        try:
            json.loads(manifest_path.read_text(encoding="utf-8"))
        except json.JSONDecodeError as exc:
            fail(f"invalid JSON in variants manifest: {exc}")

    bilingual_path = skills_dir / "variants" / "skills.bilingual.json"
    if bilingual_path.exists():
        try:
            data = json.loads(bilingual_path.read_text(encoding="utf-8"))
        except json.JSONDecodeError as exc:
            fail(f"invalid JSON in bilingual catalog: {exc}")
            print("SUMMARY: FAIL")
            return 1
        items = data.get("skills", [])
        bilingual_ids = {item.get("id") for item in items if item.get("id")}
        actual_ids = set(skill_dirs)
        missing_in_bilingual = sorted(actual_ids - bilingual_ids)
        extra_in_bilingual = sorted(bilingual_ids - actual_ids)
        if missing_in_bilingual:
            fail(f"bilingual catalog missing skills: {', '.join(missing_in_bilingual)}")
        if extra_in_bilingual:
            fail(f"bilingual catalog has unknown skills: {', '.join(extra_in_bilingual)}")
        if len(bilingual_ids) != actual_count:
            fail(
                f"bilingual skill count mismatch: bilingual={len(bilingual_ids)}, actual={actual_count}"
            )

    if missing or declared_count != actual_count:
        print("SUMMARY: FAIL")
        return 1

    if bilingual_path.exists():
        data = json.loads(bilingual_path.read_text(encoding="utf-8"))
        bilingual_ids = {item.get("id") for item in data.get("skills", []) if item.get("id")}
        actual_ids = set(skill_dirs)
        if bilingual_ids != actual_ids:
            print("SUMMARY: FAIL")
            return 1

    print("PASS: structure is complete")
    print(f"PASS: skills count = {actual_count}")
    print("SUMMARY: PASS")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
