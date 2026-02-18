---
title: "AI UI开发技能规范文档"
version: "1.0.0"
date: "2025-01-15"
author: "RUI Agent Team"
category: "Technical Specification"
tags: ["UI Development", "AI Agent", "Skill Definition", "Data Contract"]
status: "Published"
---

# AI UI开发技能规范文档

## 目录

1. [文档概述](#1-文档概述)
2. [UI开发生命周期（5阶段）](#2-ui开发生命周期5阶段)
3. [数据契约](#3-数据契约)
4. [术语表](#4-术语表)
5. [质量门禁标准](#5-质量门禁标准)
6. [文档引用关系](#6-文档引用关系)
7. [附录](#7-附录)

---

## 1. 文档概述

### 1.1 目的

本文档定义了AI驱动的UI开发技能的完整规范，包括：
- 标准化的UI开发流程（5阶段生命周期）
- 技能间的数据交换契约
- 核心术语定义
- 质量门禁通过标准

### 1.2 适用范围

本文档适用于：
- AI Agent UI开发技能的设计与实现
- 人机协作的UI开发工作流
- 自动化UI代码生成系统
- UI组件库的开发与维护

### 1.3 文档约定

- **必须（MUST）**：强制性要求
- **应该（SHOULD）**：推荐性要求
- **可以（MAY）**：可选性要求
- **禁止（MUST NOT）**：禁止性要求

---

## 2. UI开发生命周期（5阶段）

### Phase 1: 需求分析与设计探索

#### 2.1.1 阶段目标

- 深入理解用户需求和业务场景
- 探索多种设计方案
- 确定设计方向和约束条件
- 输出可执行的设计规范

#### 2.1.2 输入规范

```json
{
  "phase": "phase_1_requirements_analysis",
  "input": {
    "user_request": {
      "type": "string",
      "description": "用户的原始需求描述",
      "required": true
    },
    "business_context": {
      "type": "object",
      "properties": {
        "domain": "string",
        "target_users": "array",
        "business_goals": "array",
        "constraints": "object"
      },
      "required": false
    },
    "reference_materials": {
      "type": "array",
      "items": {
        "type": "object",
        "properties": {
          "type": "enum[image, url, document, design_mockup]",
          "content": "string",
          "metadata": "object"
        }
      },
      "required": false
    },
    "aesthetic_tokens": {
      "type": "array",
      "description": "预定义的审美令牌",
      "items": {
        "type": "string",
        "enum": ["modern", "minimal", "vibrant", "professional", "playful", "elegant", "dark", "light"]
      },
      "required": false
    }
  }
}
```

#### 2.1.3 关键活动

| 活动ID | 活动名称 | 描述 | 输出物 |
|--------|----------|------|--------|
| A1.1 | 需求解析 | 分析用户请求，提取功能需求和非功能需求 | 需求规格说明书 |
| A1.2 | 竞品分析 | 研究同类产品的设计方案 | 竞品分析报告 |
| A1.3 | 设计探索 | 生成多种设计方案供选择 | 设计探索文档 |
| A1.4 | 方案评审 | 评估各方案的可行性 | 方案评估矩阵 |
| A1.5 | 设计决策 | 确定最终设计方向 | 设计决策记录 |

#### 2.1.4 输出规范

```json
{
  "phase_1_output": {
    "requirements_specification": {
      "functional_requirements": "array",
      "non_functional_requirements": "array",
      "user_stories": "array",
      "acceptance_criteria": "array"
    },
    "design_exploration": {
      "explored_directions": "array",
      "selected_direction": "string",
      "rationale": "string"
    },
    "design_tokens": {
      "color_palette": "object",
      "typography": "object",
      "spacing_scale": "object",
      "shadow_system": "object"
    },
    "constraints": {
      "scope_locked": "boolean",
      "technical_constraints": "array",
      "design_constraints": "array"
    },
    "handoff_to_phase_2": {
      "ready": "boolean",
      "artifacts": "array"
    }
  }
}
```

---

### Phase 2: 架构规划与组件设计

#### 2.2.1 阶段目标

- 设计系统架构和组件层次
- 定义组件接口和数据流
- 建立设计系统规范
- 规划技术实现路径

#### 2.2.2 输入规范

```json
{
  "phase": "phase_2_architecture_planning",
  "input": {
    "phase_1_deliverables": {
      "type": "object",
      "reference": "phase_1_output",
      "required": true
    },
    "tech_stack": {
      "type": "object",
      "properties": {
        "framework": "string",
        "ui_library": "string",
        "styling_solution": "string",
        "state_management": "string"
      },
      "required": true
    },
    "component_library": {
      "type": "object",
      "properties": {
        "available_components": "array",
        "custom_components_needed": "array"
      },
      "required": false
    }
  }
}
```

#### 2.2.3 关键活动

| 活动ID | 活动名称 | 描述 | 输出物 |
|--------|----------|------|--------|
| A2.1 | 架构设计 | 设计系统整体架构 | 架构设计图 |
| A2.2 | 组件分解 | 将UI分解为可复用组件 | 组件树 |
| A2.3 | 接口定义 | 定义组件Props和Events | 接口规范 |
| A2.4 | 状态设计 | 设计状态管理方案 | 状态图 |
| A2.5 | 设计系统 | 建立设计令牌系统 | 设计系统文档 |

#### 2.2.4 输出规范

```json
{
  "phase_2_output": {
    "architecture": {
      "system_diagram": "string",
      "component_hierarchy": "object",
      "data_flow": "object",
      "state_management": "object"
    },
    "component_specifications": {
      "components": [
        {
          "name": "string",
          "type": "enum[atom, molecule, organism, template, page]",
          "props": "array",
          "events": "array",
          "slots": "array",
          "dependencies": "array",
          "implementation_notes": "string"
        }
      ]
    },
    "design_system": {
      "tokens": "object",
      "components": "object",
      "patterns": "object",
      "guidelines": "object"
    },
    "implementation_plan": {
      "phases": "array",
      "dependencies": "array",
      "estimates": "object"
    },
    "handoff_to_phase_3": {
      "ready": "boolean",
      "artifacts": "array"
    }
  }
}
```

---

### Phase 3: 代码生成与实现

#### 2.3.1 阶段目标

- 根据设计规范生成高质量代码
- 实现所有组件和功能
- 确保代码符合最佳实践
- 生成必要的文档和注释

#### 2.3.2 输入规范

```json
{
  "phase": "phase_3_code_generation",
  "input": {
    "phase_2_deliverables": {
      "type": "object",
      "reference": "phase_2_output",
      "required": true
    },
    "code_generation_config": {
      "type": "object",
      "properties": {
        "target_language": "string",
        "coding_style": "string",
        "documentation_level": "enum[minimal, standard, comprehensive]",
        "test_coverage": "enum[none, basic, full]"
      },
      "required": true
    },
    "existing_codebase": {
      "type": "object",
      "properties": {
        "project_structure": "object",
        "existing_components": "array",
        "code_patterns": "object"
      },
      "required": false
    }
  }
}
```

#### 2.3.3 关键活动

| 活动ID | 活动名称 | 描述 | 输出物 |
|--------|----------|------|--------|
| A3.1 | 项目初始化 | 创建项目结构和配置 | 项目模板 |
| A3.2 | 组件开发 | 实现所有UI组件 | 组件代码 |
| A3.3 | 样式实现 | 实现CSS/样式系统 | 样式文件 |
| A3.4 | 逻辑实现 | 实现业务逻辑和交互 | 逻辑代码 |
| A3.5 | 文档生成 | 生成组件文档 | 文档文件 |

#### 2.3.4 输出规范

```json
{
  "phase_3_output": {
    "project_structure": {
      "root_directory": "string",
      "directories": "array",
      "configuration_files": "array"
    },
    "generated_code": {
      "components": [
        {
          "file_path": "string",
          "code": "string",
          "language": "string",
          "lines_of_code": "number"
        }
      ],
      "styles": "array",
      "utilities": "array",
      "tests": "array"
    },
    "documentation": {
      "readme": "string",
      "component_docs": "array",
      "api_reference": "object",
      "usage_examples": "array"
    },
    "quality_metrics": {
      "code_complexity": "number",
      "test_coverage": "number",
      "lint_score": "number",
      "type_coverage": "number"
    },
    "handoff_to_phase_4": {
      "ready": "boolean",
      "artifacts": "array"
    }
  }
}
```

---

### Phase 4: 自我审查与重构

#### 2.4.1 阶段目标

- 全面审查生成的代码
- 识别并修复问题
- 优化性能和可维护性
- 确保符合质量标准

#### 2.4.2 输入规范

```json
{
  "phase": "phase_4_self_review",
  "input": {
    "phase_3_deliverables": {
      "type": "object",
      "reference": "phase_3_output",
      "required": true
    },
    "review_criteria": {
      "type": "object",
      "properties": {
        "code_quality_rules": "array",
        "performance_thresholds": "object",
        "accessibility_requirements": "array",
        "security_checks": "array"
      },
      "required": true
    },
    "quality_gate_level": {
      "type": "string",
      "enum": ["level_0", "level_1", "level_2"],
      "required": true
    }
  }
}
```

#### 2.4.3 关键活动

| 活动ID | 活动名称 | 描述 | 输出物 |
|--------|----------|------|--------|
| A4.1 | 静态分析 | 运行代码静态分析 | 分析报告 |
| A4.2 | 代码审查 | 人工审查代码质量 | 审查清单 |
| A4.3 | 问题识别 | 识别代码中的问题 | 问题列表 |
| A4.4 | 代码重构 | 重构有问题的代码 | 重构记录 |
| A4.5 | 质量验证 | 验证修复后的质量 | 质量报告 |

#### 2.4.4 输出规范

```json
{
  "phase_4_output": {
    "review_report": {
      "summary": {
        "total_issues": "number",
        "critical_issues": "number",
        "warning_issues": "number",
        "info_issues": "number"
      },
      "issues": [
        {
          "id": "string",
          "severity": "enum[critical, warning, info]",
          "category": "string",
          "description": "string",
          "location": "string",
          "suggestion": "string",
          "status": "enum[open, fixed, wontfix]"
        }
      ],
      "static_analysis": {
        "tool": "string",
        "results": "object",
        "score": "number"
      }
    },
    "refactoring_log": {
      "changes": [
        {
          "id": "string",
          "type": "enum[extract, inline, rename, move, reorganize]",
          "description": "string",
          "files_affected": "array",
          "before": "string",
          "after": "string"
        }
      ],
      "metrics_improvement": {
        "complexity_reduction": "number",
        "performance_gain": "number",
        "maintainability_improvement": "number"
      }
    },
    "quality_verification": {
      "passed": "boolean",
      "score": "number",
      "gate_level_achieved": "string"
    },
    "handoff_to_phase_5": {
      "ready": "boolean",
      "artifacts": "array"
    }
  }
}
```

---

### Phase 5: 验收与交付

#### 2.5.1 阶段目标

- 执行最终验收测试
- 生成交付文档
- 完成项目交接
- 收集反馈并归档

#### 2.5.2 输入规范

```json
{
  "phase": "phase_5_acceptance_delivery",
  "input": {
    "phase_4_deliverables": {
      "type": "object",
      "reference": "phase_4_output",
      "required": true
    },
    "acceptance_criteria": {
      "type": "array",
      "items": {
        "type": "object",
        "properties": {
          "id": "string",
          "description": "string",
          "verification_method": "string",
          "expected_result": "string"
        }
      },
      "required": true
    },
    "delivery_requirements": {
      "type": "object",
      "properties": {
        "documentation_required": "boolean",
        "deployment_package": "boolean",
        "training_materials": "boolean",
        "support_agreement": "boolean"
      },
      "required": true
    }
  }
}
```

#### 2.5.3 关键活动

| 活动ID | 活动名称 | 描述 | 输出物 |
|--------|----------|------|--------|
| A5.1 | 验收测试 | 执行验收测试用例 | 测试报告 |
| A5.2 | 用户验证 | 用户确认功能完整性 | 验收签字 |
| A5.3 | 文档整理 | 整理所有项目文档 | 文档包 |
| A5.4 | 交付打包 | 打包交付物 | 交付包 |
| A5.5 | 项目归档 | 归档项目资料 | 归档记录 |

#### 2.5.4 输出规范

```json
{
  "phase_5_output": {
    "acceptance_report": {
      "test_results": {
        "total_tests": "number",
        "passed": "number",
        "failed": "number",
        "skipped": "number",
        "pass_rate": "number"
      },
      "criteria_verification": [
        {
          "criterion_id": "string",
          "verified": "boolean",
          "evidence": "string",
          "verified_by": "string",
          "date": "string"
        }
      ],
      "user_sign_off": {
        "signed": "boolean",
        "signed_by": "string",
        "date": "string",
        "comments": "string"
      }
    },
    "delivery_package": {
      "source_code": {
        "location": "string",
        "checksum": "string",
        "version": "string"
      },
      "documentation": {
        "technical_docs": "array",
        "user_manuals": "array",
        "api_docs": "array"
      },
      "deployment_artifacts": {
        "build_package": "string",
        "configuration": "object",
        "deployment_guide": "string"
      }
    },
    "project_closure": {
      "completion_date": "string",
      "final_status": "enum[completed, partial, cancelled]",
      "lessons_learned": "array",
      "recommendations": "array"
    },
    "ssot_record": {
      "record_id": "string",
      "project_metadata": "object",
      "artifact_locations": "object",
      "retention_period": "string"
    }
  }
}
```

---

## 3. 数据契约

### 3.1 契约概述

数据契约定义了技能间数据交换的标准格式，确保各阶段之间的无缝衔接。

### 3.2 通用数据格式

#### 3.2.1 元数据格式

```json
{
  "metadata": {
    "contract_version": "1.0.0",
    "created_at": "2025-01-15T10:30:00Z",
    "created_by": "ai_agent",
    "session_id": "uuid-v4-string",
    "project_id": "project-identifier",
    "checksum": "sha256-hash"
  }
}
```

#### 3.2.2 错误格式

```json
{
  "error": {
    "code": "ERROR_CODE",
    "message": "Human readable error message",
    "details": {
      "field": "specific_field",
      "constraint": "violated_constraint",
      "suggestion": "how_to_fix"
    },
    "timestamp": "2025-01-15T10:30:00Z",
    "trace_id": "uuid-v4-string"
  }
}
```

### 3.3 阶段间数据契约

#### 3.3.1 Phase 1 → Phase 2 契约

```json
{
  "contract_id": "p1_to_p2",
  "source_phase": "phase_1_requirements_analysis",
  "target_phase": "phase_2_architecture_planning",
  
  "required_fields": [
    "requirements_specification",
    "design_tokens",
    "constraints.scope_locked"
  ],
  
  "data_schema": {
    "requirements_specification": {
      "type": "object",
      "properties": {
        "functional_requirements": {
          "type": "array",
          "minItems": 1,
          "items": {
            "type": "object",
            "properties": {
              "id": "string",
              "description": "string",
              "priority": "enum[high, medium, low]"
            }
          }
        },
        "non_functional_requirements": {
          "type": "array",
          "items": {
            "type": "object",
            "properties": {
              "category": "enum[performance, security, accessibility, compatibility]",
              "requirement": "string",
              "metric": "string"
            }
          }
        }
      }
    },
    "design_tokens": {
      "type": "object",
      "properties": {
        "color_palette": {
          "type": "object",
          "properties": {
            "primary": "string",
            "secondary": "string",
            "accent": "string",
            "neutral": "object",
            "semantic": "object"
          }
        },
        "typography": {
          "type": "object",
          "properties": {
            "font_family": "string",
            "scale": "object",
            "weights": "array"
          }
        }
      }
    },
    "constraints": {
      "type": "object",
      "properties": {
        "scope_locked": {
          "type": "boolean",
          "description": "If true, scope changes require formal approval"
        },
        "technical_constraints": {
          "type": "array"
        },
        "design_constraints": {
          "type": "array"
        }
      }
    }
  },
  
  "validation_rules": [
    "requirements_specification.functional_requirements must have at least 1 item",
    "design_tokens.color_palette.primary must be a valid hex color",
    "constraints.scope_locked must be explicitly set"
  ]
}
```

#### 3.3.2 Phase 2 → Phase 3 契约

```json
{
  "contract_id": "p2_to_p3",
  "source_phase": "phase_2_architecture_planning",
  "target_phase": "phase_3_code_generation",
  
  "required_fields": [
    "component_specifications",
    "design_system.tokens",
    "implementation_plan"
  ],
  
  "data_schema": {
    "component_specifications": {
      "type": "object",
      "properties": {
        "components": {
          "type": "array",
          "minItems": 1,
          "items": {
            "type": "object",
            "properties": {
              "name": {
                "type": "string",
                "pattern": "^[A-Z][a-zA-Z0-9]*$"
              },
              "type": {
                "type": "string",
                "enum": ["atom", "molecule", "organism", "template", "page"]
              },
              "props": {
                "type": "array",
                "items": {
                  "type": "object",
                  "properties": {
                    "name": "string",
                    "type": "string",
                    "required": "boolean",
                    "default": "any"
                  }
                }
              },
              "events": {
                "type": "array"
              },
              "dependencies": {
                "type": "array"
              }
            },
            "required": ["name", "type", "props"]
          }
        }
      }
    },
    "design_system": {
      "type": "object",
      "properties": {
        "tokens": "object",
        "components": "object",
        "patterns": "object"
      }
    },
    "implementation_plan": {
      "type": "object",
      "properties": {
        "phases": {
          "type": "array",
          "items": {
            "type": "object",
            "properties": {
              "order": "number",
              "name": "string",
              "components": "array",
              "estimated_hours": "number"
            }
          }
        },
        "dependencies": {
          "type": "array"
        }
      }
    }
  },
  
  "validation_rules": [
    "All component names must follow PascalCase",
    "Component types must follow atomic design hierarchy",
    "Implementation plan phases must be ordered sequentially"
  ]
}
```

#### 3.3.3 Phase 3 → Phase 4 契约

```json
{
  "contract_id": "p3_to_p4",
  "source_phase": "phase_3_code_generation",
  "target_phase": "phase_4_self_review",
  
  "required_fields": [
    "generated_code.components",
    "quality_metrics"
  ],
  
  "data_schema": {
    "generated_code": {
      "type": "object",
      "properties": {
        "components": {
          "type": "array",
          "items": {
            "type": "object",
            "properties": {
              "file_path": "string",
              "code": "string",
              "language": "string",
              "lines_of_code": "number"
            },
            "required": ["file_path", "code", "language"]
          }
        },
        "styles": "array",
        "tests": "array"
      }
    },
    "quality_metrics": {
      "type": "object",
      "properties": {
        "code_complexity": {
          "type": "number",
          "minimum": 0,
          "maximum": 100
        },
        "test_coverage": {
          "type": "number",
          "minimum": 0,
          "maximum": 100
        },
        "lint_score": {
          "type": "number",
          "minimum": 0,
          "maximum": 100
        },
        "type_coverage": {
          "type": "number",
          "minimum": 0,
          "maximum": 100
        }
      }
    }
  },
  
  "validation_rules": [
    "All file paths must be absolute or relative to project root",
    "Code must not be empty",
    "Quality metrics must be within valid ranges"
  ]
}
```

#### 3.3.4 Phase 4 → Phase 5 契约

```json
{
  "contract_id": "p4_to_p5",
  "source_phase": "phase_4_self_review",
  "target_phase": "phase_5_acceptance_delivery",
  
  "required_fields": [
    "quality_verification.passed",
    "review_report.issues"
  ],
  
  "data_schema": {
    "quality_verification": {
      "type": "object",
      "properties": {
        "passed": "boolean",
        "score": {
          "type": "number",
          "minimum": 0,
          "maximum": 100
        },
        "gate_level_achieved": {
          "type": "string",
          "enum": ["level_0", "level_1", "level_2"]
        }
      },
      "required": ["passed", "score", "gate_level_achieved"]
    },
    "review_report": {
      "type": "object",
      "properties": {
        "summary": {
          "type": "object",
          "properties": {
            "total_issues": "number",
            "critical_issues": "number",
            "warning_issues": "number",
            "info_issues": "number"
          }
        },
        "issues": {
          "type": "array",
          "items": {
            "type": "object",
            "properties": {
              "id": "string",
              "severity": "enum[critical, warning, info]",
              "status": "enum[open, fixed, wontfix]"
            }
          }
        }
      }
    },
    "refactoring_log": {
      "type": "object",
      "properties": {
        "changes": "array",
        "metrics_improvement": "object"
      }
    }
  },
  
  "validation_rules": [
    "If quality_verification.passed is false, phase 5 cannot proceed",
    "All critical issues must have status 'fixed' or 'wontfix'",
    "Quality score must meet the minimum threshold for the target gate level"
  ]
}
```

### 3.4 数据验证规则

#### 3.4.1 通用验证规则

| 规则ID | 规则名称 | 描述 | 错误代码 |
|--------|----------|------|----------|
| V1 | 必填字段检查 | 验证所有必填字段存在 | MISSING_REQUIRED_FIELD |
| V2 | 类型检查 | 验证字段类型正确 | TYPE_MISMATCH |
| V3 | 格式检查 | 验证字符串格式（如email、URL） | INVALID_FORMAT |
| V4 | 范围检查 | 验证数值在有效范围内 | OUT_OF_RANGE |
| V5 | 枚举检查 | 验证值在允许列表中 | INVALID_ENUM_VALUE |
| V6 | 引用完整性 | 验证引用数据存在 | BROKEN_REFERENCE |
| V7 | 一致性检查 | 验证相关字段逻辑一致 | INCONSISTENT_DATA |

#### 3.4.2 阶段特定验证

```json
{
  "phase_validations": {
    "phase_1": {
      "rules": [
        "user_request must not be empty",
        "at least one functional requirement must be defined",
        "design_tokens must include color_palette and typography"
      ]
    },
    "phase_2": {
      "rules": [
        "component_specifications must have at least one component",
        "all component names must be unique",
        "component dependencies must reference existing components"
      ]
    },
    "phase_3": {
      "rules": [
        "generated_code.components must match phase_2 specifications",
        "all file paths must be valid",
        "code must be syntactically valid"
      ]
    },
    "phase_4": {
      "rules": [
        "quality_verification.score must be >= gate_level minimum",
        "all critical issues must be resolved",
        "refactoring must not introduce new issues"
      ]
    },
    "phase_5": {
      "rules": [
        "acceptance_report.pass_rate must be >= 80%",
        "all acceptance criteria must be verified",
        "delivery_package must include all required artifacts"
      ]
    }
  }
}
```

---

## 4. 术语表

### 4.1 核心术语定义

| 序号 | 术语 | 英文 | 定义 | 相关概念 |
|------|------|------|------|----------|
| 1 | **单一事实来源** | SSOT (Single Source of Truth) | 项目中所有关键信息的唯一权威来源，确保数据一致性和可追溯性 | 数据治理、版本控制 |
| 2 | **审美令牌** | Aesthetic Token | 用于描述和指导视觉风格的标准化标识符，如"modern"、"minimal"等 | 设计令牌、设计系统 |
| 3 | **范围锁** | Scope Lock | 项目范围的正式冻结状态，任何变更都需要经过正式审批流程 | 变更管理、项目控制 |
| 4 | **原子设计** | Atomic Design | 将UI组件按原子、分子、有机体、模板、页面五个层次组织的系统方法论 | 组件化、设计系统 |
| 5 | **设计令牌** | Design Token | 设计系统中可复用的视觉属性（颜色、字体、间距等）的抽象表示 | 主题、变量 |
| 6 | **质量门禁** | Quality Gate | 项目各阶段必须通过的质量检查点，定义了进入下一阶段的标准 | 质量控制、CI/CD |
| 7 | **组件契约** | Component Contract | 定义组件Props、Events、Slots等接口规范的正式文档 | API设计、接口规范 |
| 8 | **数据流** | Data Flow | 应用程序中数据从源到目标的流动路径和转换过程 | 状态管理、架构 |
| 9 | **无障碍性** | Accessibility (a11y) | 确保产品可被所有用户（包括残障人士）使用的特性和实践 | WCAG、包容性设计 |
| 10 | **代码异味** | Code Smell | 代码中可能暗示更深层次问题的表面迹象 | 重构、代码质量 |
| 11 | **技术债务** | Technical Debt | 为了快速交付而采取的次优技术决策所累积的维护成本 | 重构、代码质量 |
| 12 | **验收标准** | Acceptance Criteria | 定义功能或需求完成条件的具体、可测试的条件 | 用户故事、测试 |
| 13 | **交付物** | Deliverable | 项目各阶段必须产出的有形成果或文档 | 里程碑、输出 |
| 14 | **可追溯性** | Traceability | 从需求到实现、测试的完整跟踪能力 | 需求管理、验证 |
| 15 | **设计探索** | Design Exploration | 在正式设计前进行的多种可能方案的探索和研究过程 | 设计思维、原型 |
| 16 | **静态分析** | Static Analysis | 在不执行代码的情况下分析代码结构、质量和潜在问题的技术 | 代码审查、lint |
| 17 | **重构** | Refactoring | 在不改变外部行为的前提下改善代码内部结构的过程 | 代码质量、维护 |
| 18 | **功能需求** | Functional Requirement | 描述系统应该做什么的需求 | 用户需求、规格 |
| 19 | **非功能需求** | Non-functional Requirement | 描述系统应该如何运行的需求（性能、安全等） | 质量属性、约束 |
| 20 | **设计系统** | Design System | 包含设计原则、组件库、模式库和指南的完整设计资源集合 | 组件库、风格指南 |

### 4.2 缩写词表

| 缩写 | 全称 | 中文 | 使用场景 |
|------|------|------|----------|
| SSOT | Single Source of Truth | 单一事实来源 | 数据管理、项目文档 |
| UI | User Interface | 用户界面 | 界面设计、开发 |
| UX | User Experience | 用户体验 | 设计研究、评估 |
| API | Application Programming Interface | 应用程序接口 | 组件开发、集成 |
| CSS | Cascading Style Sheets | 层叠样式表 | 样式开发 |
| HTML | HyperText Markup Language | 超文本标记语言 | 结构开发 |
| JS/TS | JavaScript/TypeScript | JavaScript/TypeScript | 逻辑开发 |
| WCAG | Web Content Accessibility Guidelines | 网页内容无障碍指南 | 无障碍性设计 |
| a11y | accessibility | 无障碍性 | 行业通用缩写 |
| i18n | internationalization | 国际化 | 多语言支持 |
| l10n | localization | 本地化 | 区域适配 |
| CI/CD | Continuous Integration/Deployment | 持续集成/部署 | 开发流程 |
| PR | Pull Request | 合并请求 | 代码审查 |
| LoC | Lines of Code | 代码行数 | 代码度量 |
| KPI | Key Performance Indicator | 关键绩效指标 | 质量评估 |

### 4.3 术语关系图

```
                    ┌─────────────────┐
                    │   设计系统      │
                    │  Design System  │
                    └────────┬────────┘
                             │
         ┌───────────────────┼───────────────────┐
         │                   │                   │
         ▼                   ▼                   ▼
┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐
│   设计令牌      │ │   组件库        │ │   模式库        │
│  Design Tokens  │ │ Component Lib   │ │ Pattern Library │
└────────┬────────┘ └────────┬────────┘ └────────┬────────┘
         │                   │                   │
         │    ┌──────────────┘                   │
         │    │                                  │
         ▼    ▼                                  ▼
┌─────────────────┐                   ┌─────────────────┐
│  审美令牌       │                   │   原子设计      │
│ Aesthetic Token │                   │  Atomic Design  │
└─────────────────┘                   └────────┬────────┘
                                               │
                    ┌──────────────────────────┼──────────┐
                    │                          │          │
                    ▼                          ▼          ▼
            ┌─────────────┐           ┌─────────────┐ ┌──────────┐
            │    原子     │           │    分子     │ │  有机体  │
            │    Atom     │           │   Molecule  │ │ Organism │
            └─────────────┘           └─────────────┘ └──────────┘
```

---

## 5. 质量门禁标准

### 5.1 门禁级别概述

质量门禁定义了项目各阶段必须满足的质量标准，分为三个级别：

| 级别 | 名称 | 适用场景 | 通过标准 |
|------|------|----------|----------|
| Level 0 | 基础级 | 原型、概念验证 | 基本功能可用，无明显错误 |
| Level 1 | 标准级 | 内部工具、MVP | 功能完整，代码规范，有基本测试 |
| Level 2 | 生产级 | 对外产品、核心系统 | 全面测试，性能优化，完整文档 |

### 5.2 Level 0 - 基础级门禁

#### 5.2.1 代码质量标准

```json
{
  "level_0": {
    "code_quality": {
      "syntax_valid": {
        "description": "代码必须无语法错误",
        "verification": "automated_linting",
        "threshold": "0_errors"
      },
      "basic_functionality": {
        "description": "基本功能必须可运行",
        "verification": "manual_smoke_test",
        "threshold": "core_features_work"
      },
      "no_console_errors": {
        "description": "运行时无控制台错误",
        "verification": "browser_console_check",
        "threshold": "0_errors"
      }
    }
  }
}
```

#### 5.2.2 检查清单

- [ ] 代码可以成功编译/构建
- [ ] 页面可以正常加载
- [ ] 核心交互功能可用
- [ ] 无明显的视觉问题
- [ ] 控制台无错误输出

### 5.3 Level 1 - 标准级门禁

#### 5.3.1 代码质量标准

```json
{
  "level_1": {
    "code_quality": {
      "lint_score": {
        "description": "代码风格检查得分",
        "verification": "eslint/stylelint",
        "threshold": ">= 80",
        "weight": 15
      },
      "type_coverage": {
        "description": "TypeScript类型覆盖率",
        "verification": "tsc --noEmit",
        "threshold": ">= 70%",
        "weight": 15
      },
      "code_complexity": {
        "description": "代码复杂度（圈复杂度）",
        "verification": "complexity_analysis",
        "threshold": "<= 15",
        "weight": 10
      },
      "duplicate_code": {
        "description": "代码重复率",
        "verification": "duplication_detection",
        "threshold": "<= 5%",
        "weight": 10
      }
    },
    "testing": {
      "test_coverage": {
        "description": "单元测试覆盖率",
        "verification": "jest/vitest",
        "threshold": ">= 50%",
        "weight": 20
      },
      "critical_path_tests": {
        "description": "关键路径测试通过",
        "verification": "automated_tests",
        "threshold": "100%",
        "weight": 15
      }
    },
    "documentation": {
      "component_docs": {
        "description": "组件文档完整",
        "verification": "doc_generation",
        "threshold": "all_public_apis",
        "weight": 10
      },
      "readme": {
        "description": "README文件存在且完整",
        "verification": "manual_review",
        "threshold": "required_sections",
        "weight": 5
      }
    }
  }
}
```

#### 5.3.2 检查清单

- [ ] 通过所有自动化代码检查（lint）
- [ ] 类型覆盖率 >= 70%
- [ ] 单元测试覆盖率 >= 50%
- [ ] 所有关键路径测试通过
- [ ] 组件文档完整
- [ ] README包含安装、使用、API说明
- [ ] 代码复杂度 <= 15
- [ ] 代码重复率 <= 5%

### 5.4 Level 2 - 生产级门禁

#### 5.4.1 代码质量标准

```json
{
  "level_2": {
    "code_quality": {
      "lint_score": {
        "description": "代码风格检查得分",
        "verification": "eslint/stylelint",
        "threshold": ">= 95",
        "weight": 10
      },
      "type_coverage": {
        "description": "TypeScript类型覆盖率",
        "verification": "tsc --noEmit",
        "threshold": ">= 90%",
        "weight": 10
      },
      "code_complexity": {
        "description": "代码复杂度（圈复杂度）",
        "verification": "complexity_analysis",
        "threshold": "<= 10",
        "weight": 10
      },
      "duplicate_code": {
        "description": "代码重复率",
        "verification": "duplication_detection",
        "threshold": "<= 3%",
        "weight": 5
      },
      "code_review": {
        "description": "代码审查通过",
        "verification": "peer_review",
        "threshold": "2_approvals",
        "weight": 10
      }
    },
    "testing": {
      "test_coverage": {
        "description": "单元测试覆盖率",
        "verification": "jest/vitest",
        "threshold": ">= 80%",
        "weight": 15
      },
      "integration_tests": {
        "description": "集成测试通过率",
        "verification": "integration_test_suite",
        "threshold": ">= 95%",
        "weight": 10
      },
      "e2e_tests": {
        "description": "端到端测试通过率",
        "verification": "cypress/playwright",
        "threshold": ">= 90%",
        "weight": 10
      },
      "visual_regression": {
        "description": "视觉回归测试通过",
        "verification": "chromatic/percy",
        "threshold": "no_unexpected_changes",
        "weight": 5
      }
    },
    "performance": {
      "lighthouse_score": {
        "description": "Lighthouse性能得分",
        "verification": "lighthouse_ci",
        "threshold": ">= 90",
        "weight": 10
      },
      "bundle_size": {
        "description": "打包体积",
        "verification": "bundle_analyzer",
        "threshold": "< budget",
        "weight": 5
      }
    },
    "accessibility": {
      "wcag_compliance": {
        "description": "WCAG 2.1 AA合规性",
        "verification": "axe/pa11y",
        "threshold": "0_violations",
        "weight": 10
      }
    },
    "security": {
      "dependency_scan": {
        "description": "依赖安全扫描",
        "verification": "snyk/dependabot",
        "threshold": "0_high_severity",
        "weight": 5
      },
      "static_security_analysis": {
        "description": "静态安全分析",
        "verification": "security_linter",
        "threshold": "0_issues",
        "weight": 5
      }
    },
    "documentation": {
      "api_documentation": {
        "description": "API文档完整",
        "verification": "typedoc/storybook",
        "threshold": "100%",
        "weight": 5
      },
      "changelog": {
        "description": "变更日志更新",
        "verification": "manual_review",
        "threshold": "all_changes_documented",
        "weight": 3
      },
      "deployment_guide": {
        "description": "部署指南完整",
        "verification": "manual_review",
        "threshold": "step_by_step_instructions",
        "weight": 2
      }
    }
  }
}
```

#### 5.4.2 检查清单

- [ ] 代码风格得分 >= 95
- [ ] 类型覆盖率 >= 90%
- [ ] 单元测试覆盖率 >= 80%
- [ ] 集成测试通过率 >= 95%
- [ ] 端到端测试通过率 >= 90%
- [ ] 代码审查获得2个以上批准
- [ ] Lighthouse性能得分 >= 90
- [ ] 打包体积符合预算
- [ ] WCAG 2.1 AA合规（0违规）
- [ ] 依赖安全扫描无高危漏洞
- [ ] 静态安全分析无问题
- [ ] API文档100%覆盖
- [ ] 变更日志已更新
- [ ] 部署指南完整

### 5.5 门禁评分算法

```javascript
/**
 * 质量门禁评分算法
 * @param {Object} metrics - 各项指标得分
 * @param {string} targetLevel - 目标门禁级别
 * @returns {Object} 评分结果
 */
function calculateQualityGateScore(metrics, targetLevel) {
  const gateConfig = {
    level_0: { minScore: 60, weights: null },
    level_1: { minScore: 75, weights: 'level_1' },
    level_2: { minScore: 90, weights: 'level_2' }
  };
  
  const config = gateConfig[targetLevel];
  
  // Level 0: 基础检查
  if (targetLevel === 'level_0') {
    const passed = metrics.syntax_valid && 
                   metrics.basic_functionality && 
                   metrics.no_console_errors;
    return {
      passed,
      score: passed ? 60 : 0,
      level: 'level_0'
    };
  }
  
  // Level 1 & 2: 加权评分
  let totalScore = 0;
  let totalWeight = 0;
  
  for (const [metric, value] of Object.entries(metrics)) {
    const weight = getWeight(targetLevel, metric);
    if (weight > 0) {
      totalScore += (value * weight);
      totalWeight += weight;
    }
  }
  
  const finalScore = totalWeight > 0 ? totalScore / totalWeight : 0;
  
  return {
    passed: finalScore >= config.minScore,
    score: Math.round(finalScore),
    level: targetLevel,
    details: metrics
  };
}
```

---

## 6. 文档引用关系

### 6.1 文档依赖图

```
┌─────────────────────────────────────────────────────────────────┐
│                    AI UI开发技能规范文档                          │
│                    (本文档 - 核心规范)                            │
└────────────────────────────┬────────────────────────────────────┘
                             │
         ┌───────────────────┼───────────────────┐
         │                   │                   │
         ▼                   ▼                   ▼
┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐
│  组件设计规范    │ │  代码生成指南    │ │  质量检查清单    │
│Component Design │ │ Code Generation │ │ Quality         │
│  Specification  │ │    Guide        │ │   Checklist     │
└────────┬────────┘ └────────┬────────┘ └────────┬────────┘
         │                   │                   │
         │    ┌──────────────┘                   │
         │    │                                  │
         ▼    ▼                                  ▼
┌─────────────────┐                   ┌─────────────────┐
│   设计令牌规范   │                   │   测试规范      │
│  Design Token   │                   │  Testing Spec   │
│   Specification │                   │                 │
└─────────────────┘                   └─────────────────┘
```

### 6.2 引用文档清单

| 文档ID | 文档名称 | 路径 | 引用章节 | 用途 |
|--------|----------|------|----------|------|
| DOC-001 | 组件设计规范 | `/docs/component-design-spec.md` | 2.2, 3.3.2 | 组件设计详细规范 |
| DOC-002 | 代码生成指南 | `/docs/code-generation-guide.md` | 2.3, 3.3.3 | 代码生成最佳实践 |
| DOC-003 | 质量检查清单 | `/docs/quality-checklist.md` | 5.2, 5.3, 5.4 | 质量门禁检查项 |
| DOC-004 | 设计令牌规范 | `/docs/design-token-spec.md` | 2.1, 4.1 | 设计令牌定义 |
| DOC-005 | 测试规范 | `/docs/testing-spec.md` | 5.3, 5.4 | 测试策略和方法 |
| DOC-006 | 无障碍性指南 | `/docs/accessibility-guide.md` | 5.4 | 无障碍性实现指南 |
| DOC-007 | 性能优化指南 | `/docs/performance-guide.md` | 5.4 | 性能优化最佳实践 |
| DOC-008 | API文档规范 | `/docs/api-documentation-spec.md` | 5.4 | API文档标准 |

### 6.3 外部引用

| 引用ID | 名称 | 类型 | URL | 用途 |
|--------|------|------|-----|------|
| EXT-001 | WCAG 2.1 | 标准 | https://www.w3.org/WAI/WCAG21/ | 无障碍性标准 |
| EXT-002 | Atomic Design | 方法论 | https://atomicdesign.bradfrost.com/ | 组件设计方法 |
| EXT-003 | Design Tokens W3C | 标准 | https://www.w3.org/community/design-tokens/ | 设计令牌标准 |
| EXT-004 | Lighthouse | 工具 | https://developers.google.com/web/tools/lighthouse | 性能测试 |

### 6.4 版本兼容性

| 本文档版本 | 兼容组件设计规范 | 兼容代码生成指南 | 兼容质量检查清单 |
|------------|------------------|------------------|------------------|
| 1.0.0 | >= 1.0.0 | >= 1.0.0 | >= 1.0.0 |

---

## 7. 附录

### 7.1 JSON Schema验证

以下Schema可用于验证各阶段输出数据：

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "$id": "https://rui-agent.ai/schemas/phase-output",
  "title": "Phase Output Schema",
  "type": "object",
  "required": ["phase", "output", "metadata"],
  "properties": {
    "phase": {
      "type": "string",
      "enum": [
        "phase_1_requirements_analysis",
        "phase_2_architecture_planning",
        "phase_3_code_generation",
        "phase_4_self_review",
        "phase_5_acceptance_delivery"
      ]
    },
    "output": {
      "type": "object"
    },
    "metadata": {
      "type": "object",
      "required": ["contract_version", "created_at", "session_id"],
      "properties": {
        "contract_version": {
          "type": "string",
          "pattern": "^\\d+\\.\\d+\\.\\d+$"
        },
        "created_at": {
          "type": "string",
          "format": "date-time"
        },
        "session_id": {
          "type": "string",
          "format": "uuid"
        }
      }
    }
  }
}
```

### 7.2 变更历史

| 版本 | 日期 | 变更内容 | 作者 |
|------|------|----------|------|
| 1.0.0 | 2025-01-15 | 初始版本发布 | RUI Agent Team |

### 7.3 反馈与贡献

如有问题或建议，请通过以下方式联系：

- **Issue Tracker**: https://github.com/rui-agent/docs/issues
- **Email**: docs@rui-agent.ai
- **Discussion Forum**: https://discuss.rui-agent.ai

---

## 文档元数据

```yaml
document_info:
  id: AI_UI_SKILL_DOC_v1.0.0
  title: AI UI开发技能规范文档
  version: 1.0.0
  status: Published
  classification: Public
  
ownership:
  author: RUI Agent Team
  maintainer: Technical Documentation Team
  reviewers:
    - Architecture Team
    - Development Team
    - QA Team
  
lifecycle:
  created: 2025-01-15
  last_modified: 2025-01-15
  next_review: 2025-04-15
  review_cycle: quarterly
  
compliance:
  standards:
    - ISO/IEC 25010
    - WCAG 2.1 AA
  certifications: []
  
relationships:
  parent: null
  children:
    - component-design-spec
    - code-generation-guide
    - quality-checklist
  related:
    - design-token-spec
    - testing-spec
```

---

*文档结束*
