# Skills Integration Map

**A production-oriented UI skill system that plugs directly into Codex / Claude.**

![Skills](https://img.shields.io/badge/skills-18-2563eb)
![Pipeline](https://img.shields.io/badge/fullflow-5_phase-16a34a)
![Focus](https://img.shields.io/badge/focus-implementation%20%26%20verification-f59e0b)

## Why This Skills Set

Many skill collections stop at recommendations and fail to close delivery.  
This set links requirement clarification, style scope control, implementation, acceptance, and self-review into one consistent workflow.

| Scenario | Typical issue | How this skills set handles it |
|---|---|---|
| Incomplete requirements | Early coding causes rework | Run `requirements-elicitation-engine` before implementation |
| Style-only changes | Accidental business-logic edits | Enforce `style-scope-guard` before coding |
| Multi-skill collaboration | Context breaks and artifact drift | Use `ui-fullflow-orchestrator` with unified handoff contracts |
| Quality closure | Inconsistent standards and weak replayability | Acceptance + self-review + quantitative scorecard loop |

## 30-Second Start

1. Run end-to-end: `ui-fullflow-orchestrator`
2. For style tasks, lock scope first: `style-scope-guard`
3. Converge final delivery: `ui-codegen-master`

---

## Skills Map

## Core Orchestration

1. `ui-codegen-master`
- End-to-end control across selection, style, generation, refactor, acceptance, and self-review.

2. `ui-fullflow-orchestrator`
- Full pipeline orchestration and artifact aggregation (with executable pipeline script).
- Entry script: `skills/ui-fullflow-orchestrator/scripts/run_fullflow_pipeline.sh`

3. `requirements-elicitation-engine`
- Requirement clarification, PRD draft generation, and style profile output.
- Script: `skills/requirements-elicitation-engine/scripts/generate_requirements_brief.py`

## Selection & Decision

4. `ui-selector-pro`
- Deterministic recommendation/evaluation/comparison engine.
- Script: `skills/ui-selector-pro/scripts/ui_library_engine.mjs`

5. `ui-selector-playbook`
- Review workflow, ADR templates, migration strategy, and POC guidance.

## Aesthetic Strategy

6. `ui-aesthetic-coach`
- Visual diagnosis and style direction guidance.
- Scripts: `score_ui_brief.py`, `generate_design_tokens.py`

7. `ui-aesthetic-generator`
- Generation-oriented aesthetic standards (tokens + component visual rules).

## Implementation

8. `ui-generation-workflow-runner`
- Executes the 4-step generation workflow.

9. `style-scope-guard`
- Locks style-edit boundaries and blocks execution until target scope is explicit.
- Script: `skills/style-scope-guard/scripts/build_style_scope_lock.py`

10. `svg-canvas-icon-engine`
- Builds SVG/Canvas icon system assets, including manifest/spec/sprite outputs.
- Script: `skills/svg-canvas-icon-engine/scripts/generate_icon_assets.py`

11. `ui-component-extractor`
- Applies component extraction and refactor rules.

12. `frontend-standards-enforcer`
- Enforces code standards and engineering constraints.

13. `ui-acceptance-auditor`
- Three-level acceptance scoring and release recommendation.

14. `ui-self-reviewer`
- Four-domain self-review: code, visual, interaction, and aesthetics.

## Architecture & Foundation

15. `project-scaffold-builder`
- Project scaffolding, toolchain setup, and quality gate bootstrap.

16. `component-library-architect`
- Component library architecture, token strategy, and release process.

17. `app-workspace-guide`
- Baseline detection for `app/` workspace environment and component assets.

## Structure Governance

18. `skill-structure-governor`
- Governance for bilingual entries and multi-platform packaging templates (structure-only, no business-feature migration).
- Script: `skills/skill-structure-governor/scripts/validate_structure.py`

## Suggested Collaboration Sequence

1. One-click orchestration: `ui-fullflow-orchestrator`
2. Requirement completion: `requirements-elicitation-engine`
3. Style scope lock: `style-scope-guard`
4. Selection: `ui-selector-pro` + `ui-selector-playbook`
5. Aesthetic strategy: `ui-aesthetic-coach` + `ui-aesthetic-generator`
6. Icon system (optional): `svg-canvas-icon-engine`
7. Workspace baseline: `app-workspace-guide`
8. Generation: `ui-generation-workflow-runner`
9. Refactor & standards: `ui-component-extractor` + `frontend-standards-enforcer`
10. Quality closure: `ui-acceptance-auditor` + `ui-self-reviewer`
11. Final convergence: `ui-codegen-master`

Run structure validation before release/distribution: `skill-structure-governor`

Export four bundles:

```bash
python3 skills/skill-structure-governor/scripts/export_skill_bundles.py
```

For new projects, run `project-scaffold-builder` as step 0.
For design-system scenarios, add `component-library-architect` in parallel.

## One-Click Fullflow Command

```bash
bash skills/ui-fullflow-orchestrator/scripts/run_fullflow_pipeline.sh \
  --brief "SaaS dashboard with readability and strong primary CTA" \
  --style-target "Dashboard header and core card area" \
  --scope-file "src/pages/dashboard.css" \
  --icon-mode auto \
  --icon-style outline \
  --framework react \
  --project-type saas-modern \
  --priority performance \
  --priority accessibility \
  --density comfortable
```

Default additional outputs:

- `stage.status.json` (5-stage status)
- `quality.gates.md` (quality gate checklist)
- `self-eval.scorecard.json` (quantitative scorecard)
- `optimization.plan.md` (priority optimization actions)
- `decision.trace.md` (user-visible decision summary)
- `style.scope.lock.json` (style scope lock)
- `icon.manifest.json` (icon asset list, on demand)

Note:
- `decision.trace.md` follows `skills/contracts/reasoning-visibility.md` and provides auditable summaries only (no private chain-of-thought).

## Bilingual & Platform Structure

- Bilingual entries:
  - `skills/variants/CN/SKILLS.md`
  - `skills/variants/EN/SKILLS.md`
- Field-aligned bilingual catalog:
  - `skills/variants/skills.bilingual.json`
  - Generation command: `python3 skills/skill-structure-governor/scripts/render_bilingual_index.py`
- Platform packaging templates:
  - `skills/platforms/codex/AGENTS.template.md`
  - `skills/platforms/codex/AGENTS.template.en.md`
  - `skills/platforms/claude/CLAUDE.template.md`
  - `skills/platforms/claude/CLAUDE.template.en.md`
- Structure diff reference:
  - `skills/structure/skills-structure-notes.md`
