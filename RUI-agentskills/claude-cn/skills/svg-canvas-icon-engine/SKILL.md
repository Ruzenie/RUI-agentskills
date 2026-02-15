---
name: svg-canvas-icon-engine
description: 将 Kimi 的 SVG/Canvas 图标能力转为可执行技能，生成图标清单、规范与可复用资源。
---

# SVG Canvas Icon Engine

目标：当需求涉及图标/插画/可视化时，快速给出一致的图标方案与产物。

## SSOT

- `../../Kimi_Agent_UI组件库AI技能/svg-canvas-icon-skill.md`
- `../../Kimi_Agent_UI组件库AI技能/svg-canvas-cheatsheet.md`
- `../../Kimi_Agent_UI组件库AI技能/icon-library.html`
- `../contracts/fullflow-handoff.md`
- `../contracts/quality-gates.md`

## 何时使用

- 需求中出现图标系统、SVG、Canvas、可视化图形、动态图形。
- 需要统一图标风格、尺寸、命名和交付格式。
- 需要给 UI 生成阶段提供图标资源基线。

## 可执行脚本

```bash
python3 skills/svg-canvas-icon-engine/scripts/generate_icon_assets.py \
  --brief "SaaS看板，需要导航和状态图标，支持动效" \
  --framework react \
  --out-dir /tmp/icon-artifacts \
  --mode auto \
  --style outline
```

## 输出产物

- `icon.manifest.json`：图标清单、分类、技术建议（SVG/Canvas）
- `icon.spec.md`：图标系统规范（尺寸、描边、命名、使用规则）
- `icon.sprite.svg`：可直接复用的 SVG symbol sprite
- `canvas.icon.demo.js`：Canvas 绘制起步模板（按需使用）

## 规则

1. 默认优先 SVG
- 图标/UI控件场景默认推荐 SVG（可缩放、易样式化、体积小）。

2. Canvas 触发条件
- 大量动态图形、像素处理、复杂绘制性能需求时推荐 Canvas。

3. 风格一致性
- 必须统一尺寸、描边、圆角、端点样式和命名方式。

## 协作关系

- `ui-fullflow-orchestrator`：作为可选阶段插入，产出图标基线。
- `ui-generation-workflow-runner`：实现阶段优先复用 `icon.sprite.svg`。
- `frontend-standards-enforcer`：检查命名、尺寸、可维护性一致性。
