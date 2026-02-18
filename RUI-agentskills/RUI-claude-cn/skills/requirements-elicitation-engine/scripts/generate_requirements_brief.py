#!/usr/bin/env python3
"""Generate requirement artifacts: PRD draft, follow-up questions, and style profile."""

from __future__ import annotations

import argparse
import json
import re
from dataclasses import dataclass
from pathlib import Path
from typing import Dict, List, Tuple


@dataclass(frozen=True)
class Dimension:
    key: str
    label: str
    keywords: Tuple[str, ...]
    questions: Tuple[str, ...]


DIMENSIONS: Tuple[Dimension, ...] = (
    Dimension(
        key="basic_info",
        label="项目基础信息",
        keywords=("官网", "后台", "应用", "平台", "dashboard", "landing", "管理", "电商", "看板", "仪表盘", "saas", "系统"),
        questions=(
            "项目主要目标是什么？（品牌展示/营销转化/管理效率/数据分析）",
            "目标用户是谁？（B端/C端/角色画像）",
            "核心页面有哪些？请列3-5个页面名称。",
        ),
    ),
    Dimension(
        key="tech_stack",
        label="技术栈",
        keywords=("react", "vue", "angular", "svelte", "tailwind", "typescript", "vite"),
        questions=(
            "前端框架偏好是什么？（React/Vue/Angular/Svelte/Vanilla）",
            "样式方案偏好是什么？（Tailwind/CSS Modules/SCSS）",
            "是否要求 TypeScript 严格模式？",
        ),
    ),
    Dimension(
        key="design",
        label="设计风格",
        keywords=("玻璃", "极简", "科技", "商务", "dark", "light", "brand", "风格", "可读性", "玻璃拟态"),
        questions=(
            "整体视觉风格是什么？（极简/科技/商务/玻璃拟态）",
            "是否有品牌主色、字体或设计系统约束？",
            "是否需要暗黑模式与主题切换？",
        ),
    ),
    Dimension(
        key="functionality",
        label="功能范围",
        keywords=("登录", "权限", "表单", "图表", "搜索", "筛选", "导出", "上传", "图标", "导航", "状态"),
        questions=(
            "必须实现的核心功能是什么？（按优先级列出）",
            "是否包含认证、权限、表单复杂校验等模块？",
            "是否需要数据导入导出、上传下载等能力？",
        ),
    ),
    Dimension(
        key="quality",
        label="质量与约束",
        keywords=("性能", "seo", "wcag", "无障碍", "兼容", "浏览器", "deadline", "上线", "体验", "可读性"),
        questions=(
            "性能目标是什么？（首屏/交互响应）",
            "兼容性范围是什么？（Chrome/Firefox/Safari/Edge）",
            "交付时间与里程碑怎么定义？",
        ),
    ),
    Dimension(
        key="responsive_adaptation",
        label="响应式与适配",
        keywords=("响应式", "移动端", "平板", "断点", "适配", "h5", "小程序", "桌面", "pc"),
        questions=(
            "需要支持哪些终端和分辨率？（手机/平板/桌面）",
            "是否有关键断点要求？（如 768/1024/1280）",
            "移动端是否需要简化信息架构或交互流程？",
        ),
    ),
    Dimension(
        key="content_management",
        label="内容管理",
        keywords=("cms", "内容", "多语言", "文案", "素材", "博客", "文章", "本地化"),
        questions=(
            "页面内容来源是什么？（静态配置/CMS/API）",
            "是否需要多语言或区域化能力？",
            "内容更新频率与审核流程如何定义？",
        ),
    ),
    Dimension(
        key="integration_deployment",
        label="集成与部署",
        keywords=("部署", "vercel", "netlify", "docker", "ci", "cd", "第三方", "支付", "地图", "统计", "埋点", "监控", "api", "sdk"),
        questions=(
            "需要集成哪些第三方服务？（支付/地图/统计/IM）",
            "部署环境是什么？（Vercel/Netlify/自有服务器/容器）",
            "是否需要 CI/CD、监控与告警？",
        ),
    ),
)


def normalize_text(text: str) -> str:
    return re.sub(r"\s+", " ", text).strip().lower()


def extract_project_name(text: str) -> str:
    zh_match = re.search(r"([\u4e00-\u9fffA-Za-z0-9_-]{2,20})(?:系统|平台|应用|官网|看板|项目)", text)
    if zh_match:
        return zh_match.group(1)
    return "ui-project"


def detect_framework(text: str) -> str:
    if "react" in text:
        return "react"
    if "vue" in text:
        return "vue"
    if "angular" in text:
        return "angular"
    if "svelte" in text:
        return "svelte"
    return "react"


def detect_style(text: str) -> str:
    if "玻璃" in text or "glass" in text:
        return "glassmorphism"
    if "极简" in text or "minimal" in text:
        return "minimal"
    if "商务" in text:
        return "corporate"
    if "科技" in text:
        return "tech"
    return "modern"


def dimension_hits(text: str) -> Dict[str, int]:
    hits: Dict[str, int] = {}
    for dim in DIMENSIONS:
        hits[dim.key] = sum(1 for kw in dim.keywords if kw in text)
    return hits


