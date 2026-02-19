---
name: react-adapter
description: React 项目适配器，提供模板、hooks 与框架特定约束。
---

# React Adapter

## 适用场景
- `framework=react` 或 `framework=next`
- 需要输出 React 组件骨架与 hooks 模板

## 输入
- `framework`: `react|next`
- `out-dir`: 产物目录

## 输出
- `framework.adapter.manifest.json`
- `framework-adapter/templates/*`
- `framework-adapter/hooks/*`

## 目录约定
- `templates/`: 组件与页面模板
- `hooks/`: React hooks 模板

## 使用方式
- 由 `skills/framework-adapters/scripts/select_adapter.py` 自动选择并落地
- 该能力由 `ui-fullflow-orchestrator` 在 Phase2 自动调用
