#!/usr/bin/env python3
"""Export four distribution bundles: codex/claude x CN/EN."""

from __future__ import annotations

import argparse
import json
import re
import shutil
from datetime import datetime
from pathlib import Path

CJK_RE = re.compile(r"[\u4e00-\u9fff]")
FULLWIDTH_RE = re.compile(r"[\u3000-\u303f\uff00-\uffef]")
TEXT_SUFFIXES = {
    ".md",
    ".json",
    ".yaml",
    ".yml",
    ".py",
    ".js",
    ".mjs",
    ".ts",
    ".tsx",
    ".css",
    ".html",
    ".txt",
    ".sh",
    ".toml",
    ".ini",
    ".cfg",
}
CJK_EN_MAP = {
    "样式": "style",
    "风格": "style",
    "视觉": "visual",
    "外观": "appearance",
    "颜色": "color",
    "排版": "typography",
    "间距": "spacing",
    "圆角": "radius",
    "登录": "login",
    "侧边栏": "sidebar",
    "按钮": "button",
    "未锁定": "unlocked",
    "全局样式": "global style",
    "锁定": "locked",
    "确认": "confirm",
    "禁止": "forbidden",
    "目标": "target",
    "图标": "icon",
    "数据": "data",
    "管理": "admin",
    "看板": "dashboard",
    "审美": "aesthetic",
    "生成": "generate",
    "验收": "acceptance",
    "结构": "structure",
    "校验": "validate",
    "分发": "export",
    "执行": "execute",
}


def build_entry_text(template_text: str, platform: str, locale: str) -> str:
    is_cn = locale == "CN"
    index_path = "skills/variants/CN/SKILLS.md" if is_cn else "skills/variants/EN/SKILLS.md"
    language = "zh-CN" if is_cn else "en-US"
    title = "分发包入口" if is_cn else "Bundle Entry"
    lines = []
    lines.append(template_text.rstrip())
    lines.append("")
    lines.append(f"<!-- bundle_platform: {platform} -->")
    lines.append(f"<!-- bundle_locale: {locale} -->")
    lines.append(f"<!-- bundle_language: {language} -->")
    lines.append("")
    lines.append(f"## {title}")
    if is_cn:
        lines.append(f"- 技能索引: `{index_path}`")
        lines.append("- 结构校验: `python3 skills/skill-structure-governor/scripts/validate_structure.py`")
    else:
        lines.append(f"- Skills index: `{index_path}`")
        lines.append("- Validation: `python3 skills/skill-structure-governor/scripts/validate_structure.py`")
    lines.append("")
    return "\n".join(lines)


def contains_cjk(text: str) -> bool:
    return bool(CJK_RE.search(text))


def localize_cjk_text(text: str) -> str:
    localized = text
    for zh, en in sorted(CJK_EN_MAP.items(), key=lambda kv: len(kv[0]), reverse=True):
        localized = localized.replace(zh, en)
    localized = CJK_RE.sub("en", localized)
    localized = FULLWIDTH_RE.sub(" ", localized)
    return localized


def load_bilingual_catalog(skills_dir: Path) -> dict[str, dict[str, str]]:
    catalog_path = skills_dir / "variants" / "skills.bilingual.json"
    if not catalog_path.exists():
        return {}
    data = json.loads(catalog_path.read_text(encoding="utf-8"))
    result: dict[str, dict[str, str]] = {}
    for item in data.get("skills", []):
        skill_id = item.get("id")
        if not skill_id:
            continue
        result[skill_id] = item
    return result


def extract_ascii_refs(source_text: str) -> list[str]:
    refs = []
    seen = set()
    for match in re.findall(r"`([^`\n]+)`", source_text):
        if "/" not in match:
            continue
        if any(ord(ch) > 127 for ch in match):
            continue
        if match in seen:
            continue
        seen.add(match)
        refs.append(match)
    return refs[:12]


def extract_shell_examples(source_text: str) -> list[str]:
    commands = []
    seen = set()
    for line in source_text.splitlines():
        stripped = line.strip()
        if stripped.startswith(("python3 ", "bash ", "node ", "npm ", "pnpm ", "yarn ")):
            if any(ord(ch) > 127 for ch in stripped):
                continue
            if stripped in seen:
                continue
            seen.add(stripped)
            commands.append(stripped)
    return commands[:5]


