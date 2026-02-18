---
name: ui-component-extractor
description: Converts component-extraction-rules.md into executable refactor rules for split-point detection, component extraction, and regression validation.
---

# UI Component Extractor

Goal: systematically split bloated pages/components to improve reuse and maintainability.

## SSOT

- `../references/component-extraction-rules.md`
- `../references/frontend-code-standards.md` (naming and directory standards)

## Trigger Thresholds

- Single file > 300 lines
- Single component > 200 lines
- Same JSX pattern repeated >= 3 times
- JSX nesting depth > 5
- Conditional rendering branches > 3
- Complex business logic suitable for hook extraction

## Execution Flow

1. Detect extraction candidates
- Mark structure blocks, repeated blocks, state blocks, and logic blocks.

2. Choose extraction strategy
- Structure block -> section subcomponent
- Repeated block -> reusable component
- State block -> state-focused component
- Logic block -> `useXxx` custom hook

3. Implement refactor
- Keep props minimal and types complete.
- Avoid introducing tighter coupling after extraction.

4. Regression validation
- Behavior consistency (no regression in UI/interaction/data flow).
- Consistent import paths, export index, and naming.

## Output Contract

1. Before/after structure comparison
2. New component/hook list
3. Reuse gains and risk points
4. Next extraction candidates

## Collaboration

- Use with `ui-generation-workflow-runner`: trigger in Step 3 optimization.
- Use with `frontend-standards-enforcer`: run standards re-check after refactor.
