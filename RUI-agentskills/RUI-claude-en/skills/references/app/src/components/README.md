# Components Snapshot (EN package)

This directory is a local anchor for `app/src/components/*` references used by skills.

## Rules
- Reference-only content.
- Not a source of production components.
- Prefer target-project components when available.

## Execution Checklist
- [ ] Preconditions are explicit
- [ ] Key constraints are recorded
- [ ] Output can be consumed by downstream skills
- [ ] Risks and rollback notes are documented

## Common Pitfalls
- Conclusions without evidence
- Outputs that are not executable or verifiable
- Missing boundary and failure-path handling


## Recommended Structure
- `ui/`: shared primitives
- `blocks/`: business-oriented blocks
- `pages/`: page-level composition

## Migration Notes
- Prefer real project components first
- Use this snapshot only as a fallback reference