def build_en_skill_doc(
    skill_id: str,
    title_en: str,
    desc_en: str,
    source_text: str,
) -> str:
    refs = extract_ascii_refs(source_text)
    commands = extract_shell_examples(source_text)
    lines = [
        "---",
        f"name: {skill_id}",
        f"description: {desc_en}",
        "---",
        "",
        f"# {title_en}",
        "",
        f"Purpose: {desc_en}",
        "",
        "## Source Of Truth",
        "- `skills/variants/EN/SKILLS.md`",
    ]
    if refs:
        lines.append("- Related references:")
        for ref in refs:
            lines.append(f"  - `{ref}`")
    lines.extend(
        [
            "",
            "## When To Use",
            f"- Use when tasks match `{skill_id}` responsibilities.",
            "- Run before implementation when this skill is an upstream dependency in the fullflow chain.",
            "",
            "## Inputs",
            "- user brief and target context",
            "- workspace constraints and existing code/assets",
            "- upstream artifacts from previous skills (if available)",
            "",
            "## Outputs",
            "- deterministic artifacts and status summary",
            "- handoff metadata for downstream skills",
        ]
    )
    if commands:
        lines.extend(
            [
                "",
                "## Command Examples",
                "```bash",
            ]
        )
        lines.extend(commands)
        lines.append("```")
    lines.extend(
        [
            "",
            "## Workflow",
            "1. Validate prerequisites and scope boundaries.",
            "2. Execute skill-specific rules and scripts.",
            "3. Produce artifacts with explicit status and evidence.",
            "4. Handoff to the next skill with actionable summary.",
            "",
        ]
    )
    return "\n".join(lines)


def apply_en_localization(bundle_skills_dir: Path, source_skills_dir: Path) -> None:
    catalog = load_bilingual_catalog(source_skills_dir)

    # Apply explicit *.en.* overrides first (e.g., .en.md / .en.json).
    for en_file in source_skills_dir.rglob("*"):
        if not en_file.is_file():
            continue
        if ".en." not in en_file.name:
            continue
        rel = en_file.relative_to(source_skills_dir)
        target_name = en_file.name.replace(".en.", ".")
        target = bundle_skills_dir / rel.parent / target_name
        if target.exists():
            target.write_text(en_file.read_text(encoding="utf-8"), encoding="utf-8")

    # Replace all skill docs with English versions.
    for skill_md in bundle_skills_dir.glob("*/SKILL.md"):
        skill_id = skill_md.parent.name
        source_skill_dir = source_skills_dir / skill_id
        source_skill_en = source_skill_dir / "SKILL.en.md"
        if source_skill_en.exists():
            skill_md.write_text(source_skill_en.read_text(encoding="utf-8"), encoding="utf-8")
            continue

        source_skill_md = source_skill_dir / "SKILL.md"
        source_text = source_skill_md.read_text(encoding="utf-8") if source_skill_md.exists() else ""
        item = catalog.get(skill_id, {})
        title_en = item.get("title_en") or skill_id
        desc_en = item.get("desc_en") or f"Execution guide for {skill_id}."
        skill_md.write_text(build_en_skill_doc(skill_id, title_en, desc_en, source_text), encoding="utf-8")

    # Remove Chinese-only entry directory in English bundles.
    cn_variants = bundle_skills_dir / "variants" / "CN"
    if cn_variants.exists():
        shutil.rmtree(cn_variants)

    # Clean *.en.* helper files from final bundle.
    for en_file in bundle_skills_dir.rglob("*.en.*"):
        en_file.unlink()

    # Normalize all text files to English-only characters in EN bundle.
    for file_path in bundle_skills_dir.rglob("*"):
        if not file_path.is_file():
            continue
        if file_path.suffix.lower() not in TEXT_SUFFIXES:
            continue
        try:
            text = file_path.read_text(encoding="utf-8")
        except UnicodeDecodeError:
            continue
        if contains_cjk(text) or FULLWIDTH_RE.search(text):
            text = localize_cjk_text(text)
            file_path.write_text(text, encoding="utf-8")


