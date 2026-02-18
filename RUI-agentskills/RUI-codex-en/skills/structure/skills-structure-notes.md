# Skills Structure Notes

This document defines structural constraints and maintenance rules for the skill system in this repository.

## Goals

1. Single implementation source
- Skill implementations are maintained only under `skills/<skill-name>/`.

2. Consistent bilingual entries
- Chinese entry: `skills/variants/CN/SKILLS.md`
- English entry: `skills/variants/EN/SKILLS.md`

3. Consistent multi-platform packaging
- Codex bootstrap template: `skills/platforms/codex/AGENTS.template.md`
- Claude bootstrap template: `skills/platforms/claude/CLAUDE.template.md`

## Non-Goals

- Do not duplicate implementation logic into multilingual directories.
- Do not introduce business-specific rules into platform bootstrap templates.

## Validation and Export

```bash
python3 skills/skill-structure-governor/scripts/render_bilingual_index.py
python3 skills/skill-structure-governor/scripts/validate_structure.py
python3 skills/skill-structure-governor/scripts/export_skill_bundles.py --out-dir dist/skills-bundle-test --clean
```
