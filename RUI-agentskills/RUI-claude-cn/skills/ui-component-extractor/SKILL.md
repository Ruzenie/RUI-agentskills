---
name: ui-component-extractor
description: 将 component-extraction-rules.md 转为可执行重构规则，负责识别拆分时机、执行组件抽离和回归验证。
---

# UI Component Extractor

目标：系统化拆分臃肿页面/组件，提升复用性与可维护性。

## SSOT

- `../references/component-extraction-rules.md`
- `../references/frontend-code-standards.md`（命名和目录规范）

## 触发阈值

- 单文件 > 300 行
- 单组件 > 200 行
- 同一 JSX 模式重复 >= 3 次
- JSX 嵌套深度 > 5
- 条件渲染分支 > 3
- 业务逻辑复杂且可迁移到 Hook

## 执行流程

1. 抽离候选识别
- 标记“结构块、重复块、状态块、逻辑块”。

2. 抽离策略选择
- 结构块 -> section 子组件
- 重复块 -> 可复用组件
- 状态块 -> 状态组件
- 逻辑块 -> `useXxx` 自定义 Hook

3. 实施重构
- 保持 props 最小化与类型完整。
- 避免抽离后反而引入过度耦合。

4. 回归验证
- 行为一致（UI/交互/数据流不回退）。
- 导入路径、导出索引、命名一致。

## 输出约定

1. 抽离前后结构对比
2. 新增组件/Hook 列表
3. 复用收益与风险点
4. 后续可继续抽离的候选项

## 协作关系

- 与 `ui-generation-workflow-runner` 联用：Step 3 优化阶段触发。
- 与 `frontend-standards-enforcer` 联用：重构后规范复检。