def cleanup_cn_bundle(bundle_skills_dir: Path) -> None:
    # Keep CN bundle focused on Chinese docs: remove explicit EN markdown docs/templates.
    en_variants = bundle_skills_dir / "variants" / "EN"
    if en_variants.exists():
        shutil.rmtree(en_variants)
    for path in bundle_skills_dir.rglob("*.en.md"):
        path.unlink()
    for path in [
        bundle_skills_dir / "platforms" / "codex" / "AGENTS.template.en.md",
        bundle_skills_dir / "platforms" / "claude" / "CLAUDE.template.en.md",
    ]:
        if path.exists():
            path.unlink()


def main() -> int:
    parser = argparse.ArgumentParser(description="Export codex/claude x CN/EN skill bundles")
    parser.add_argument("--out-dir", help="Output directory, default: dist/skill-bundles/<timestamp>")
    parser.add_argument("--clean", action="store_true", help="Remove output dir before export if exists")
    args = parser.parse_args()

    root = Path(__file__).resolve().parents[3]
    skills_dir = root / "skills"
    if not skills_dir.exists():
        raise SystemExit("skills directory not found")

    timestamp = datetime.now().strftime("%Y%m%d-%H%M%S")
    out_dir = Path(args.out_dir) if args.out_dir else root / "dist" / "skill-bundles" / timestamp
    if out_dir.exists() and args.clean:
        shutil.rmtree(out_dir)
    out_dir.mkdir(parents=True, exist_ok=True)

    codex_template_cn = (skills_dir / "platforms" / "codex" / "AGENTS.template.md").read_text(encoding="utf-8")
    codex_template_en = (skills_dir / "platforms" / "codex" / "AGENTS.template.en.md").read_text(encoding="utf-8")
    claude_template_cn = (skills_dir / "platforms" / "claude" / "CLAUDE.template.md").read_text(encoding="utf-8")
    claude_template_en = (skills_dir / "platforms" / "claude" / "CLAUDE.template.en.md").read_text(encoding="utf-8")

    bundles = [
        {"name": "RUI-codex-cn", "platform": "codex", "locale": "CN", "entry": "AGENTS.md", "template": codex_template_cn},
        {"name": "RUI-codex-en", "platform": "codex", "locale": "EN", "entry": "AGENTS.md", "template": codex_template_en},
        {"name": "RUI-claude-cn", "platform": "claude", "locale": "CN", "entry": "CLAUDE.md", "template": claude_template_cn},
        {"name": "RUI-claude-en", "platform": "claude", "locale": "EN", "entry": "CLAUDE.md", "template": claude_template_en},
    ]

    exported = []
    for bundle in bundles:
        bundle_dir = out_dir / bundle["name"]
        if bundle_dir.exists():
            shutil.rmtree(bundle_dir)
        bundle_dir.mkdir(parents=True, exist_ok=True)

        shutil.copytree(
            skills_dir,
            bundle_dir / "skills",
            dirs_exist_ok=True,
            ignore=shutil.ignore_patterns("__pycache__", "*.pyc"),
        )
        if bundle["locale"] == "EN":
            apply_en_localization(bundle_dir / "skills", skills_dir)
        else:
            cleanup_cn_bundle(bundle_dir / "skills")
        entry_text = build_entry_text(bundle["template"], bundle["platform"], bundle["locale"])
        (bundle_dir / bundle["entry"]).write_text(entry_text, encoding="utf-8")
        exported.append(
            {
                "name": bundle["name"],
                "path": str(bundle_dir),
                "platform": bundle["platform"],
                "locale": bundle["locale"],
                "entry": bundle["entry"],
            }
        )

    skill_count = len([p for p in skills_dir.iterdir() if p.is_dir() and (p / "SKILL.md").exists()])
    manifest = {
        "generated_at": datetime.now().isoformat(timespec="seconds"),
        "source_skills_dir": str(skills_dir),
        "skill_count": skill_count,
        "bundles": exported,
    }
    (out_dir / "bundle.manifest.json").write_text(
        json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
    )

    print(f"export complete: {out_dir}")
    for item in exported:
        print(f"- {item['name']}: {item['entry']}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
