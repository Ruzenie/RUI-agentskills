<!-- bootstrap: lang=zh-CN; encoding=UTF-8 -->
<!-- STRUCTURE_TEMPLATE: codex -->

# Skills Bootstrap (Codex)

用于 Codex 环境的结构入口模板，强调“共享技能 + 语言变体文档”。

## 使用方式

1. 将本模板内容合并到项目的 `AGENTS.md`（按项目规则适配）。
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

<!-- bundle_platform: codex -->
<!-- bundle_locale: CN -->
<!-- bundle_language: zh-CN -->

## 分发包入口
- 技能索引: `skills/variants/CN/SKILLS.md`
- 结构校验: `python3 skills/skill-structure-governor/scripts/validate_structure.py`
