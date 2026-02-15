---
name: ui-codegen-master
description: Master skill for end-to-end UI generation and code optimization. Integrates aesthetics, code standards, component extraction, acceptance, self-review, and stack recommendation into production-ready frontend delivery.
---

# UI Codegen Master

Goal: merge the repository's distributed UI standards and real implementation experience from `app/` into one executable workflow.

## When To Use

- Generate pages/modules from scratch (Landing/Dashboard/Form, etc.).
- Optimize existing frontend code (structure, performance, maintainability, type safety).
- Perform component extraction, directory refactor, and design-token unification.
- Build a closed loop of generation + acceptance + self-review + iteration.

## Dependent Capabilities

1. Selection: `$ui-selector-pro` + `$ui-selector-playbook`
2. Aesthetics: `$ui-aesthetic-coach` + `$ui-aesthetic-generator`
3. Generation: `$ui-generation-workflow-runner`
4. Refactor: `$ui-component-extractor`
5. Standards: `$frontend-standards-enforcer`
6. Quality: `$ui-acceptance-auditor` + `$ui-self-reviewer`
7. Foundation (new projects): `$project-scaffold-builder`
8. Component-library architecture (design systems): `$component-library-architect`
9. Workspace baseline: `$app-workspace-guide`
10. Fullflow orchestration: `$ui-fullflow-orchestrator`
11. Requirement completion entry: `$requirements-elicitation-engine`
12. Style boundary guard: `$style-scope-guard`
13. Icon system engine: `$svg-canvas-icon-engine`
14. Structure governance: `$skill-structure-governor` (validate bilingual/multi-platform packaging before release)

If the goal includes visual upgrade, stack selection, or architecture decisions, run the corresponding sub-skills first, then return to this skill for implementation convergence.

## Fullflow Entry (Recommended)

If users request full-chain execution or one-click pipeline, run:

```bash
bash skills/ui-fullflow-orchestrator/scripts/run_fullflow_pipeline.sh \
  --brief "<brief>" \
  --framework react \
  --project-type saas-modern \
  --priority performance \
  --priority accessibility \
  --density comfortable
```

This command generates selection/aesthetic/token/report artifacts automatically. Then this skill takes over implementation and quality convergence.

## Knowledge Sources (Read On Demand)

- Meta standard: `../../AI_UI_Skill_Design_Document.md`
- Meta standard: frontend development specification document (Chinese source file in repo)
- Main workflow: `../../ui-codegen-skill.md`
- Generation workflow: `../../ui-generation-workflow.md`
- Extraction rules: `../../component-extraction-rules.md`
- Code standards: `../../frontend-code-standards.md`
- Component-library guide: `../../component-library-guide.md`
- Scaffold template: `../../project-scaffold.md`
- Acceptance criteria: `../../ui-acceptance-criteria.md`
- Self-evaluation mechanism: `../../ui-self-evaluation.md`
- Aesthetic standards: `../../ui-aesthetic-skill.md`
- Fullflow contract: `../contracts/fullflow-handoff.md`
- Quality gates: `../contracts/quality-gates.md`
- Reasoning visibility: `../contracts/reasoning-visibility.md`

`app/` implementation references (for practical reuse decisions):
- `../../app/src/App.tsx`
- `../../app/src/components/*.tsx`
- `../../app/src/data/uiLibraries.ts`

## Execution Workflow

1. Requirement parsing
- For first-time `app` tasks, run `$app-workspace-guide` first to read stack and component baseline.
- Identify page type, business scenario, target audience, brand tone, and technical constraints.
- If stack is unclear, run `$ui-selector-pro`; in review scenarios add `$ui-selector-playbook`.
- For style-only tasks, run `$style-scope-guard` first to lock target area and editable files.
- For icon/visual-graphic tasks, run `$svg-canvas-icon-engine` first to generate icon baseline artifacts.

2. Design strategy
- Use `$ui-aesthetic-coach` for diagnosis; use `$ui-aesthetic-generator` to solidify generation standards.
- Run deterministic scripts when needed:

```bash
python3 skills/ui-aesthetic-coach/scripts/score_ui_brief.py --text "<brief>" --json
python3 skills/ui-aesthetic-coach/scripts/generate_design_tokens.py --direction "Data Clarity" --density comfortable --format both
```

3. Code generation and organization
- Execute four-step generation via `$ui-generation-workflow-runner`.
- Enforce structure/naming/TS/performance via `$frontend-standards-enforcer`.
- Reuse `app/src/components/ui/` and existing business-component patterns first.

4. Component extraction and refactor
- Apply extraction thresholds and refactor rules via `$ui-component-extractor`:
- file > 300 lines
- repeated JSX patterns >= 3
- nesting depth > 5
- complex condition branches
- business logic suitable for hook extraction

5. Acceptance and self-review
- Run three-level acceptance via `$ui-acceptance-auditor`.
- Use `$ui-self-reviewer` to output issue list and optimization-loop suggestions.

6. Delivery output
- Must include at minimum:
- runnable code
- key design/engineering decisions
- acceptance result and risk points
- follow-up optimization list
- If fullflow was used, consume `self-eval.scorecard.json` and `optimization.plan.md` as iteration entry.

## Output Contract

Response order is fixed:

1. Solution summary (goal, constraints, stack)
2. Implementation result (file-level changes)
3. Quality result (acceptance + self-review)
4. Risks and next actions

## Rules

- If docs and code conflict, trust current code behavior.
- Do not stop at advice only; default to runnable changes.
- When users request a distinctive style, reject generic template-like output and provide explicit visual direction plus token strategy.
- If scope lock is not passed, code modification is forbidden.
