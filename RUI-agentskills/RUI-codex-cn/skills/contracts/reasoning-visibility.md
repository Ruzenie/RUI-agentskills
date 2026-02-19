# Reasoning Visibility Contract

目标：在不暴露模型私有推理细节的前提下，让用户看到“可审计的决策过程”。

## 可见内容（允许输出）

1. 输入与假设
- 用户输入摘要
- 明确假设条件
- 缺失信息与待确认项

2. 决策路径
- 采用了哪些技能/脚本
- 按阶段展示技能映射（`Phase -> skills`），并在对话中逐阶段可见
- 每一步的目的
- 关键分支选择理由（简要）

3. 证据与结果
- 评分结果、候选方案对比、门禁结论
- 生成产物路径与状态
- 如涉及图标系统：说明 SVG/Canvas 选择依据与产物清单

4. 风险与下一步
- 当前风险清单
- 下一步建议动作

## 不可见内容（禁止输出）

- 模型内部完整 Chain-of-Thought
- 中间私有推理草稿
- 未经筛选的内部思维片段

## 标准产物

- `decision.trace.md`：用户可读的决策轨迹摘要
- `stage.status.json`：阶段状态机
- `quality.gates.md`：质量门禁清单
- `self-eval.scorecard.json`：量化门槛状态与就绪度
- `optimization.plan.md`：基于门槛缺口生成的优化动作

## decision.trace.md 模板

```markdown
# Decision Trace

## 1. 输入摘要
- brief: ...
- framework: ...

## 2. 决策路径
1. requirements-elicitation-engine: ...
2. ui-selector-pro: ...
3. ui-aesthetic-coach: ...

## 3. 关键决策
- 选型决策: ...（证据）
- 风格决策: ...（证据）

## 4. 风险与待确认
- ...

## 5. 下一步
- ...
```
