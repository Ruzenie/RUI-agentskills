<!-- bootstrap: lang=en-US; encoding=UTF-8 -->
<!-- STRUCTURE_TEMPLATE: claude -->

# Skills Bootstrap (Claude)

Template entry for Claude packaging with a shared implementation and bilingual documentation indices.

## Usage

1. Merge this template into project-level `CLAUDE.md`.
2. Keep implementation as single source: `skills/<skill-name>/`.
3. Switch documentation language via:
   - Chinese: `skills/variants/CN/SKILLS.md`
   - English: `skills/variants/EN/SKILLS.md`

## Constraints

- Do not duplicate skill implementations across locales.
- Keep platform differences in bootstrap templates only.
- Validate before release:

```bash
python3 skills/skill-structure-governor/scripts/validate_structure.py
```

<!-- bundle_platform: claude -->
<!-- bundle_locale: EN -->
<!-- bundle_language: en-US -->

## Bundle Entry
- Skills index: `skills/variants/EN/SKILLS.md`
- Validation: `python3 skills/skill-structure-governor/scripts/validate_structure.py`
