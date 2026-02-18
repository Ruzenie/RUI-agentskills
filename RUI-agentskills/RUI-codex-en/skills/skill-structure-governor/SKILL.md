---
name: skill-structure-governor
description: Governs skills structure consistency and ensures bilingual entries and multi-platform packaging templates are complete.
---

# Skill Structure Governor

Goal: govern this repository's skill structure and keep bilingual entries plus multi-platform packaging consistent.

## SSOT

- `../structure/skills-structure-notes.md`
- `../variants/manifest.json`
- `../variants/skills.bilingual.json`

## When To Use

- Before releasing or synchronizing skill bundles.
- After adding new skills, to verify bilingual entries are updated.
- When validating Codex/Claude packaging templates.

## Executable Scripts

```bash
python3 skills/skill-structure-governor/scripts/render_bilingual_index.py
python3 skills/skill-structure-governor/scripts/validate_structure.py
python3 skills/skill-structure-governor/scripts/export_skill_bundles.py
```

## Check Items

1. Bilingual entry files
- `skills/variants/CN/SKILLS.md`
- `skills/variants/EN/SKILLS.md`

2. Platform packaging templates
- `skills/platforms/codex/AGENTS.template.md`
- `skills/platforms/claude/CLAUDE.template.md`

3. Skills overview consistency
- Verify the skill count in `skills/README.md` matches actual skill directories.

4. Bilingual catalog coverage consistency
- `skills/variants/skills.bilingual.json` must cover all skill directories.
- CN/EN index files must be generated from the bilingual catalog.

## Output Contract

1. `PASS`: structure is complete
2. `FAIL`: missing items and repair path
3. `EXPORT`: four distribution bundles (`RUI-codex-cn/RUI-codex-en/RUI-claude-cn/RUI-claude-en`)

## Rules

- Do not duplicate implementation logic into multilingual directories.
- Multilingual directories should contain entries and docs only; implementation stays single-source under `skills/<skill-name>/`.
