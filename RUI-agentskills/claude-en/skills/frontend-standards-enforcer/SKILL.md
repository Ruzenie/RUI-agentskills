---
name: frontend-standards-enforcer
description: Enforces frontend standards using frontend-code-standards.md, with checks and fix guidance across structure, naming, TypeScript, performance, and testing.
---

# Frontend Standards Enforcer

Goal: turn standards from recommendations into enforceable gates.

## SSOT

- `../../frontend-code-standards.md`
- Frontend development specification document (Chinese source file in repo)
- `../contracts/quality-gates.md`

## Check Scope

1. Project structure
- Directory layering, file organization, and responsibility boundaries.

2. Component standards
- Component taxonomy, file structure, and design principles.

3. Naming conventions
- Consistent naming for files, variables, functions, and events.

4. Code style
- Import ordering, render logic organization, and readability.

5. TypeScript standards
- Type definitions, props typing, and export patterns.

6. Performance standards
- Rerender control, splitting strategy, list optimization, and caching.

7. Testing standards
- Test file organization and critical-path coverage.

8. Security and compatibility baseline
- Input safety, sensitive-data exposure checks, and mainstream browser compatibility.

9. Change-boundary compliance
- For style tasks, verify whether changes cross into non-target modules or business logic.

10. Icon-system consistency (on demand)
- If icon artifacts exist, validate naming, size tiers, and style-rule consistency.

## Hard Rules

- `any` is not allowed unless strongly justified; otherwise block.
- Business functions should be <= 50 lines; split when exceeded.
- Render logic > 30 lines must be extracted into subcomponents.
- Prop drilling deeper than 3 levels should migrate to Context/state management.
- Repeated patterns >= 3 must be extracted.
- If `style.scope.lock.json` exists, out-of-scope edits must be blocked.

## Execution Method

- Each check item must output one of: `pass / warning / block`.
- Every blocked item must include the shortest repair path.

## Output Contract

1. Violation list (sorted by severity)
2. Directly executable fix suggestions
3. Estimated benefits and risks
4. Merge recommendation

## Collaboration

- Serves as the code-quality checker in `ui-codegen-master`.
- Works with `ui-component-extractor` for post-refactor regression checks.