def build_followup_questions(hits: Dict[str, int], max_questions: int) -> List[str]:
    questions: List[str] = []
    for dim in DIMENSIONS:
        if hits[dim.key] == 0:
            questions.extend(dim.questions)
    if not questions:
        # Still keep a small clarification set for robustness.
        questions = [
            "请确认核心页面与优先级（P0/P1/P2）。",
            "请确认技术栈版本与部署环境。",
            "请确认质量门槛（性能、兼容、无障碍）。",
        ]
    return questions[:max_questions]


def summarize_coverage(hits: Dict[str, int]) -> Dict[str, object]:
    covered = [dim.label for dim in DIMENSIONS if hits.get(dim.key, 0) > 0]
    missing = [dim.label for dim in DIMENSIONS if hits.get(dim.key, 0) == 0]
    ratio = len(covered) / len(DIMENSIONS) if DIMENSIONS else 0.0
    # 与 Kimi 反问策略一致，70 分作为“基本可进入实现”的参考线
    score = int(round(ratio * 100))
    return {
        "dimension_total": len(DIMENSIONS),
        "dimension_covered": len(covered),
        "covered_dimensions": covered,
        "missing_dimensions": missing,
        "completeness_score": score,
    }


def build_prd_markdown(project_name: str, brief: str, framework: str, style: str, questions: List[str]) -> str:
    q_md = "\n".join(f"- [ ] {q}" for q in questions)
    return f"""# 项目需求规格说明书（PRD）\n\n## 基本信息\n- 项目名称: {project_name}\n- 技术栈偏好: {framework}\n- 视觉风格偏好: {style}\n\n## 1. 项目概述\n{brief}\n\n## 2. 当前已知范围\n- 需求来源为简要输入，仍需补全边界条件。\n- 本文档为草案，需在反问确认后升级为执行版。\n\n## 3. 待确认问题（高优先）\n{q_md}\n\n## 4. 输出与验收约束\n- 必须有可运行代码与变更清单。\n- 必须执行质量门禁（功能/视觉/代码/性能/安全兼容）。\n- 必须产出验收结论与后续迭代建议。\n"""


def build_style_profile_yaml(project_name: str, framework: str, style: str) -> str:
    return f"""project: {project_name}\nframework: {framework}\nstyle:\n  preferred: {style}\n  density: comfortable\ncode:\n  typescript_strict: true\n  no_any: true\n  component_split_threshold: 200\n  render_logic_threshold: 30\nquality:\n  accessibility: wcag-aa\n  browser_support:\n    - chrome\n    - firefox\n    - safari\n    - edge\n"""


def main() -> None:
    parser = argparse.ArgumentParser(description="Generate requirement elicitation artifacts")
    parser.add_argument("--brief", help="Requirement brief text")
    parser.add_argument("--brief-file", help="Path to brief text file")
    parser.add_argument("--out-dir", required=True, help="Output directory")
    parser.add_argument("--project-name", help="Optional project name override")
    parser.add_argument("--max-questions", type=int, default=5, help="Max follow-up questions")
    parser.add_argument("--json", action="store_true", help="Print result as JSON")
    args = parser.parse_args()

    brief = ""
    if args.brief_file:
        brief = Path(args.brief_file).read_text(encoding="utf-8").strip()
    elif args.brief:
        brief = args.brief.strip()

    if not brief:
        raise SystemExit("brief is required: use --brief or --brief-file")

    norm = normalize_text(brief)
    project_name = args.project_name or extract_project_name(brief)
    framework = detect_framework(norm)
    style = detect_style(norm)

    hits = dimension_hits(norm)
    questions = build_followup_questions(hits, args.max_questions)
    coverage = summarize_coverage(hits)

    out_dir = Path(args.out_dir)
    out_dir.mkdir(parents=True, exist_ok=True)

    prd_path = out_dir / "requirements.prd.md"
    questions_path = out_dir / "requirements.questions.md"
    profile_path = out_dir / "style-profile.yaml"

    prd_path.write_text(build_prd_markdown(project_name, brief, framework, style, questions), encoding="utf-8")
    questions_path.write_text("\n".join(f"- {q}" for q in questions) + "\n", encoding="utf-8")
    profile_path.write_text(build_style_profile_yaml(project_name, framework, style), encoding="utf-8")

    result = {
        "project_name": project_name,
        "framework": framework,
        "style": style,
        "dimension_hits": hits,
        "dimension_total": coverage["dimension_total"],
        "dimension_covered": coverage["dimension_covered"],
        "covered_dimensions": coverage["covered_dimensions"],
        "missing_dimensions": coverage["missing_dimensions"],
        "completeness_score": coverage["completeness_score"],
        "question_count": len(questions),
        "artifacts": {
            "requirements_prd": str(prd_path),
            "requirements_questions": str(questions_path),
            "style_profile": str(profile_path),
        },
    }

    if args.json:
        print(json.dumps(result, ensure_ascii=False, indent=2))
    else:
        print(f"project: {project_name}")
        print(f"framework: {framework}")
        print(f"style: {style}")
        print(f"questions: {len(questions)}")
        print(f"out: {out_dir}")


if __name__ == "__main__":
    main()
