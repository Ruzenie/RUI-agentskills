# UI Agent Workspace 技能文档

> 一套专为前端UI开发设计的Agent协作框架技能文档

## 文档清单

| 序号 | 文档 | 说明 |
|------|------|------|
| 01 | [核心概念](01-core-concept.md) | 架构概述、关键概念、工作流程 |
| 02 | [Workspace管理](02-workspace-manager.md) | 目录结构、配置文件、会话管理 |
| 03 | [UI修改记录协议](03-ui-modification-log.md) | 修改类型、记录格式、自动化标记 |
| 04 | [画布空间使用](04-canvas-system.md) | 画布结构、绘制方式、标注规范 |
| 05 | [Markdown图形绘制](05-markdown-graphics.md) | ASCII艺术、Mermaid图表、图标符号 |
| 06 | [组件示例库](06-component-library.md) | 组件模板、布局模板、页面模板 |

## 快速开始

### 1. 理解核心概念

首先阅读 [01-核心概念](01-core-concept.md)，了解：
- 什么是UI Agent Workspace
- 核心架构组件
- Agent角色分工
- 数据流向

### 2. 搭建Workspace

参考 [02-Workspace管理](02-workspace-manager.md) 创建：
```
my-project/
├── .workspace/       # 工作空间配置
├── canvas/          # 画布文件
├── docs/            # 文档
├── logs/            # 修改日志
└── src/             # 源代码
```

### 3. 记录UI修改

每次修改按 [03-UI修改记录协议](03-ui-modification-log.md) 记录：
```markdown
<!-- @ui-modify:001 -->
### [modify] 调整按钮圆角

**影响范围**: src/components/Button.tsx

**视觉变更**:
```
修改前: ┌─────────┐    修改后: ╭─────────╮
        │  按钮   │            │  按钮   │
        └─────────┘            ╰─────────╯
```
<!-- @ui-modify:001:end -->
```

### 4. 使用画布设计

在 [04-画布空间](04-canvas-system.md) 中绘制UI：
```markdown
# Component: Button

## 视觉设计
```
╭─────────────────╮
│     提交        │
╰─────────────────╯
```

## 规格
| 属性 | 值 |
|------|-----|
| 圆角 | 12px |
```

## 核心特性

- ✅ **Markdown原生**: 所有记录使用Markdown格式，便于版本控制
- ✅ **可视化设计**: ASCII艺术 + Mermaid图表，清晰表达UI设计
- ✅ **完整追溯**: 每次修改都有结构化记录，支持回滚
- ✅ **组件模板**: 预制组件画布模板，加速开发
- ✅ **人机协作**: 人类可轻松理解和修改Agent生成的内容

## 使用场景

| 场景 | 使用文档 |
|------|----------|
| 初始化项目 | [02-Workspace管理](02-workspace-manager.md) |
| 设计新组件 | [04-画布空间](04-canvas-system.md) + [06-组件示例库](06-component-library.md) |
| 修改现有UI | [03-UI修改记录协议](03-ui-modification-log.md) |
| 绘制布局图 | [05-Markdown图形绘制](05-markdown-graphics.md) |
| 团队协作 | 全部文档 |

## 示例工作流

```
用户: "把按钮改成圆角样式"
  ↓
Agent解析意图 → 提取关键信息
  ↓
更新画布 → canvas/components/button.md
  ↓
生成代码 → src/components/Button.tsx
  ↓
记录变更 → logs/CHANGELOG.md
  ↓
保存状态 → .workspace/state.json
```

## 最佳实践

1. **即时记录**: 每次修改后立即记录，不要批量补录
2. **画布先行**: 复杂UI先在画布上设计，再写代码
3. **版本控制**: 所有Markdown文件纳入Git管理
4. **定期归档**: 日志超过50条后归档到logs/archive/
5. **状态标记**: 使用自动化标记清晰表达进度

## 扩展阅读

- [Mermaid语法](https://mermaid.js.org/intro/)
- [Markdown规范](https://www.markdownguide.org/)
