# Skills 结构说明

本文档记录本仓库技能系统的结构约束与维护规则。

## 目标

1. 单一实现来源
- 技能实现仅维护在 `skills/<skill-name>/`。

2. 双语入口一致
- 中文入口：`skills/variants/CN/SKILLS.md`
- 英文入口：`skills/variants/EN/SKILLS.md`

3. 多平台包装一致
- Codex 入口模板：`skills/platforms/codex/AGENTS.template.md`
- Claude 入口模板：`skills/platforms/claude/CLAUDE.template.md`

## 非目标

- 不在多语言目录复制技能实现逻辑。
- 不在平台模板中引入业务特定规则。

## 校验与分发

```bash
python3 skills/skill-structure-governor/scripts/render_bilingual_index.py
python3 skills/skill-structure-governor/scripts/validate_structure.py
python3 skills/skill-structure-governor/scripts/export_skill_bundles.py --out-dir dist/skills-bundle-test --clean
```
