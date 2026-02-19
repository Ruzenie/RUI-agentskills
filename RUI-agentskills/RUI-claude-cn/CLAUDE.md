<!-- bootstrap: lang=zh-CN; encoding=UTF-8 -->
<!-- STRUCTURE_TEMPLATE: claude -->

# Skills Bootstrap (Claude)

用于 Claude 环境的结构入口模板，强调“共享技能 + 语言变体文档”。

## 使用方式

1. 将本模板内容合并到项目的 `CLAUDE.md`（按项目规则适配）。
2. 保持技能实现目录为单一来源：`skills/<skill-name>/`。
3. 通过双语索引切换阅读语言：
   - 中文：`skills/variants/CN/SKILLS.md`
   - 英文：`skills/variants/EN/SKILLS.md`

## 结构约束

- 不复制技能实现，仅维护文档变体。
- 平台差异仅体现在入口模板，不体现在技能逻辑。
- 发布前执行结构校验：

```bash
python3 skills/skill-structure-governor/scripts/validate_structure.py
```

## 快捷点名与前端路由

- 别名映射：`$ui` 等价于 `$ui-fullflow-orchestrator`。
- 别名兜底解析（强制）：即使可用技能列表中没有名为 `ui` 的条目，也必须将 `$ui` 解析为 `$ui-fullflow-orchestrator`，禁止回复“没有同名 ui”并改走其它技能。
- 点名优先：用户显式点名任意技能时，优先按用户指定执行。
- 全流程锁定（强制）：用户显式输入 `$ui` 或 `$ui-fullflow-orchestrator` 时，必须锁定为全流程编排，禁止降级或改路由到 `$ui-codegen-master` 等单技能。
- 缺参处理（强制）：即使缺少参数，也只能追问补全（`framework`、`project-type`），不得通过降级绕过。
- 必过技能链（强制）：`$ui` 全流程必须覆盖 `requirements-elicitation-engine`、`ui-codegen-master`、`ui-selector-playbook`、`ui-aesthetic-coach`、`ui-aesthetic-generator`、`ui-generation-workflow-runner`、`ui-acceptance-auditor`、`ui-self-reviewer`、`ui-agent-workspace`。
- 前端默认路由：未点名技能但属于前端/UI任务时，默认走 `$ui` 全流程。
- 参数补全：当用户仅输入 `$ui "需求描述"` 时，先追问 `目标前端技术栈` 与 `项目类型标签`，补全后再执行全流程。
- 前端任务范围（示例）：页面开发、组件开发、样式/视觉优化、交互改造、前端重构、可访问性与性能优化。
- 非前端任务：按常规技能匹配，不强制走 `$ui`。

推荐触发示例：
- `请用 $ui 生成一个电商分析仪表盘`
- `优化这个 React 页面样式`（未点名时默认路由到 `$ui`）

<!-- bundle_platform: claude -->
<!-- bundle_locale: CN -->
<!-- bundle_language: zh-CN -->

## 分发包入口
- 技能索引: `skills/variants/CN/SKILLS.md`
- 结构校验: `python3 skills/skill-structure-governor/scripts/validate_structure.py`
