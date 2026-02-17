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
- 点名优先：用户显式点名任意技能时，优先按用户指定执行。
- 前端默认路由：未点名技能但属于前端/UI任务时，默认走 `$ui` 全流程。
- 前端任务范围（示例）：页面开发、组件开发、样式/视觉优化、交互改造、前端重构、可访问性与性能优化。
- 非前端任务：按常规技能匹配，不强制走 `$ui`。

推荐触发示例：
- `请用 $ui 生成一个电商分析仪表盘`
- `优化这个 React 页面样式`（未点名时默认路由到 `$ui`）
