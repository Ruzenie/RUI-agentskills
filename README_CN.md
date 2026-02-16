# RUI-agentskills

**一套可直接挂载到 Codex / Claude 的 UI 研发技能系统。**

<p align="center">
  <a href="./README_CN.md"><img src="https://img.shields.io/badge/简体中文-blue?style=for-the-badge" alt="简体中文"></a>
  <a href="./README.md"><img src="https://img.shields.io/badge/English-blue?style=for-the-badge" alt="English"></a>
</p>

![Bundles](https://img.shields.io/badge/bundles-4-2563eb)
![Skills](https://img.shields.io/badge/skills-19-16a34a)
![Platforms](https://img.shields.io/badge/platform-codex%20%7C%20claude-f59e0b)

## 项目简介

本项目提供一套完整的 UI 研发 Skills 打包分发方案，覆盖需求澄清、样式边界控制、代码生成、规范检查、验收与自评。
目标不是只给建议，而是让 Agent 稳定推进到“可运行实现 + 可验证交付”。

核心特点：

1. 四套可直接使用的分发包（Codex / Claude × 中文 / 英文）
2. 19 个协作技能，支持全流程串联
3. 样式改动边界锁，降低误改业务逻辑风险
4. 支持全局安装到 `~/.codex/skills`

## 为什么使用这套包

| 场景 | 常见问题 | 这套 Skills 的处理方式 |
|---|---|---|
| 需求不完整 | 直接开写导致返工 | 先执行 `requirements-elicitation-engine` 补齐输入 |
| 样式改动 | 容易误改业务逻辑 | `style-scope-guard` 先锁定改动范围 |
| 多技能协作 | 前后文断裂、产物不一致 | `ui-fullflow-orchestrator` 统一编排与产物约定 |
| 质量验收 | 标准不一致、难复盘 | 验收 + 自评 + 量化评分卡闭环 |

## 30 秒上手

1. 选包：`RUI-agentskills/codex-cn`（或 `codex-en` / `claude-*`）
2. 复制 `skills/` 到目标位置（项目内或 `~/.codex/skills`）
3. 合并入口文件：`AGENTS.md` 或 `CLAUDE.md`
4. 直接调用：`$ui-fullflow-orchestrator` / `$ui-codegen-master`

---

## 1. 目录与已导出包

当前目录已导出 4 套可直接使用的技能包（位于 `RUI-agentskills/`）：

1. `RUI-agentskills/codex-cn`
2. `RUI-agentskills/codex-en`
3. `RUI-agentskills/claude-cn`
4. `RUI-agentskills/claude-en`

元信息清单：

- `RUI-agentskills/bundle.manifest.json`

## 2. 每个包里有什么

每个包都包含：

1. 平台入口文件  
- Codex 包：`AGENTS.md`  
- Claude 包：`CLAUDE.md`

2. 技能实现目录  
- `skills/`（19 个技能）

3. 双语索引与结构配置  
- `skills/variants/*`  
- `skills/platforms/*`  
- `skills/contracts/*`

## 3. 选择哪一个包

1. 你在 Codex 使用：选 `codex-cn` 或 `codex-en`
2. 你在 Claude 使用：选 `claude-cn` 或 `claude-en`
3. 你希望中文交互：选 `*-cn`
4. 你希望全英文交互：选 `*-en`

## 4. 如何在项目里接入

1. 把目标包内入口文件合并到你的项目入口规则文件  
- Codex：合并 `AGENTS.md`  
- Claude：合并 `CLAUDE.md`

2. 将包里的 `skills/` 目录复制到你的项目根目录

3. 在对话中直接调用技能名，例如：
- `$ui-codegen-master`
- `$ui-fullflow-orchestrator`
- `$style-scope-guard`

## 4.1 直接安装到 Codex 全局 skills（推荐）

如果你希望在所有项目里直接可用，可把技能装到 `~/.codex/skills`：

```bash
mkdir -p ~/.codex/skills
cp -R /home/ruzenie/ai/ruiskills/RUI-agentskills/codex-cn/skills/* ~/.codex/skills/
```

然后把入口规则放到目标项目：

```bash
cp /home/ruzenie/ai/ruiskills/RUI-agentskills/codex-cn/AGENTS.md <你的项目路径>/AGENTS.md
```

英文版替换路径中的 `codex-cn` 为 `codex-en` 即可。

## 5. 常用技能调用方式

1. 一键全流程编排

```bash
bash skills/ui-fullflow-orchestrator/scripts/run_fullflow_pipeline.sh \
  --brief "SaaS dashboard with strong readability and CTA" \
  --style-target "dashboard header and core cards" \
  --scope-file "src/pages/dashboard.css" \
  --framework react \
  --project-type saas-modern \
  --priority performance \
  --priority accessibility
```

2. 样式边界锁（强烈建议在样式改动前执行）

```bash
python3 skills/style-scope-guard/scripts/build_style_scope_lock.py \
  --brief "Only update hero section glass style" \
  --target "Hero section" \
  --allowed-file "src/styles/hero.css" \
  --json-out /tmp/style.scope.lock.json \
  --md-out /tmp/style.scope.checklist.md
```

3. 需求补全

```bash
python3 skills/requirements-elicitation-engine/scripts/generate_requirements_brief.py \
  --brief "Build a SaaS analytics dashboard" \
  --out-dir /tmp/req-artifacts \
  --json
```

## 6. 维护与再导出

在本仓库重新导出全部包：

```bash
python3 skills/skill-structure-governor/scripts/export_skill_bundles.py \
  --out-dir RUI-agentskills \
  --clean
```

结构校验：

```bash
python3 skills/skill-structure-governor/scripts/validate_structure.py
```
