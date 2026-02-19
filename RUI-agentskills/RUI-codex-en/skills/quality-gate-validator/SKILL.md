---
name: quality-gate-validator
description: Automated quality-gate validator that emits gate-validation-report.json.
---

# Quality Gate Validator

Goal: turn gate checks from checklist-only into executable validation.

## Usage

```bash
python3 skills/quality-gate-validator/scripts/validate_gates.py \
  --out-dir /path/to/Ruiagents/xxx \
  --workspace-root /path/to/workspace \
  --report /path/to/Ruiagents/xxx/gate-validation-report.json \
  --tool-checks auto
```

## Inputs

- `self-eval.scorecard.json`
- `requirements.summary.json`
- `aesthetic.score.json`
- `phase4.refactor.report.json` (optional)
- `phase5.acceptance.report.json` (optional)
- `package.json scripts` (optional, for lint/typecheck/test/a11y/lighthouse)

## Output

- `gate-validation-report.json`
