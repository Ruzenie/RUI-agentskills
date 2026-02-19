# Plugins

插件目录遵循 `plugin.yaml` (JSON-compatible YAML) 约定。

字段:
- `hooks[].phase`: `phase1_requirements|phase2_architecture|phase3_implementation|phase4_self_review|phase5_acceptance`
- `hooks[].when`: `before|after`
- `hooks[].action`: 相对插件目录的可执行脚本路径
- `dependencies`: 依赖技能列表（在 `flow.state.json` 中需为 completed 系状态）
- `artifacts`: 执行后必须存在的产物（在 `out-dir`/`workspace`/插件目录任一处可命中）

内置示例:
- `my-custom-skill`: 最小可运行插件示例（Phase4/Phase5）
- `token-consistency-audit`: 在 Phase4 前检查 `tokens.json`/`tokens.css` 产物一致性
- `perf-budget-guard`: 在 Phase5 后读取 `flow.metrics.json` 输出性能预算报告

快速扩展:
1. 复制任一示例目录并改名
2. 修改 `plugin.yaml` 的 `hooks/dependencies/artifacts`
3. 在 `scripts/` 中实现 action 脚本并赋予执行权限
