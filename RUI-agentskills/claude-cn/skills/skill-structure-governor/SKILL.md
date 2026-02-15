---
name: skill-structure-governor
description: 管理 skills 的结构一致性，确保双语入口与多平台包装模板完整。
---

# Skill Structure Governor

目标：治理本仓库的技能组织结构，确保双语入口和多平台包装始终一致。

## SSOT

- `../structure/skills-structure-notes.md`
- `../variants/manifest.json`
- `../variants/skills.bilingual.json`

## 何时使用

- 需要发布/同步技能包时。
- 新增技能后，需要校验双语入口是否同步更新。
- 需要检查平台包装模板（Codex/Claude）是否完整时。

## 可执行脚本

```bash
python3 skills/skill-structure-governor/scripts/render_bilingual_index.py
python3 skills/skill-structure-governor/scripts/validate_structure.py
python3 skills/skill-structure-governor/scripts/export_skill_bundles.py
```

## 检查项

1. 双语入口文件
- `skills/variants/CN/SKILLS.md`
- `skills/variants/EN/SKILLS.md`

2. 平台包装模板
- `skills/platforms/codex/AGENTS.template.md`
- `skills/platforms/claude/CLAUDE.template.md`

3. 技能总览一致性
- `skills/README.md` 的技能总数与实际技能目录数量是否一致。

4. 双语清单覆盖一致性
- `skills/variants/skills.bilingual.json` 必须覆盖全部技能目录。
- CN/EN 索引文件由双语清单自动生成。

## 输出约定

1. `PASS`：结构完整
2. `FAIL`：列出缺失项和修复路径
3. `EXPORT`：输出四套分发目录（`codex-cn/codex-en/claude-cn/claude-en`）

## 规则

- 不复制技能实现逻辑到多语言目录。
- 多语言目录只承载“入口与说明”，实现仍在 `skills/<skill-name>/` 单源维护。
