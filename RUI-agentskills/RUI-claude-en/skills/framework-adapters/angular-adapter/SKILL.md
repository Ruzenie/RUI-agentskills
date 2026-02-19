---
name: angular-adapter
description: Angular 项目适配器，提供模板、services 与框架特定约束。
---

# Angular Adapter

## 适用场景
- `framework=angular`
- 需要输出 Angular 组件与服务模板

## 输入
- `framework`: `angular`
- `out-dir`: 产物目录

## 输出
- `framework.adapter.manifest.json`
- `framework-adapter/templates/*`
- `framework-adapter/services/*`

## 目录约定
- `templates/`: Angular 组件模板
- `services/`: Angular 服务模板

## 使用方式
- 由 `skills/framework-adapters/scripts/select_adapter.py` 自动选择并落地
- 该能力由 `ui-fullflow-orchestrator` 在 Phase2 自动调用
