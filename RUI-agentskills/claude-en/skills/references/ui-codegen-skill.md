# UI Codegen Skill

## Overview
This reference defines the end-to-end generation baseline used by codegen-related skills.

## Lifecycle
1. Requirement Clarification
2. Structure and Style Planning
3. Implementation and Composition
4. Validation and Convergence
5. Iteration and Handoff

## Input Contract
- requirement brief
- workspace baseline
- style scope lock (if style changes are involved)
- implementation constraints

## Output Contract
- runnable result
- file-level change list
- validation evidence
- risk and next-step notes

## Execution Rules
- Keep deterministic checks before heuristic refinement.
- Prefer reuse over unnecessary new abstractions.
- Do not proceed when blockers are unresolved.

## Quality Checklist
- [ ] Scope lock passed
- [ ] Core path is runnable
- [ ] Acceptance and self-review completed
- [ ] Delivery summary is traceable
