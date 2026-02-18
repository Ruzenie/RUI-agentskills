# UI Agent Workspace 能力映射

本文件把 `skills/ui-agent-workspace` 的 6 份文档能力映射为可执行协作规则。

## 来源映射

1. `01-core-concept.md`
- 定义 Workspace、Canvas、Modification Log 三层协作模型。
- 固化数据流：用户意图 -> 画布 -> 代码 -> 日志 -> 状态。

2. `02-workspace-manager.md`
- 规范 `.workspace/`、`canvas/`、`docs/`、`logs/` 目录。
- 约束 `config.json`、`state.json`、`index.json`、`sessions/*.json` 结构。

3. `03-ui-modification-log.md`
- 规范变更类型与日志模板。
- 补充批量修改、回滚、实验性改动三种特殊记录模板。

4. `04-canvas-system.md`
- 规范页面级/组件级画布结构。
- 统一图形表达（ASCII、Mermaid、规格表、代码片段）。

5. `05-markdown-graphics.md`
- 约束 Markdown 图形字符、边框、状态绘制与布局示例语法。

6. `06-component-library.md`
- 提供组件模板骨架、变体定义与 Props 规范。

## 交付最小集合

- 画布文件：`canvas/pages/*.md` 或 `canvas/components/*.md`
- 状态文件：`.workspace/state.json`
- 索引文件：`.workspace/index.json`
- 修改日志：`logs/CHANGELOG.md`
- 会话记录：`.workspace/sessions/session_xxx.json`

## 质量检查要点

1. 画布规格与实现代码是否一致。
2. 每次 UI 修改是否有唯一 ID 和上下文描述。
3. `canvas -> code -> log` 链路是否可追溯。
4. 回滚信息是否可直接定位到原修改。
