# RUI-agentskills 全流程优化建议书

**版本**: 1.0  
**日期**: 2026-02-18  
**状态**: 提案阶段

---

## 目录

1. [执行摘要](#执行摘要)
2. [当前系统评估](#当前系统评估)
3. [高优先级优化](#高优先级优化)
4. [中优先级优化](#中优先级优化)
5. [低优先级优化](#低优先级优化)
6. [实施路线图](#实施路线图)
7. [附录：新增产物规范](#附录新增产物规范)

---

## 执行摘要

### 现状概述

RUI-agentskills 已建立完整的五阶段 UI 研发技能体系（19 个技能 + 14 类标准化产物），支持 Codex/Claude 双平台、中英双语分发。`ui-fullflow-orchestrator` 提供了可执行的 pipeline 脚本，实现了从需求分析到代码生成的自动化。

### 核心痛点

| 优先级 | 问题 | 影响 |
|--------|------|------|
| 🔴 高 | Pipeline 在 Phase 3 后中断 | 用户需手动接力 Phase 4/5 |
| 🔴 高 | 质量门禁与实际执行脱节 | 标准定义但无自动化验证 |
| 🔴 高 | 技能状态分散，缺少统一状态机 | 难以追踪全流程进度 |
| 🟡 中 | 样式范围锁定缺乏联动验证 | 可能误改业务逻辑 |
| 🟡 中 | 配置阈值多技能不一致 | 维护困难 |

### 预期收益

- **效率提升**: Pipeline 完成度从 60% → 100%，减少人工介入
- **质量保障**: 质量门禁自动化验证，拦截率提升
- **可维护性**: 统一配置管理，降低多技能维护成本
- **可观测性**: 全流程状态可视化，问题定位时间缩短

---

## 当前系统评估

### 架构概览

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         RUI-agentskills 全流程架构                       │
├─────────────────────────────────────────────────────────────────────────┤
│  平台分发层: RUI-codex-cn | RUI-codex-en | RUI-claude-cn | RUI-claude-en │
├─────────────────────────────────────────────────────────────────────────┤
│  五阶段生命周期                                                          │
│  Phase 1: 需求分析 → Phase 2: 架构规划 → Phase 3: 代码生成 →             │
│  Phase 4: 自我审查 → Phase 5: 验收交付                                   │
├─────────────────────────────────────────────────────────────────────────┤
│  19个技能分层                                                            │
│  ├─ 核心编排层: ui-fullflow-orchestrator, ui-codegen-master              │
│  ├─ 选型决策层: ui-selector-pro, ui-selector-playbook                    │
│  ├─ 审美策略层: ui-aesthetic-coach, ui-aesthetic-generator               │
│  ├─ 研发执行层: ui-generation-workflow-runner, style-scope-guard, etc    │
│  ├─ 架构基建层: project-scaffold-builder, ui-agent-workspace, etc        │
│  └─ 结构治理层: skill-structure-governor                                 │
├─────────────────────────────────────────────────────────────────────────┤
│  产物系统 (14+ 标准化产物)                                                │
│  flow.input.json → requirements.* → style.scope.lock.json →              │
│  selector.* → aesthetic.score.json → tokens.* → stage.status.json →      │
│  quality.gates.md → self-eval.scorecard.json → fullflow.report.md        │
└─────────────────────────────────────────────────────────────────────────┘
```

### 产物清单

| 产物 | 阶段 | 当前状态 |
|------|------|----------|
| `flow.input.json` | Input | ✅ 稳定 |
| `requirements.summary.json` | Phase 1 | ✅ 稳定 |
| `style.scope.lock.json` | Phase 1 | ⚠️ 可选，需强化 |
| `selector.recommend.json` | Phase 2 | ✅ 稳定 |
| `selector.evaluate.json` | Phase 2 | ✅ 稳定 |
| `aesthetic.score.json` | Phase 2 | ✅ 稳定 |
| `tokens.json` / `tokens.css` | Phase 3 | ✅ 稳定 |
| `stage.status.json` | All | ⚠️ Phase 4/5 为 pending |
| `quality.gates.md` | All | ⚠️ 定义完整但执行弱 |
| `self-eval.scorecard.json` | Phase 4/5 | ⚠️ 需手动执行 |
| `fullflow.report.md` | Output | ✅ 稳定 |

---

## 高优先级优化

### 1. Pipeline 五阶段完整自动化

**现状问题**: `run_fullflow_pipeline.sh` 执行完 Phase 3（代码生成）后，Phase 4（重构）和 Phase 5（验收）标记为 `pending`，需用户手动触发后续技能。

**优化方案**:

#### 1.1 增强 Pipeline 脚本

```bash
# run_fullflow_pipeline.sh 新增参数
bash skills/ui-fullflow-orchestrator/scripts/run_fullflow_pipeline.sh \
  --brief "SaaS数据看板" \
  --framework react \
  --project-type saas-modern \
  --auto-complete \           # 新增: 自动完成全部五阶段
  --refactor-threshold 200 \  # 新增: 重构触发阈值
  --acceptance-level strict   # 新增: 验收严格度 (strict/normal/loose)
```

#### 1.2 新增子阶段执行脚本

```bash
# scripts/run_phase4_refactor.sh
# 自动检测重构触发条件并执行
# - 单文件 > 200 行 → 触发组件抽离
# - 渲染逻辑 > 30 行 → 提取子组件
# - 相同模式 >= 3 → 提取复用逻辑
# - Props 穿透 > 3 层 → 使用 Context/Composition

# scripts/run_phase5_acceptance.sh
# 自动化验收检查
# - 代码规范检查 (eslint, prettier, tsc)
# - 可访问性扫描 (axe-core)
# - 性能预算检查 (lighthouse CI)
# - 生成验收报告
```

#### 1.3 修改产物生成逻辑

```python
# run_fullflow_pipeline.sh 中的 Python 片段修改
stage_status = [
  {"phase": "phase1_requirements", "name": "需求分析与设计探索", "status": "completed", ...},
  {"phase": "phase2_architecture", "name": "架构规划与组件设计", "status": "completed", ...},
  {"phase": "phase3_implementation", "name": "代码生成与实现", "status": "completed", ...},
  # 从 pending 改为动态执行
  {"phase": "phase4_self_review", "name": "自我审查与重构", 
   "status": "completed" if auto_complete else "pending", ...},
  {"phase": "phase5_acceptance", "name": "验收与交付", 
   "status": "completed" if auto_complete else "pending", ...},
]
```

**预期收益**: 一键完成全流程，减少 3-5 轮人工交互

---

### 2. 统一技能状态管理

**现状问题**: 各技能状态分散在多个 JSON 文件中，缺乏统一状态机和可视化能力。

**优化方案**:

#### 2.1 新增 `flow.state.json`

```json
{
  "workflow_id": "rui-flow-20260218-001",
  "version": "1.0.0",
  "started_at": "2026-02-18T10:00:00Z",
  "current_phase": "phase3_implementation",
  
  "skills_status": {
    "requirements-elicitation-engine": {
      "status": "completed",
      "output": ["requirements.summary.json", "requirements.prd.md"],
      "checkpoint": "2026-02-18T10:05:00Z",
      "duration_ms": 3500
    },
    "style-scope-guard": {
      "status": "completed",
      "output": ["style.scope.lock.json"],
      "checkpoint": "2026-02-18T10:06:00Z",
      "duration_ms": 800
    },
    "ui-selector-pro": {
      "status": "completed",
      "output": ["selector.recommend.json", "selector.evaluate.json"],
      "checkpoint": "2026-02-18T10:08:00Z",
      "duration_ms": 2500
    },
    "ui-aesthetic-coach": {
      "status": "completed",
      "output": ["aesthetic.score.json", "tokens.json", "tokens.css"],
      "checkpoint": "2026-02-18T10:12:00Z",
      "duration_ms": 4200
    },
    "ui-codegen-master": {
      "status": "in_progress",
      "assigned_agent": "claude",
      "started_at": "2026-02-18T10:15:00Z",
      "progress_percent": 65
    }
  },
  
  "blockers": [],
  "warnings": [
    "ui-aesthetic-coach: 设计评分 3.5/5 未达门槛 4.0"
  ],
  
  "next_actions": [
    "ui-generation-workflow-runner: 执行四步生成法",
    "frontend-standards-enforcer: 代码规范检查"
  ],
  
  "artifacts_manifest": {
    "total": 14,
    "completed": 10,
    "pending": 4
  }
}
```

#### 2.2 状态机转换规则

```yaml
# state-machine-rules.yaml
states:
  - pending
  - in_progress
  - completed
  - failed
  - skipped

transitions:
  pending -> in_progress: skill_started
  in_progress -> completed: skill_finished
  in_progress -> failed: skill_error
  pending -> skipped: dependency_failed

constraints:
  phase2_can_start: phase1_all_completed
  phase3_can_start: phase2_all_completed
  phase4_can_start: phase3_all_completed
  phase5_can_start: phase4_all_completed
```

#### 2.3 CLI 状态查询

```bash
# 新增状态查询命令
bash skills/ui-fullflow-orchestrator/scripts/flow_status.sh \
  --workflow-id rui-flow-20260218-001 \
  --format table  # table/json/markdown

# 输出示例
# Skill                          Status       Duration   Output
# -----------------------------  -----------  ---------  ------------------------
# requirements-elicitation-engine  ✅ completed  3.5s       requirements.summary.json
# style-scope-guard              ✅ completed  0.8s       style.scope.lock.json
# ui-selector-pro                ✅ completed  2.5s       selector.recommend.json
# ui-aesthetic-coach             ✅ completed  4.2s       tokens.json, tokens.css
# ui-codegen-master              ⏳ in_progress  -          -
```

**预期收益**: 全流程进度可视，问题快速定位

---

### 3. 质量门禁自动化验证

**现状问题**: `quality-gates.md` 定义了详细门禁标准，但脚本中仅做简单检查（如 `completeness_score >= 70`），缺少自动化验证机制。

**优化方案**:

#### 3.1 新增 `quality-gate-validator` 技能

```yaml
# skills/quality-gate-validator/SKILL.md
name: quality-gate-validator
description: 自动化验证 quality-gates.md 中定义的所有门禁标准
---

验证项:
  - 需求完备度 >= 70
  - 审美评分 >= 4.0/5.0
  - 组件复用率 >= 40%
  - 圈复杂度 <= 10
  - TS 类型覆盖 >= 90%
  - 色彩对比度 >= 4.5:1 (WCAG AA)
```

#### 3.2 实现验证脚本

```python
# skills/quality-gate-validator/scripts/validate_gates.py

import json
import subprocess
from pathlib import Path
from dataclasses import dataclass
from typing import List, Dict, Optional

@dataclass
class GateResult:
    gate_name: str
    threshold: any
    actual_value: any
    passed: bool
    evidence: str

class QualityGateValidator:
    def __init__(self, workspace_root: str):
        self.workspace = Path(workspace_root)
        self.results: List[GateResult] = []
    
    def validate_requirement_completeness(self) -> GateResult:
        """验证需求完备度 >= 70"""
        req_file = self.workspace / "requirements.summary.json"
        with open(req_file) as f:
            data = json.load(f)
        score = data.get("completeness_score", 0)
        return GateResult(
            gate_name="requirement_completeness",
            threshold=70,
            actual_value=score,
            passed=score >= 70,
            evidence=f"missing_dimensions: {data.get('missing_dimensions', [])}"
        )
    
    def validate_design_score(self) -> GateResult:
        """验证审美评分 >= 4.0/5.0"""
        score_file = self.workspace / "aesthetic.score.json"
        with open(score_file) as f:
            data = json.load(f)
        raw_score = data.get("total_score", 0)
        score_5 = round((raw_score / 35.0) * 5.0, 2)
        return GateResult(
            gate_name="design_score",
            threshold=4.0,
            actual_value=score_5,
            passed=score_5 >= 4.0,
            evidence=f"top_issues: {[i['label'] for i in data.get('top_issues', [])]}"
        )
    
    def validate_type_coverage(self) -> GateResult:
        """验证 TS 类型覆盖 >= 90%"""
        # 调用 tsc --noEmit 和类型覆盖率工具
        result = subprocess.run(
            ["npx", "typescript-coverage-report", "--threshold", "90"],
            capture_output=True,
            text=True,
            cwd=self.workspace
        )
        # 解析输出获取实际覆盖率
        coverage = self._parse_coverage(result.stdout)
        return GateResult(
            gate_name="ts_type_coverage",
            threshold=90,
            actual_value=coverage,
            passed=coverage >= 90,
            evidence="See coverage report"
        )
    
    def validate_component_reuse_rate(self) -> GateResult:
        """验证组件复用率 >= 40%"""
        # 分析代码统计组件复用情况
        stats = self._analyze_component_usage()
        reuse_rate = stats["reuse_rate"]
        return GateResult(
            gate_name="component_reuse_rate",
            threshold=40,
            actual_value=reuse_rate,
            passed=reuse_rate >= 40,
            evidence=f"unique_components: {stats['unique']}, total_usage: {stats['total']}"
        )
    
    def validate_cyclomatic_complexity(self) -> GateResult:
        """验证圈复杂度 <= 10"""
        # 使用 complexity-report 或 eslint-plugin-complexity
        result = subprocess.run(
            ["npx", "eslint", "--rule", "complexity:[error,10]", "src/"],
            capture_output=True,
            cwd=self.workspace
        )
        max_complexity = self._parse_complexity(result.stdout)
        return GateResult(
            gate_name="cyclomatic_complexity",
            threshold=10,
            actual_value=max_complexity,
            passed=max_complexity <= 10,
            evidence=f"max_complexity: {max_complexity}"
        )
    
    def validate_color_contrast(self) -> GateResult:
        """验证 WCAG AA 色彩对比度 >= 4.5:1"""
        # 使用 axe-core 或 @axe-core/cli
        result = subprocess.run(
            ["npx", "axe", "--tags", "wcag2aa", "dist/"],
            capture_output=True,
            cwd=self.workspace
        )
        violations = self._parse_axe_violations(result.stdout)
        contrast_violations = [v for v in violations if v["id"] == "color-contrast"]
        return GateResult(
            gate_name="color_contrast_wcag_aa",
            threshold="4.5:1",
            actual_value=f"{len(contrast_violations)} violations",
            passed=len(contrast_violations) == 0,
            evidence=f"violations: {contrast_violations}"
        )
    
    def run_all_validations(self) -> Dict:
        """运行所有门禁验证"""
        validators = [
            self.validate_requirement_completeness,
            self.validate_design_score,
            self.validate_type_coverage,
            self.validate_component_reuse_rate,
            self.validate_cyclomatic_complexity,
            self.validate_color_contrast,
        ]
        
        self.results = [v() for v in validators]
        
        passed = sum(1 for r in self.results if r.passed)
        failed = len(self.results) - passed
        
        return {
            "summary": {
                "total_gates": len(self.results),
                "passed": passed,
                "failed": failed,
                "pass_rate": f"{passed/len(self.results)*100:.1f}%",
                "overall_passed": failed == 0
            },
            "details": [
                {
                    "gate": r.gate_name,
                    "threshold": r.threshold,
                    "actual": r.actual_value,
                    "status": "✅ PASS" if r.passed else "❌ FAIL",
                    "evidence": r.evidence
                }
                for r in self.results
            ]
        }
```

#### 3.3 门禁报告格式

```json
{
  "validation_id": "gate-val-20260218-001",
  "timestamp": "2026-02-18T11:00:00Z",
  "summary": {
    "total_gates": 6,
    "passed": 4,
    "failed": 2,
    "pass_rate": "66.7%",
    "overall_passed": false
  },
  "details": [
    {"gate": "requirement_completeness", "threshold": 70, "actual": 85, "status": "✅ PASS"},
    {"gate": "design_score", "threshold": 4.0, "actual": 3.5, "status": "❌ FAIL", "evidence": "色彩层次不足"},
    {"gate": "ts_type_coverage", "threshold": 90, "actual": 94, "status": "✅ PASS"},
    {"gate": "component_reuse_rate", "threshold": 40, "actual": 35, "status": "❌ FAIL", "evidence": "Button组件重复定义3次"},
    {"gate": "cyclomatic_complexity", "threshold": 10, "actual": 8, "status": "✅ PASS"},
    {"gate": "color_contrast_wcag_aa", "threshold": "4.5:1", "actual": "0 violations", "status": "✅ PASS"}
  ],
  "recommendations": [
    "优化色彩层次提升设计评分",
    "提取重复Button组件到共享库"
  ]
}
```

**预期收益**: 质量门禁从"文档定义"变为"自动执行"

---

## 中优先级优化

### 4. 样式范围锁定联动验证

**现状问题**: `style-scope-guard` 生成 `style.scope.lock.json`，但缺少与代码修改的实际联动验证。

**优化方案**:

#### 4.1 增强锁文件格式

```json
{
  "scope_locked": true,
  "version": "2.0.0",
  "style_target": "dashboard header",
  "style_target_description": "仪表盘顶部导航区域样式",
  
  "allowed_files": [
    "src/pages/dashboard/DashboardHeader.css",
    "src/pages/dashboard/DashboardHeader.tsx"
  ],
  
  "forbidden_patterns": [
    {"pattern": "*.service.ts", "reason": "禁止修改服务层"},
    {"pattern": "*.{spec,test}.ts", "reason": "禁止修改测试文件"},
    {"pattern": "src/routes/*", "reason": "禁止修改路由配置"},
    {"pattern": "src/store/*", "reason": "禁止修改状态管理"},
    {"pattern": "src/api/*", "reason": "禁止修改API层"}
  ],
  
  "allowed_css_properties": [
    "color", "background", "font-size", "padding", "margin",
    "border", "border-radius", "box-shadow", "display", "flex"
  ],
  
  "forbidden_css_properties": [
    {"property": "position", "reason": "可能影响布局结构"},
    {"property": "z-index", "reason": "可能破坏层级关系"},
    {"property": "transform", "reason": "可能影响动画性能"}
  ],
  
  "validation_hooks": {
    "pre_commit": "check_style_boundary",
    "post_change": "verify_no_logic_change",
    "ci_pipeline": "validate_scope_lock"
  },
  
  "audit_log": [
    {"action": "scope_locked", "timestamp": "2026-02-18T10:00:00Z", "by": "style-scope-guard"}
  ]
}
```

#### 4.2 新增验证脚本

```python
# skills/style-scope-guard/scripts/validate_scope_change.py

import json
import re
from pathlib import Path
from typing import List, Dict, Tuple

class ScopeChangeValidator:
    def __init__(self, lock_file: str, changed_files: List[str]):
        with open(lock_file) as f:
            self.lock = json.load(f)
        self.changed_files = changed_files
        self.violations = []
    
    def validate(self) -> Dict:
        """执行全部范围验证"""
        checks = [
            self._check_file_boundary(),
            self._check_code_patterns(),
            self._check_css_properties(),
            self._check_logic_changes()
        ]
        
        all_passed = all(c["passed"] for c in checks)
        
        return {
            "scope_lock_valid": all_passed,
            "lock_version": self.lock.get("version", "1.0"),
            "checks": checks,
            "violations": self.violations,
            "recommendation": "无" if all_passed else "请修正上述违规项或更新 scope lock"
        }
    
    def _check_file_boundary(self) -> Dict:
        """验证文件边界"""
        allowed = set(self.lock.get("allowed_files", []))
        violations = []
        
        for f in self.changed_files:
            # 检查是否在允许列表中
            if f not in allowed:
                # 检查是否匹配禁止模式
                for pattern in self.lock.get("forbidden_patterns", []):
                    if re.match(pattern["pattern"].replace("*", ".*"), f):
                        violations.append({
                            "file": f,
                            "reason": pattern["reason"]
                        })
        
        self.violations.extend(violations)
        return {
            "name": "file_boundary",
            "passed": len(violations) == 0,
            "violations": violations
        }
    
    def _check_logic_changes(self) -> Dict:
        """检测业务逻辑变更（简化版）"""
        # 使用 AST 解析检查是否修改了函数体、API调用等
        # 这里简化示意
        logic_indicators = [
            r"function\s+\w+\s*\(",
            r"const\s+\w+\s*=\s*useEffect",
            r"fetch\s*\(",
            r"axios\.",
            r"dispatch\s*\("
        ]
        
        violations = []
        for f in self.changed_files:
            if f.endswith(('.ts', '.tsx', '.js', '.jsx')):
                content = Path(f).read_text()
                for indicator in logic_indicators:
                    if re.search(indicator, content):
                        violations.append({
                            "file": f,
                            "indicator": indicator,
                            "reason": "检测到可能的业务逻辑变更"
                        })
        
        self.violations.extend(violations)
        return {
            "name": "logic_change_detection",
            "passed": len(violations) == 0,
            "violations": violations[:5]  # 最多显示5个
        }
```

#### 4.3 Git Hook 集成

```bash
# .git/hooks/pre-commit
#!/bin/bash
# 自动验证样式范围锁定

LOCK_FILE="Ruiagents/*/style.scope.lock.json"
if [ -f "$LOCK_FILE" ]; then
    CHANGED_FILES=$(git diff --cached --name-only)
    
    python3 skills/style-scope-guard/scripts/validate_scope_change.py \
        --lock-file "$LOCK_FILE" \
        --changed-files "$CHANGED_FILES"
    
    if [ $? -ne 0 ]; then
        echo "❌ 样式范围验证失败，请检查改动"
        exit 1
    fi
fi

exit 0
```

**预期收益**: 防止样式任务误改业务逻辑

---

### 5. 统一配置管理

**现状问题**: 配置阈值多技能不一致（如重构触发阈值在 `ui-self-reviewer` 是 200 行，在 `ui-codegen-master` 是 300 行）。

**优化方案**:

#### 5.1 新增 `.rui-config.yaml`

```yaml
# .rui-config.yaml
# RUI-agentskills 统一配置

version: "1.0.0"
last_updated: "2026-02-18"

# 重构触发阈值
refactor_thresholds:
  file_lines: 200
  render_logic_lines: 30
  pattern_repeat: 3
  prop_drill_depth: 3
  jsx_nesting_depth: 5

# 质量门禁阈值
quality_gates:
  requirement_completeness_min: 70
  design_score_min_5: 4.0
  component_reuse_rate_min: 40
  cyclomatic_complexity_max: 10
  ts_type_coverage_min: 90
  color_contrast_min: "4.5:1"

# 设计令牌默认配置
design_tokens:
  default_direction: "Data Clarity"
  default_density: "comfortable"
  default_icon_style: "outline"
  
  # 响应式断点
  breakpoints:
    mobile: "< 768px"
    tablet: "768px - 1024px"
    desktop: "> 1024px"
  
  # 间距系统
  spacing_scale: [4, 8, 12, 16, 20, 24, 32, 40, 48, 64]
  
  # 圆角系统
  radius_scale: [0, 2, 4, 6, 8, 12, 16, 24]

# Pipeline 执行配置
pipeline:
  default_framework: "react"
  default_project_type: "saas-modern"
  auto_complete: false
  acceptance_level: "strict"  # strict / normal / loose
  
  # 阶段超时（秒）
  timeouts:
    phase1: 300
    phase2: 600
    phase3: 1200
    phase4: 600
    phase5: 300

# 产物输出配置
artifacts:
  output_dir: "Ruiagents"
  keep_history: true
  max_history_count: 10
  
  # 产物压缩
  compression:
    enabled: true
    exclude: ["*.md", "*.json"]  # 这些文件不压缩

# 日志与调试
logging:
  level: "info"  # debug / info / warn / error
  save_intermediate: true
  profiling: false
```

#### 5.2 配置加载工具

```python
# skills/skill-structure-governor/scripts/config_loader.py

import yaml
from pathlib import Path
from typing import Dict, Any, Optional
from dataclasses import dataclass

@dataclass
class RuiConfig:
    refactor_thresholds: Dict[str, int]
    quality_gates: Dict[str, Any]
    design_tokens: Dict[str, Any]
    pipeline: Dict[str, Any]
    artifacts: Dict[str, Any]
    logging: Dict[str, str]
    
    @classmethod
    def load(cls, workspace_root: str = ".") -> "RuiConfig":
        """加载配置，支持层级覆盖"""
        # 1. 加载内置默认配置
        default_config = cls._load_default()
        
        # 2. 加载项目级配置
        project_config_path = Path(workspace_root) / ".rui-config.yaml"
        if project_config_path.exists():
            with open(project_config_path) as f:
                project_config = yaml.safe_load(f)
            default_config = cls._merge(default_config, project_config)
        
        # 3. 加载用户级配置（可选）
        user_config_path = Path.home() / ".rui-config.yaml"
        if user_config_path.exists():
            with open(user_config_path) as f:
                user_config = yaml.safe_load(f)
            default_config = cls._merge(default_config, user_config)
        
        return cls(**default_config)
    
    @staticmethod
    def _merge(base: Dict, override: Dict) -> Dict:
        """深度合并配置"""
        result = base.copy()
        for key, value in override.items():
            if key in result and isinstance(result[key], dict) and isinstance(value, dict):
                result[key] = RuiConfig._merge(result[key], value)
            else:
                result[key] = value
        return result
    
    def get_refactor_threshold(self, name: str) -> int:
        return self.refactor_thresholds.get(name, 200)
    
    def get_quality_gate(self, name: str) -> Any:
        return self.quality_gates.get(name)
```

#### 5.3 配置热更新

```python
# 各技能使用统一配置
from skills.skill_structure_governor.scripts.config_loader import RuiConfig

config = RuiConfig.load(workspace_root)

# 使用统一阈值
if file_lines > config.get_refactor_threshold("file_lines"):
    trigger_refactor()
```

**预期收益**: 配置一处修改，全技能同步

---

### 6. 图标系统智能触发

**现状问题**: 仅通过关键词匹配（icon/svg/canvas/图标）判断是否触发图标生成，容易误判或漏判。

**优化方案**:

```python
# skills/svg-canvas-icon-engine/scripts/detect_icon_need.py

import re
from typing import Dict, List, Set
from dataclasses import dataclass

@dataclass
class IconNeedAnalysis:
    needed: bool
    confidence: float  # 0-1
    categories: List[str]
    estimated_count: int
    style_preference: str
    rationale: str
    keywords_found: List[str]

class IconNeedDetector:
    """智能图标需求检测器"""
    
    # 语义模式而非简单关键词
    ICON_PATTERNS = {
        "navigation": {
            "patterns": [r"导航", r"菜单", r"sidebar", r"breadcrumb", r"tab", r"nav"],
            "typical_count": 5,
            "weight": 0.9
        },
        "action": {
            "patterns": [r"按钮", r"操作", r"提交", r"删除", r"编辑", r"添加"],
            "typical_count": 8,
            "weight": 0.7
        },
        "status": {
            "patterns": [r"状态", r"成功", r"失败", r"警告", r"loading", r"spinner"],
            "typical_count": 6,
            "weight": 0.8
        },
        "data_visualization": {
            "patterns": [r"图表", r"统计", r"dashboard", r"analytics", r"graph", r"chart"],
            "typical_count": 10,
            "weight": 1.0
        },
        "file_type": {
            "patterns": [r"文件", r"文档", r"上传", r"下载", r"PDF", r"Excel"],
            "typical_count": 8,
            "weight": 0.6
        },
        "brand": {
            "patterns": [r"logo", r"品牌", r"标识", r"favicon"],
            "typical_count": 3,
            "weight": 0.9
        }
    }
    
    STYLE_PATTERNS = {
        "outline": [r"简洁", r"现代", r"现代", r"minimal", r"clean", r"outline"],
        "filled": [r"饱满", r"solid", r"填充", r"醒目"],
        "two-tone": [r"双色", r"渐变", r"多彩", r"colorful", r"two-tone"]
    }
    
    def analyze(self, brief: str, requirements: Dict = None) -> IconNeedAnalysis:
        brief_lower = brief.lower()
        
        # 1. 分类检测
        detected_categories = []
        total_weight = 0
        keywords_found = []
        
        for category, config in self.ICON_PATTERNS.items():
            for pattern in config["patterns"]:
                if re.search(pattern, brief_lower, re.IGNORECASE):
                    detected_categories.append({
                        "name": category,
                        "weight": config["weight"],
                        "typical": config["typical_count"]
                    })
                    keywords_found.append(pattern)
                    total_weight += config["weight"]
                    break
        
        # 2. 计算置信度
        if not detected_categories:
            confidence = 0.1  # 基础概率
        else:
            # 基于类别数量和权重计算
            confidence = min(0.95, 0.3 + total_weight * 0.2)
        
        # 3. 估算数量
        if detected_categories:
            estimated_count = sum(c["typical"] for c in detected_categories) // len(detected_categories)
        else:
            estimated_count = 0
        
        # 4. 风格偏好
        style_pref = self._detect_style(brief_lower)
        
        # 5. 生成理由
        rationale = self._generate_rationale(detected_categories, brief)
        
        return IconNeedAnalysis(
            needed=confidence > 0.5 or len(detected_categories) > 0,
            confidence=round(confidence, 2),
            categories=[c["name"] for c in detected_categories],
            estimated_count=estimated_count,
            style_preference=style_pref,
            rationale=rationale,
            keywords_found=list(set(keywords_found))[:5]
        )
    
    def _detect_style(self, brief: str) -> str:
        style_scores = {}
        for style, patterns in self.STYLE_PATTERNS.items():
            score = sum(1 for p in patterns if re.search(p, brief, re.IGNORECASE))
            if score > 0:
                style_scores[style] = score
        
        if not style_scores:
            return "outline"  # 默认
        return max(style_scores, key=style_scores.get)
    
    def _generate_rationale(self, categories: List[Dict], brief: str) -> str:
        if not categories:
            return "未检测到明确的图标需求"
        
        cat_names = [c["name"] for c in categories]
        return f"检测到{len(categories)}类图标需求: {', '.join(cat_names)}"
```

**预期收益**: 减少误判，提高图标需求检测准确率

---

## 低优先级优化

### 7. 产物版本控制

**优化方案**:

```
Ruiagents/
├── 20260218-100000/              # 当前产物
│   ├── flow.input.json
│   ├── requirements.summary.json
│   └── ...
├── 20260218-100000/.versions/     # 新增: 版本历史
│   ├── v1-initial/
│   │   └── requirements.summary.json
│   ├── v2-after-feedback/
│   │   └── requirements.summary.json
│   └── v3-final/
│       └── requirements.summary.json
├── 20260218-100000/CHANGELOG.md   # 新增: 变更日志
└── current -> 20260218-100000/    # 新增: 软链接
```

---

### 8. 执行性能监控

**优化方案**:

```json
{
  "workflow_id": "rui-flow-20260218-001",
  "metrics": {
    "pipeline_execution": {
      "total_duration_ms": 12500,
      "breakdown": {
        "requirements-elicitation": 800,
        "style-scope-guard": 300,
        "ui-selector-pro": 1500,
        "ui-aesthetic-coach": 2000,
        "ui-generation-workflow-runner": 5000,
        "frontend-standards-enforcer": 1200,
        "ui-acceptance-auditor": 700
      }
    },
    "resource_usage": {
      "peak_memory_mb": 256,
      "temp_files_count": 12,
      "disk_io_mb": 45
    },
    "external_calls": {
      "api_requests": 3,
      "npm_install_time_ms": 2000
    }
  }
}
```

---

### 9. 可插拔技能系统

**优化方案**:

```yaml
# skills/plugins/my-custom-skill/plugin.yaml
name: my-custom-skill
version: "1.0.0"
description: "自定义技能示例"

hooks:
  - phase: phase3_implementation
    before: ui-generation-workflow-runner
    action: run_custom_preprocessor.sh
    
  - phase: phase4_self_review
    after: ui-self-reviewer
    action: run_custom_linter.sh

dependencies:
  - ui-generation-workflow-runner
  
artifacts:
  - custom-report.json
```

---

### 10. 多框架适配器

**优化方案**:

```
skills/
├── framework-adapters/
│   ├── react-adapter/
│   │   ├── templates/
│   │   ├── hooks/
│   │   └── SKILL.md
│   ├── vue-adapter/
│   │   ├── templates/
│   │   ├── composables/
│   │   └── SKILL.md
│   ├── angular-adapter/
│   │   ├── templates/
│   │   ├── services/
│   │   └── SKILL.md
│   └── svelte-adapter/
│       ├── templates/
│       ├── stores/
│       └── SKILL.md
```

---

## 实施路线图

### 阶段 1: 核心完善 (4-6周)

| 周次 | 任务 | 产出 | 负责人 |
|------|------|------|--------|
| 1-2 | 完成 Pipeline Phase 4/5 自动化 | `run_phase4_refactor.sh`, `run_phase5_acceptance.sh` | 核心开发 |
| 2-3 | 实现统一状态管理 | `flow.state.json`, `flow_status.sh` | 核心开发 |
| 3-4 | 开发质量门禁验证器 | `quality-gate-validator` 技能 | 核心开发 |
| 4-5 | 集成测试 | 自动化测试套件 | QA |
| 5-6 | 文档更新 | 更新所有 SKILL.md | 文档 |

**里程碑**: Pipeline 可一键完成全部五阶段

### 阶段 2: 体验提升 (4-6周)

| 周次 | 任务 | 产出 |
|------|------|------|
| 1-2 | 增强样式范围锁定 | `validate_scope_change.py`, Git Hook |
| 2-3 | 统一配置管理 | `.rui-config.yaml`, `config_loader.py` |
| 3-4 | 优化图标触发 | `detect_icon_need.py` |
| 4-5 | 性能监控 | `flow.metrics.json` |
| 5-6 | 版本控制 | `.versions/` 目录结构 |

**里程碑**: 全流程可配置、可验证、可追溯

### 阶段 3: 生态扩展 (6-8周)

| 周次 | 任务 | 产出 |
|------|------|------|
| 1-3 | Vue 适配器 | `vue-adapter/` |
| 3-5 | Angular 适配器 | `angular-adapter/` |
| 5-6 | 插件系统 | `plugin.yaml` 规范 |
| 6-8 | 集成测试 | 多框架测试套件 |

**里程碑**: 支持 React/Vue/Angular 三框架

---

## 附录：新增产物规范

### A.1 `flow.state.json` 规范

```json
{
  "$schema": "https://rui-agentskills.dev/schemas/flow-state.json",
  "version": "1.0.0",
  
  "workflow_id": {
    "type": "string",
    "pattern": "^rui-flow-\d{8}-\d{3}$"
  },
  
  "current_phase": {
    "enum": ["phase1_requirements", "phase2_architecture", 
             "phase3_implementation", "phase4_self_review", "phase5_acceptance"]
  },
  
  "skills_status": {
    "type": "object",
    "patternProperties": {
      "^[a-z-]+$": {
        "type": "object",
        "properties": {
          "status": {"enum": ["pending", "in_progress", "completed", "failed", "skipped"]},
          "output": {"type": "array", "items": {"type": "string"}},
          "checkpoint": {"type": "string", "format": "date-time"},
          "duration_ms": {"type": "integer"}
        },
        "required": ["status"]
      }
    }
  }
}
```

### A.2 `.rui-config.yaml` 规范

```yaml
# 见第5节完整配置
```

### A.3 `gate-validation-report.json` 规范

```json
{
  "$schema": "https://rui-agentskills.dev/schemas/gate-validation.json",
  "validation_id": "string",
  "timestamp": "string (ISO8601)",
  "summary": {
    "total_gates": "integer",
    "passed": "integer",
    "failed": "integer",
    "pass_rate": "string (percentage)",
    "overall_passed": "boolean"
  },
  "details": [
    {
      "gate": "string",
      "threshold": "any",
      "actual": "any",
      "status": "string (PASS/FAIL)",
      "evidence": "string"
    }
  ],
  "recommendations": ["string"]
}
```

---

## 附录：变更影响评估

| 优化项 | 新增文件 | 修改文件 | 破坏性变更 | 向后兼容 |
|--------|----------|----------|------------|----------|
| Pipeline 自动化 | 2 个脚本 | `run_fullflow_pipeline.sh` | 否 | ✅ |
| 统一状态管理 | `flow.state.json` | 编排器 | 否 | ✅ |
| 质量门禁验证 | 新技能 | `quality.gates.md` | 否 | ✅ |
| 样式锁定验证 | `validate_scope_change.py` | `style.scope.lock.json` | 格式扩展 | ⚠️ |
| 统一配置 | `.rui-config.yaml` | 所有技能 | 否 | ✅ |
| 图标智能检测 | `detect_icon_need.py` | 图标触发逻辑 | 否 | ✅ |

---

## 附录：参考实现

详见各优化方案中的代码示例，完整实现将在阶段实施时提供。

---

**文档结束**

如有任何问题或需要进一步细化某个优化项，请随时提出。
