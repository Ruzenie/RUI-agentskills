<!-- bootstrap: lang=en-US; encoding=UTF-8 -->
<!-- STRUCTURE_TEMPLATE: codex -->

# Skills Bootstrap (Codex)

Template entry for Codex packaging with a shared implementation and bilingual documentation indices.

## Usage

1. Merge this template into project-level `AGENTS.md`.
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

## Quick Invocation and Frontend Routing

- Alias mapping: `$ui` is equivalent to `$ui-fullflow-orchestrator`.
- Explicit invocation first: if a user explicitly names any skill, follow it first.
- Default frontend routing: if no skill is explicitly named and the task is frontend/UI-related, route to `$ui` fullflow by default.
- Parameter completion: when user only inputs `$ui "<brief>"`, ask for `target frontend framework` and `project-type label` before running fullflow.
- Frontend task scope (examples): page implementation, component implementation, style/visual polish, interaction refactor, frontend refactor, accessibility and performance optimization.
- Non-frontend tasks: follow normal skill matching, do not force `$ui`.

Recommended invocation examples:
- `Use $ui to build an e-commerce analytics dashboard`
- `Polish this React page UI` (defaults to `$ui` when no explicit skill is named)
