---
name: quality-gate-validator
description: 自动化验证 quality gates 量化门槛，输出 gate-validation-report.json。
---

# Quality Gate Validator

目标：将门禁从“清单提示”升级为“可执行校验”。

## 用法

```bash
python3 skills/quality-gate-validator/scripts/validate_gates.py \
  --out-dir /path/to/Ruiagents/xxx \
  --workspace-root /path/to/workspace \
  --report /path/to/Ruiagents/xxx/gate-validation-report.json \
  --tool-checks auto
```

## 输入依赖

- `self-eval.scorecard.json`
- `requirements.summary.json`
- `aesthetic.score.json`
- `phase4.refactor.report.json` (可选)
- `phase5.acceptance.report.json` (可选)
- `package.json scripts` (可选，用于 lint/typecheck/test/a11y/lighthouse)

## 输出

- `gate-validation-report.json`
