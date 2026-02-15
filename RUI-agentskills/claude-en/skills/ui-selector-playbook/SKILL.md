---
name: ui-selector-playbook
description: Integrates UI selection method docs (workflow, cheatsheet, prompts, ADR templates) into a strategy skill for review meetings and decision-record scenarios.
---

# UI Selector Playbook

Goal: provide discussable and auditable selection workflows and templates, covering decision steps beyond pure algorithmic recommendation.

## SSOT

- `../../ui-selector-skill.md`
- `../../ui-evaluation-flow.md`
- `../../ui-selector-cheatsheet.md`
- `../../ui-selector-prompts.md`
- `../../UI-Design-AI-Skill.md`

## Applicable Scenarios

- Team review meetings, technical committees, architecture reviews.
- ADR writing, migration assessment, POC planning, and risk register output.

## Execution Flow

1. Requirement clarification
- Framework, project type, constraints, priorities, timeline.

2. Candidate filtering
- Use cheatsheet to reduce options quickly to 3-5 candidates.

3. Deep evaluation
- Score with six dimensions and produce evaluation matrix.

4. POC and decision
- Output POC scope, acceptance thresholds, and ADR draft.

## Quick Stack Matrix (Default Suggestions)

- React: `shadcn/ui` (primary), fallback `Chakra UI` / `Mantine`
- Vue 3: `Element Plus` (primary), fallback `Naive UI` / `Vuetify`
- Next.js: `Radix UI + Tailwind CSS` or `shadcn/ui`
- Svelte: `Bits UI` / `Skeleton`
- Vanilla HTML/CSS: `DaisyUI`, fallback `Bootstrap 5` / `Bulma`

## Output Contract

1. Candidate shortlist and elimination reasons
2. Evaluation matrix (dimension + weight + score)
3. Decision recommendation (primary/fallback)
4. ADR-style conclusion and migration path

## Collaboration

- Use with `ui-selector-pro`:
  - `ui-selector-pro` handles deterministic computation
  - this skill handles review-process decisions and documentation
