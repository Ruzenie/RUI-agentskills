# App Workspace Context (Essential)

## Purpose
Local fallback context for `app-workspace-guide`, used when target repository context is unavailable.

## Read Order
1. Stack and tooling baseline
2. Directory constraints
3. Component reuse strategy
4. Validation scripts

## Rules
- Prefer reuse over new abstractions.
- Keep page layer thin.
- Keep data/config centralized.

## Execution Checklist
- [ ] Preconditions are explicit
- [ ] Key constraints are recorded
- [ ] Output can be consumed by downstream skills
- [ ] Risks and rollback notes are documented

## Common Pitfalls
- Conclusions without evidence
- Outputs that are not executable or verifiable
- Missing boundary and failure-path handling

