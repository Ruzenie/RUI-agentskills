---
name: ui-agent-workspace
description: Converts workspace state, canvas design, and UI modification logging into an executable markdown-first collaboration workflow.
---

# UI Agent Workspace

Goal: establish a single collaboration baseline across `workspace + canvas + modification log` so UI changes are visualized, traceable, and auditable.

## Source Of Truth

- `references/workspace-capability-map.md`
- `references/01-core-concept.md`
- `references/02-workspace-manager.md`
- `references/03-ui-modification-log.md`
- `references/04-canvas-system.md`
- `references/05-markdown-graphics.md`
- `references/06-component-library.md`
- `../contracts/fullflow-handoff.md`
- `../contracts/quality-gates.md`

## Capability Scope

1. Workspace management
- Standard directory layout, config/state/index/session files, and context switching discipline.

2. Canvas-first UI design
- Page/component/layout canvas structure with ASCII + Mermaid + specification table outputs.

3. UI modification protocol
- Typed records using `add/remove/modify/refactor/fix/update`, including `batch/rollback/experimental` scenarios.

4. Markdown graphics standard
- Consistent notation for components, layouts, state transitions, and before/after visual diffs.

5. Component template library
- Reusable templates for `button/input/card/modal/table` and common variants.

6. Traceability chain
- Enforce `canvas -> code -> logs -> session` linkage.

## When To Use

- Tasks involve UI structure design, visual iteration, or style refactoring.
- You need auditable links between requirements, design artifacts, and code changes.
- Team collaboration requires reproducible UI delivery history.

## Standard Outputs

1. `canvas/...` design artifacts and specs.
2. `.workspace/config.json`, `.workspace/state.json`, `.workspace/index.json`.
3. `logs/CHANGELOG.md` with structured UI change records.
4. `.workspace/sessions/session_xxx.json` as execution trail.

## Workflow

1. Check whether workspace skeleton exists and initialize if missing.
2. Update `canvas/pages` or `canvas/components` from user intent.
3. Sync key visual/interaction specs into implementation files.
4. Write one standardized UI modification log entry with a unique ID.
5. Update state and index mappings.
6. Handoff changed files and pending verification items downstream.

## Collaboration

- `ui-codegen-master`: use as upstream context baseline before implementation.
- `ui-generation-workflow-runner`: consume canvas specs and write back logs/state on closure.
- `ui-component-extractor`: read canvas + logs before extraction to avoid semantic drift.
- `ui-self-reviewer`: validate pre-delivery consistency with canvas and logs.
