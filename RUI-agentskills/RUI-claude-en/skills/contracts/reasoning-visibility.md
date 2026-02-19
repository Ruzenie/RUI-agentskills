# Reasoning Visibility Contract

Goal: expose an auditable decision process to users without revealing private model chain-of-thought.

## Visible Content (Allowed)

1. Inputs and assumptions
- user input summary
- explicit assumptions
- missing information and open confirmations

2. Decision path
- skills/scripts used
- stage-by-stage skill mapping (`Phase -> skills`) that is visible in chat for each phase
- objective of each step
- concise reason for key branch choices

3. Evidence and results
- scores, option comparisons, gate conclusions
- artifact paths and statuses
- for icon tasks: rationale for SVG vs Canvas and generated asset list

4. Risks and next steps
- current risk list
- recommended next actions

## Hidden Content (Forbidden)

- full internal chain-of-thought
- private scratch reasoning
- raw unfiltered internal thought fragments

## Standard Artifacts

- `decision.trace.md`: user-readable decision trace summary
- `stage.status.json`: stage state machine
- `quality.gates.md`: quality gate checklist
- `self-eval.scorecard.json`: quantitative readiness state
- `optimization.plan.md`: optimization actions generated from threshold gaps

## `decision.trace.md` Template

```markdown
# Decision Trace

## 1. Input Summary
- brief: ...
- framework: ...

## 2. Decision Path
1. requirements-elicitation-engine: ...
2. ui-selector-pro: ...
3. ui-aesthetic-coach: ...

## 3. Key Decisions
- Selection decision: ... (evidence)
- Style decision: ... (evidence)

## 4. Risks and Open Items
- ...

## 5. Next Steps
- ...
```
