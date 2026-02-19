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

## Quick Invocation and Frontend Routing

- Alias mapping: `$ui` is equivalent to `$ui-fullflow-orchestrator`.
- Alias fallback resolution (mandatory): even if no `ui` entry appears in available skills, `$ui` must still be resolved to `$ui-fullflow-orchestrator`; do not respond with "no matching ui skill" and reroute.
- Explicit invocation first: if a user explicitly names any skill, follow it first.
- Fullflow lock (mandatory): if user explicitly inputs `$ui` or `$ui-fullflow-orchestrator`, the route must stay in fullflow orchestration and must not downgrade to single-skill execution such as `$ui-codegen-master`.
- Missing-parameter handling (mandatory): when required params are missing, only ask follow-up questions (`framework`, `project-type`) and do not bypass by downgrading.
- Must-pass chain (mandatory): `$ui` fullflow must cover `requirements-elicitation-engine`, `ui-codegen-master`, `ui-selector-playbook`, `ui-aesthetic-coach`, `ui-aesthetic-generator`, `ui-generation-workflow-runner`, `ui-acceptance-auditor`, `ui-self-reviewer`, and `ui-agent-workspace`.
- Default frontend routing: if no skill is explicitly named and the task is frontend/UI-related, route to `$ui` fullflow by default.
- Parameter completion: when user only inputs `$ui "<brief>"`, ask for `target frontend framework` and `project-type label` before running fullflow.
- Frontend task scope (examples): page implementation, component implementation, style/visual polish, interaction refactor, frontend refactor, accessibility and performance optimization.
- Non-frontend tasks: follow normal skill matching, do not force `$ui`.

Recommended invocation examples:
- `Use $ui to build an e-commerce analytics dashboard`
- `Polish this React page UI` (defaults to `$ui` when no explicit skill is named)

<!-- bundle_platform: claude -->
<!-- bundle_locale: EN -->
<!-- bundle_language: en-US -->

## Bundle Entry
- Skills index: `skills/variants/EN/SKILLS.md`
- Validation: `python3 skills/skill-structure-governor/scripts/validate_structure.py`
