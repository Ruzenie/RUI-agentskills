---
name: ui-generation-workflow-runner
description: 按四步生成法执行 UI 生成任务（结构规划→组件实现→代码优化→质量验收），将 ui-generation-workflow.md 转为可执行流程。
---

# UI Generation Workflow Runner

目标：把 `ui-generation-workflow.md` 从说明文档转为可执行任务清单，稳定产出页面级 UI。

## SSOT

- `../../ui-generation-workflow.md`
- `../../ui-codegen-skill.md`（阶段定义补充）
- `../../AI前端开发技能规范.md`（生命周期约束补充）
- `../contracts/quality-gates.md`

## 适用场景

- 新建页面：Landing、Dashboard、Form 等。
- 需要严格按步骤生成，而不是一次性“拍脑袋出稿”。

## 执行流程

1. 预生成检查
- 明确：页面类型、目标用户、核心 CTA、关键模块。
- 缺信息时只问最小问题集（最多 3 个）。
- 样式改动任务必须先验证 `style.scope.lock.json`，未锁定范围不得继续。

2. Step 1 结构规划
- 先产出页面区块树与信息层级。
- 明确首屏优先级与移动端折叠策略。

3. Step 2 组件实现
- 优先复用现有 `app/src/components/ui/*`。
- 统一设计令牌：颜色、排版、间距、圆角、阴影。
- 补齐状态：default/hover/focus/disabled/loading/error。
- 若存在 `icon.sprite.svg`，优先复用其中图标，避免重复绘制。

4. Step 3 代码优化
- 按 `frontend-standards-enforcer` 校正结构、类型与性能。
- 触发抽离条件时调用 `ui-component-extractor`。

5. Step 4 质量验收
- 调用 `ui-acceptance-auditor` 做三级验收。
- 不达标则进入一轮定向修复。

## 输出约定

1. 页面结构摘要
2. 实现文件清单
3. 验收结论（通过/需优化）
4. 下一轮优化优先项（最多 3 条）

## 协作关系

- 视觉方向不明确时，先调用 `ui-aesthetic-coach` 或 `ui-aesthetic-generator`。
- 组件库未定时，先调用 `ui-selector-pro` 或 `ui-selector-playbook`。
