#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../../.." && pwd)"

usage() {
  cat <<'USAGE'
run_fullflow_pipeline.sh

Usage:
  bash skills/ui-fullflow-orchestrator/scripts/run_fullflow_pipeline.sh \
    --brief "SaaSdatadashboard enenenenenenenCTA" \
    --framework react \
    --project-type saas-modern \
    --priority performance \
    --priority accessibility \
    --density comfortable

Options:
  --brief <text>
  --brief-file <path>
  --framework <id>
  --project-type <id>
  --style-target <text>
  --scope-file <path>          (enenen enenenenenenen)
  --icon-mode <auto|on|off>
  --icon-style <outline|filled|two-tone>
  --priority <id>             (enenen enenenenenenen)
  --design-style <id>
  --team-size <id>
  --density <id>
  --brand-color <#RRGGBB>
  --top <n>
  --out-dir <dir>
  --direction <name>
USAGE
}

BRIEF=""
BRIEF_FILE=""
FRAMEWORK=""
PROJECT_TYPE=""
STYLE_TARGET=""
SCOPE_FILES_CSV=""
PRIORITY_CSV=""
ICON_MODE="auto"
ICON_STYLE="outline"
DESIGN_STYLE=""
TEAM_SIZE=""
DENSITY="comfortable"
BRAND_COLOR=""
TOP="5"
OUT_DIR=""
DIRECTION=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --brief) BRIEF="$2"; shift 2 ;;
    --brief-file) BRIEF_FILE="$2"; shift 2 ;;
    --framework) FRAMEWORK="$2"; shift 2 ;;
    --project-type) PROJECT_TYPE="$2"; shift 2 ;;
    --style-target) STYLE_TARGET="$2"; shift 2 ;;
    --scope-file)
      if [[ -z "$SCOPE_FILES_CSV" ]]; then
        SCOPE_FILES_CSV="$2"
      else
        SCOPE_FILES_CSV="$SCOPE_FILES_CSV,$2"
      fi
      shift 2
      ;;
    --icon-mode) ICON_MODE="$2"; shift 2 ;;
    --icon-style) ICON_STYLE="$2"; shift 2 ;;
    --priority)
      if [[ -z "$PRIORITY_CSV" ]]; then
        PRIORITY_CSV="$2"
      else
        PRIORITY_CSV="$PRIORITY_CSV,$2"
      fi
      shift 2
      ;;
    --design-style) DESIGN_STYLE="$2"; shift 2 ;;
    --team-size) TEAM_SIZE="$2"; shift 2 ;;
    --density) DENSITY="$2"; shift 2 ;;
    --brand-color) BRAND_COLOR="$2"; shift 2 ;;
    --top) TOP="$2"; shift 2 ;;
    --out-dir) OUT_DIR="$2"; shift 2 ;;
    --direction) DIRECTION="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown arg: $1"; usage; exit 1 ;;
  esac
done

if [[ -n "$BRIEF_FILE" ]]; then
  BRIEF="$(cat "$BRIEF_FILE")"
fi

if [[ -z "$BRIEF" || -z "$FRAMEWORK" || -z "$PROJECT_TYPE" ]]; then
  echo "Error: enenenenenen --brief/--brief-file, --framework, --project-type " >&2
  usage
  exit 1
fi

if [[ "$ICON_MODE" != "auto" && "$ICON_MODE" != "on" && "$ICON_MODE" != "off" ]]; then
  echo "Error: --icon-mode enenen auto|on|off" >&2
  exit 1
fi

if [[ -z "$OUT_DIR" ]]; then
  OUT_DIR="$REPO_ROOT/.fullflow-output/$(date +%Y%m%d-%H%M%S)"
fi
mkdir -p "$OUT_DIR"

FLOW_INPUT_PATH="$OUT_DIR/flow.input.json"
REQ_SUMMARY_PATH="$OUT_DIR/requirements.summary.json"
REQ_PRD_PATH="$OUT_DIR/requirements.prd.md"
REQ_QUESTIONS_PATH="$OUT_DIR/requirements.questions.md"
STYLE_PROFILE_PATH="$OUT_DIR/style-profile.yaml"
STYLE_SCOPE_LOCK_PATH="$OUT_DIR/style.scope.lock.json"
STYLE_SCOPE_CHECKLIST_PATH="$OUT_DIR/style.scope.checklist.md"
ICON_MANIFEST_PATH="$OUT_DIR/icon.manifest.json"
ICON_SPEC_PATH="$OUT_DIR/icon.spec.md"
ICON_SPRITE_PATH="$OUT_DIR/icon.sprite.svg"
ICON_CANVAS_DEMO_PATH="$OUT_DIR/canvas.icon.demo.js"
RECOMMEND_PATH="$OUT_DIR/selector.recommend.json"
EVALUATE_PATH="$OUT_DIR/selector.evaluate.json"
SCORE_PATH="$OUT_DIR/aesthetic.score.json"
TOKENS_JSON_PATH="$OUT_DIR/tokens.json"
TOKENS_CSS_PATH="$OUT_DIR/tokens.css"
SCORECARD_PATH="$OUT_DIR/self-eval.scorecard.json"
OPTIMIZATION_PLAN_PATH="$OUT_DIR/optimization.plan.md"
REPORT_PATH="$OUT_DIR/fullflow.report.md"
STAGE_STATUS_PATH="$OUT_DIR/stage.status.json"
QUALITY_GATES_PATH="$OUT_DIR/quality.gates.md"
DECISION_TRACE_PATH="$OUT_DIR/decision.trace.md"

export BRIEF FRAMEWORK PROJECT_TYPE STYLE_TARGET SCOPE_FILES_CSV PRIORITY_CSV ICON_MODE ICON_STYLE DESIGN_STYLE TEAM_SIZE DENSITY FLOW_INPUT_PATH
python3 - <<'PY'
import json, os
priorities = [x.strip() for x in os.environ.get("PRIORITY_CSV", "").split(",") if x.strip()]
scope_files = [x.strip() for x in os.environ.get("SCOPE_FILES_CSV", "").split(",") if x.strip()]
payload = {
  "brief": os.environ["BRIEF"],
  "style_target": os.environ.get("STYLE_TARGET") or None,
  "scope_files": scope_files,
  "icon_mode": os.environ.get("ICON_MODE", "auto"),
  "icon_style": os.environ.get("ICON_STYLE", "outline"),
  "framework": os.environ["FRAMEWORK"],
  "project_type": os.environ["PROJECT_TYPE"],
  "priorities": priorities,
  "design_style": os.environ.get("DESIGN_STYLE") or None,
  "team_size": os.environ.get("TEAM_SIZE") or None,
  "density": os.environ["DENSITY"],
}
with open(os.environ["FLOW_INPUT_PATH"], "w", encoding="utf-8") as f:
  json.dump(payload, f, ensure_ascii=False, indent=2)
  f.write("\n")
PY

(
  cd "$REPO_ROOT"
  python3 skills/requirements-elicitation-engine/scripts/generate_requirements_brief.py \
    --brief "$BRIEF" \
    --out-dir "$OUT_DIR" \
    --json
) > "$REQ_SUMMARY_PATH"

SCOPE_CMD=(
  python3 skills/style-scope-guard/scripts/build_style_scope_lock.py
  --brief "$BRIEF"
  --json-out "$STYLE_SCOPE_LOCK_PATH"
  --md-out "$STYLE_SCOPE_CHECKLIST_PATH"
)
if [[ -n "$STYLE_TARGET" ]]; then
  SCOPE_CMD+=(--target "$STYLE_TARGET")
fi
IFS=',' read -r -a SCOPE_FILES_ITEMS <<< "$SCOPE_FILES_CSV"
for item in "${SCOPE_FILES_ITEMS[@]}"; do
  trimmed="${item// /}"
  if [[ -n "$trimmed" ]]; then
    SCOPE_CMD+=(--allowed-file "$trimmed")
  fi
done

(
  cd "$REPO_ROOT"
  "${SCOPE_CMD[@]}" >/dev/null
)

export STYLE_SCOPE_LOCK_PATH
SCOPE_LOCKED="$(python3 - <<'PY'
import json, os
with open(os.environ["STYLE_SCOPE_LOCK_PATH"], "r", encoding="utf-8") as f:
  data = json.load(f)
print("1" if data.get("scope_locked") else "0")
PY
)"

if [[ "$SCOPE_LOCKED" != "1" ]]; then
  echo "Error: styleenenenenunlocked enenen --style-target enenenenenen --scope-file " >&2
  exit 1
fi

ICON_ENABLED="0"
if [[ "$ICON_MODE" == "on" ]]; then
  ICON_ENABLED="1"
elif [[ "$ICON_MODE" == "auto" ]]; then
  export BRIEF
  ICON_ENABLED="$(python3 - <<'PY'
import os
text = (os.environ.get("BRIEF", "") or "").lower()
keywords = ("icon", "icon", "svg", "canvas", "enen", "logo", "enenen")
print("1" if any(k in text for k in keywords) else "0")
PY
)"
fi

if [[ "$ICON_ENABLED" == "1" ]]; then
  (
    cd "$REPO_ROOT"
    python3 skills/svg-canvas-icon-engine/scripts/generate_icon_assets.py \
      --brief "$BRIEF" \
      --framework "$FRAMEWORK" \
      --out-dir "$OUT_DIR" \
      --mode auto \
      --style "$ICON_STYLE" \
      --json >/dev/null
  )
fi

REC_CMD=(node skills/ui-selector-pro/scripts/ui_library_engine.mjs recommend --framework "$FRAMEWORK" --project-type "$PROJECT_TYPE" --top "$TOP" --format json)
IFS=',' read -r -a PRIORITY_ITEMS <<< "$PRIORITY_CSV"
for item in "${PRIORITY_ITEMS[@]}"; do
  trimmed="${item// /}"
  if [[ -n "$trimmed" ]]; then
    REC_CMD+=(--priority "$trimmed")
  fi
done
if [[ -n "$DESIGN_STYLE" ]]; then
  REC_CMD+=(--design-style "$DESIGN_STYLE")
fi
if [[ -n "$TEAM_SIZE" ]]; then
  REC_CMD+=(--team-size "$TEAM_SIZE")
fi

(
  cd "$REPO_ROOT"
  "${REC_CMD[@]}"
) > "$RECOMMEND_PATH"

export RECOMMEND_PATH
TOP_IDS="$(python3 - <<'PY'
import json, os
with open(os.environ["RECOMMEND_PATH"], "r", encoding="utf-8") as f:
  data = json.load(f)
ids = [x.get("library", {}).get("id", "") for x in data.get("results", [])[:3]]
ids = [x for x in ids if x]
print(",".join(ids))
PY
)"

if [[ -z "$TOP_IDS" ]]; then
  echo "Error: enenenenenen enenenen" >&2
  exit 1
fi

(
  cd "$REPO_ROOT"
  node skills/ui-selector-pro/scripts/ui_library_engine.mjs evaluate --libraries "$TOP_IDS" --format json
) > "$EVALUATE_PATH"

(
  cd "$REPO_ROOT"
  python3 skills/ui-aesthetic-coach/scripts/score_ui_brief.py --text "$BRIEF" --json
) > "$SCORE_PATH"

if [[ -z "$DIRECTION" ]]; then
  export SCORE_PATH
  DIRECTION="$(python3 - <<'PY'
import json, os
with open(os.environ["SCORE_PATH"], "r", encoding="utf-8") as f:
  data = json.load(f)
print(data.get("recommended_direction", {}).get("name", "Data Clarity"))
PY
)"
fi

TOKEN_CMD=(python3 skills/ui-aesthetic-coach/scripts/generate_design_tokens.py --density "$DENSITY" --format both --json-out "$TOKENS_JSON_PATH" --css-out "$TOKENS_CSS_PATH")
if [[ -n "$DIRECTION" ]]; then
  TOKEN_CMD+=(--direction "$DIRECTION")
else
  TOKEN_CMD+=(--from-score-json "$SCORE_PATH")
fi
if [[ -n "$BRAND_COLOR" ]]; then
  TOKEN_CMD+=(--brand-color "$BRAND_COLOR")
fi

(
  cd "$REPO_ROOT"
  "${TOKEN_CMD[@]}" >/dev/null
)

WORKSPACE_BASELINE="enenenen app/info.md"
if [[ -f "$REPO_ROOT/app/info.md" ]]; then
  WORKSPACE_BASELINE="$(head -n 1 "$REPO_ROOT/app/info.md")"
fi

export FLOW_INPUT_PATH REQ_SUMMARY_PATH REQ_PRD_PATH REQ_QUESTIONS_PATH STYLE_PROFILE_PATH STYLE_SCOPE_LOCK_PATH STYLE_SCOPE_CHECKLIST_PATH ICON_MANIFEST_PATH ICON_SPEC_PATH ICON_SPRITE_PATH ICON_CANVAS_DEMO_PATH ICON_ENABLED RECOMMEND_PATH EVALUATE_PATH SCORE_PATH TOKENS_JSON_PATH TOKENS_CSS_PATH SCORECARD_PATH OPTIMIZATION_PLAN_PATH REPORT_PATH STAGE_STATUS_PATH QUALITY_GATES_PATH DECISION_TRACE_PATH WORKSPACE_BASELINE DIRECTION
python3 - <<'PY'
import json, os

with open(os.environ["FLOW_INPUT_PATH"], "r", encoding="utf-8") as f:
  flow = json.load(f)
with open(os.environ["REQ_SUMMARY_PATH"], "r", encoding="utf-8") as f:
  req = json.load(f)
with open(os.environ["STYLE_SCOPE_LOCK_PATH"], "r", encoding="utf-8") as f:
  scope = json.load(f)
icon_enabled = os.environ.get("ICON_ENABLED", "0") == "1"
icon_manifest = {}
if icon_enabled and os.path.exists(os.environ["ICON_MANIFEST_PATH"]):
  with open(os.environ["ICON_MANIFEST_PATH"], "r", encoding="utf-8") as f:
    icon_manifest = json.load(f)
with open(os.environ["RECOMMEND_PATH"], "r", encoding="utf-8") as f:
  rec = json.load(f)
with open(os.environ["EVALUATE_PATH"], "r", encoding="utf-8") as f:
  eva = json.load(f)
with open(os.environ["SCORE_PATH"], "r", encoding="utf-8") as f:
  score = json.load(f)

results = rec.get("results", [])
top = results[:3]
issues = score.get("top_issues", [])
req_completeness = int(req.get("completeness_score", 0) or 0)
design_score_raw = float(score.get("total_score", 0) or 0)
design_score_5 = round((design_score_raw / 35.0) * 5.0, 2)
style_scope_locked = bool(scope.get("scope_locked"))
icon_artifacts_ready = (
  icon_enabled
  and os.path.exists(os.environ["ICON_MANIFEST_PATH"])
  and os.path.exists(os.environ["ICON_SPEC_PATH"])
  and os.path.exists(os.environ["ICON_SPRITE_PATH"])
)
next_skills = [
  "ui-generation-workflow-runner",
  "ui-component-extractor",
  "frontend-standards-enforcer",
  "ui-acceptance-auditor",
  "ui-self-reviewer",
]
if icon_enabled:
  next_skills.insert(0, "svg-canvas-icon-engine")
if req_completeness < 70:
  next_skills.insert(0, "requirements-elicitation-engine")

stage_status = [
  {
    "phase": "phase1_requirements",
    "name": "enenenenenenenenen",
    "status": "completed_with_risk" if req_completeness < 70 else "completed",
    "evidence": f"requirements.prd.md + style.scope.lock.json + completeness={req_completeness}/100",
  },
  {
    "phase": "phase2_architecture",
    "name": "enenenenenenenenen",
    "status": "completed_with_risk" if (icon_enabled and not icon_artifacts_ready) else "completed",
    "evidence": "selector.recommend.json + icon.manifest.json" if icon_enabled else "selector.recommend.json",
  },
  {"phase": "phase3_implementation", "name": "enengenerateenenen", "status": "completed", "evidence": "tokens.json/tokens.css"},
  {"phase": "phase4_self_review", "name": "enenenenenenen", "status": "pending", "evidence": "enexecute ui-self-reviewer"},
  {"phase": "phase5_acceptance", "name": "acceptanceenenen", "status": "pending", "evidence": "enexecute ui-acceptance-auditor"},
]

score_value = int(score.get("total_score", 0))
quality_lines = []
quality_lines.append("# Quality Gates Checklist")
quality_lines.append("")
quality_lines.append("## enenenenen")
quality_lines.append(f"- brief_score: {score_value}/35")
quality_lines.append(f"- recommended_direction: {os.environ.get('DIRECTION', '')}")
quality_lines.append(f"- style_target: {scope.get('style_target') or 'N/A'}")
quality_lines.append(f"- requirement_completeness: {req.get('completeness_score', 'N/A')}/100")
quality_lines.append(f"- design_score_5: {design_score_5}/5")
quality_lines.append(f"- icon_enabled: {icon_enabled}")
quality_lines.append("")
quality_lines.append("## enenenen mimoskillsenen ")
quality_lines.append(f"- [ ] enenenenen >= 70 enen {req_completeness} ")
quality_lines.append(f"- [ ] aestheticenen >= 4.0/5.0 enen {design_score_5} ")
quality_lines.append("- [ ] enenenenen >= 40% enenenenen ")
quality_lines.append("- [ ] enenenen <= 10 enenenenen ")
quality_lines.append("- [ ] TS enenenen >= 90% enenenenen ")
quality_lines.append("")
if req_completeness < 70:
  quality_lines.append("## enenenenenenen")
  quality_lines.append("- [ ] enenenenen 70 enenenenen requirements.questions.md")
  quality_lines.append("")
quality_lines.append("## styleenenenen")
quality_lines.append("- [ ] enconfirm style.scope.lock.json en scope_locked=true")
quality_lines.append("- [ ] enenen style_target enenenen")
quality_lines.append("- [ ] enenen allowed_files enenenenen enenenen ")
quality_lines.append("- [ ] enenenenenenen/API/enen/enenstructure")
quality_lines.append("")
quality_lines.append("## enenacceptance")
quality_lines.append("- [ ] enenenenenenenen")
quality_lines.append("- [ ] enen/enenenenenen")
quality_lines.append("")
quality_lines.append("## visualacceptance")
quality_lines.append("- [ ] visualenenenenenenenenen")
quality_lines.append("- [ ] enenenenenen WCAG AA")
quality_lines.append("- [ ] enenenenenen hover/focus/disabled/loading/error ")
quality_lines.append("")
if icon_enabled:
  quality_lines.append("## iconacceptance")
  quality_lines.append("- [ ] icon.manifest.json en icon.spec.md engenerate")
  quality_lines.append("- [ ] iconenenenenenen 16/20/24 ")
  quality_lines.append("- [ ] iconenenenen icon-<category>-<name>")
  quality_lines.append("")
quality_lines.append("## enenacceptance")
quality_lines.append("- [ ] en any enen")
quality_lines.append("- [ ] enenenenenenenenenenenenen")
quality_lines.append("- [ ] enenenenenenenen")
quality_lines.append("")
quality_lines.append("## enenacceptance")
quality_lines.append("- [ ] enenenenenenenenenenenenen")
quality_lines.append("- [ ] enenen/enenenenenenenenen")
quality_lines.append("")
quality_lines.append("## enenenenenacceptance")
quality_lines.append("- [ ] enenenenenenenenenenenenen")
quality_lines.append("- [ ] Chrome/Firefox/Safari/Edge enenenenen")
quality_lines.append("")
quality_lines.append("## enenenen")
quality_lines.append("- enenen 30%")
quality_lines.append("- enen 25%")
quality_lines.append("- enenenen 25%")
quality_lines.append("- enen 20%")

with open(os.environ["STAGE_STATUS_PATH"], "w", encoding="utf-8") as f:
  json.dump(stage_status, f, ensure_ascii=False, indent=2)
  f.write("\n")

with open(os.environ["QUALITY_GATES_PATH"], "w", encoding="utf-8") as f:
  f.write("\n".join(quality_lines) + "\n")

scorecard = {
  "thresholds": {
    "requirement_completeness_min": 70,
    "design_score_min_5": 4.0,
    "component_reuse_rate_min": 40,
    "cyclomatic_complexity_max": 10,
    "ts_type_coverage_min": 90,
  },
  "metrics": {
    "requirement_completeness": req_completeness,
    "design_score_5": design_score_5,
    "style_scope_locked": style_scope_locked,
    "icon_enabled": icon_enabled,
    "icon_artifacts_ready": icon_artifacts_ready if icon_enabled else None,
    "component_reuse_rate": None,
    "cyclomatic_complexity": None,
    "ts_type_coverage": None,
  },
  "gates": {
    "requirements_gate": req_completeness >= 70,
    "design_gate": design_score_5 >= 4.0,
    "style_scope_gate": style_scope_locked,
    "icon_gate": (icon_artifacts_ready if icon_enabled else True),
    "code_quality_gate": None,
  },
}
scorecard["readiness"] = {
  "ready_for_generation": bool(
    scorecard["gates"]["requirements_gate"]
    and scorecard["gates"]["style_scope_gate"]
    and scorecard["gates"]["icon_gate"]
  ),
  "ready_for_delivery": False,
}
with open(os.environ["SCORECARD_PATH"], "w", encoding="utf-8") as f:
  json.dump(scorecard, f, ensure_ascii=False, indent=2)
  f.write("\n")

plan_lines = []
plan_lines.append("# Optimization Plan")
plan_lines.append("")
plan_lines.append("## Priority Actions")
actions = []
if req_completeness < 70:
  missing_dims = req.get("missing_dimensions", []) or []
  missing_text = " ".join(missing_dims) if missing_dims else "enenenen"
  actions.append(f"[High] enenenenenen enen {req_completeness}/100 : {missing_text} ")
if design_score_5 < 4.0:
  actions.append(f"[High] enenenaestheticenen enen {design_score_5}/5  enenenen aesthetic.top_issues ")
if icon_enabled and not icon_artifacts_ready:
  actions.append("[High] enengenerateiconenen manifest/spec/sprite enenenenenenenenenen ")
if not style_scope_locked:
  actions.append("[High] enlockedstyleenenenen enenenenen ")
if not actions:
  actions.append("[Medium] enenenenenenenenenen enenenexecutegenerateenenenenen ")
for idx, action in enumerate(actions, start=1):
  plan_lines.append(f"{idx}. {action}")
plan_lines.append("")
plan_lines.append("## Execution Chain")
for idx, name in enumerate(next_skills, start=1):
  plan_lines.append(f"{idx}. {name}")
plan_lines.append("")
with open(os.environ["OPTIMIZATION_PLAN_PATH"], "w", encoding="utf-8") as f:
  f.write("\n".join(plan_lines) + "\n")

trace_lines = []
trace_lines.append("# Decision Trace")
trace_lines.append("")
trace_lines.append("## 1. enenenen")
trace_lines.append(f"- brief: {flow.get('brief', '')}")
trace_lines.append(f"- framework: {flow.get('framework', '')}")
trace_lines.append(f"- project_type: {flow.get('project_type', '')}")
trace_lines.append(f"- priorities: {', '.join(flow.get('priorities', [])) or 'none'}")
trace_lines.append(f"- requirement_completeness: {req.get('completeness_score', 'N/A')}/100")
trace_lines.append(f"- design_score_5: {design_score_5}/5")
trace_lines.append("")
trace_lines.append("## 2. enenenen enenenen ")
trace_lines.append("1. requirements-elicitation-engine: generate PRD enen enconfirmenenenstyleenen")
trace_lines.append("2. style-scope-guard: lockedstyleenenenenenenenenenenen")
step_idx = 3
if icon_enabled:
  trace_lines.append(f"{step_idx}. svg-canvas-icon-engine: generateiconenen enenenenenen sprite")
  step_idx += 1
trace_lines.append(f"{step_idx}. ui-selector-pro: enenenenenenenenenenenenenenenen")
step_idx += 1
trace_lines.append(f"{step_idx}. ui-selector-pro evaluate: en Top 3 enenenenenenen")
step_idx += 1
trace_lines.append(f"{step_idx}. ui-aesthetic-coach: brief aestheticenenenenenenen")
step_idx += 1
trace_lines.append(f"{step_idx}. ui-aesthetic-coach tokens: generateenenen design tokens")
trace_lines.append("")
trace_lines.append("## 3. enenenen")
top_lib = top[0].get("library", {}).get("name", "N/A") if top else "N/A"
trace_lines.append(f"- styleenenenen: {scope.get('style_target') or 'N/A'} enen style.scope.lock.json ")
if icon_enabled:
  trace_lines.append(f"- iconenen: {icon_manifest.get('engine', 'svg')} / {icon_manifest.get('style', 'outline')} enen icon.manifest.json ")
trace_lines.append(f"- enenenen: {top_lib} enenenenenenenenenen ")
trace_lines.append(f"- styleenen: {os.environ.get('DIRECTION', '')} enenaestheticenenenenenen ")
trace_lines.append("")
trace_lines.append("## 4. enenenenconfirm")
trace_lines.append(f"- enconfirmenenenen: {req.get('question_count', 0)} en requirements.questions.md ")
if req_completeness < 70:
  trace_lines.append(f"- enenenenenenen: {req_completeness}/100 enenenenenenenenen ")
if design_score_5 < 4.0:
  trace_lines.append(f"- aestheticenenenenenen: {design_score_5}/5 enenenenenvisualenen ")
trace_allowed_files = scope.get("allowed_files") or []
if trace_allowed_files:
  trace_lines.append(f"- styleenenenen: {', '.join(trace_allowed_files)}")
else:
  trace_lines.append("- styleenenenen: enenen enenenen ")
trace_lines.append("- enenenenenacceptanceenenenenexecute enenenenenen pending")
trace_lines.append(f"- generateenenenen: {'ready' if scorecard['readiness']['ready_for_generation'] else 'not-ready'} en self-eval.scorecard.json ")
trace_lines.append("")
trace_lines.append("## 5. enenen")
for idx, name in enumerate(next_skills, start=1):
  trace_lines.append(f"{idx}. {name}")

with open(os.environ["DECISION_TRACE_PATH"], "w", encoding="utf-8") as f:
  f.write("\n".join(trace_lines) + "\n")

lines = []
lines.append("# Fullflow Pipeline Report")
lines.append("")
lines.append("## 0. enenenen")
lines.append(f"- brief: {flow.get('brief', '')}")
lines.append(f"- framework: {flow.get('framework', '')}")
lines.append(f"- project_type: {flow.get('project_type', '')}")
lines.append(f"- style_target: {flow.get('style_target') or 'none'}")
lines.append(f"- scope_files: {', '.join(flow.get('scope_files', [])) or 'none'}")
lines.append(f"- icon_mode: {flow.get('icon_mode') or 'auto'}")
lines.append(f"- icon_style: {flow.get('icon_style') or 'outline'}")
lines.append(f"- priorities: {', '.join(flow.get('priorities', [])) or 'none'}")
lines.append(f"- design_style: {flow.get('design_style') or 'none'}")
lines.append(f"- team_size: {flow.get('team_size') or 'none'}")
lines.append(f"- density: {flow.get('density', '')}")
lines.append(f"- workspace_baseline: {os.environ.get('WORKSPACE_BASELINE', 'N/A')}")
lines.append(f"- requirement_questions: {req.get('question_count', 0)}")
lines.append(f"- requirement_completeness: {req.get('completeness_score', 'N/A')}/100")
lines.append(f"- design_score_5: {design_score_5}/5")
lines.append("")

lines.append("## 1. styleenenenen style-scope-guard ")
lines.append(f"- scope_locked: {scope.get('scope_locked')}")
lines.append(f"- style_target: {scope.get('style_target') or 'N/A'}")
allowed_files = scope.get("allowed_files") or []
lines.append(f"- allowed_files: {', '.join(allowed_files) if allowed_files else 'none'}")
lines.append("")

if icon_enabled:
  lines.append("## 2. iconenen svg-canvas-icon-engine ")
  lines.append(f"- engine: {icon_manifest.get('engine', 'svg')}")
  lines.append(f"- style: {icon_manifest.get('style', 'outline')}")
  lines.append(f"- categories: {', '.join(icon_manifest.get('categories', [])) or 'none'}")
  lines.append(f"- icon_count: {icon_manifest.get('icon_count', 0)}")
  lines.append("")

section_idx = 3 if icon_enabled else 2
lines.append(f"## {section_idx}. enenenen ui-selector-pro ")
for item in top:
  lib = item.get("library", {})
  lines.append(f"- {lib.get('name', 'N/A')}: {item.get('score', 0):.1f} en ({' / '.join(item.get('reasons', []))})")
lines.append("")

section_idx += 1
lines.append(f"## {section_idx}. enenenen ui-selector-pro evaluate ")
for idx, row in enumerate(eva.get("result", []), start=1):
  lines.append(f"{idx}. {row.get('library', {}).get('name', 'N/A')}: {row.get('totalScore', 0):.1f}/100")
lines.append("")

section_idx += 1
lines.append(f"## {section_idx}. aestheticenen ui-aesthetic-coach ")
lines.append(f"- total_score: {score.get('total_score', 0)}")
lines.append(f"- band: {score.get('band', '')}")
lines.append(f"- recommended_direction: {os.environ.get('DIRECTION', '')}")
lines.append("- top_issues:")
for issue in issues:
  lines.append(f"  - {issue.get('label', '')}: {issue.get('improve', '')}")
lines.append("")

section_idx += 1
lines.append(f"## {section_idx}. enenenendashboard")
lines.append(f"- requirements_gate(>=70): {scorecard['gates']['requirements_gate']}")
lines.append(f"- design_gate(>=4.0/5): {scorecard['gates']['design_gate']}")
lines.append(f"- style_scope_gate: {scorecard['gates']['style_scope_gate']}")
lines.append(f"- icon_gate: {scorecard['gates']['icon_gate']}")
lines.append(f"- ready_for_generation: {scorecard['readiness']['ready_for_generation']}")
lines.append("")

section_idx += 1
lines.append(f"## {section_idx}. enenenenenenen")
lines.append(f"- requirements_prd: {os.path.basename(os.environ['REQ_PRD_PATH'])}")
lines.append(f"- requirements_questions: {os.path.basename(os.environ['REQ_QUESTIONS_PATH'])}")
lines.append(f"- style_profile: {os.path.basename(os.environ['STYLE_PROFILE_PATH'])}")
lines.append(f"- style_scope_lock: {os.path.basename(os.environ['STYLE_SCOPE_LOCK_PATH'])}")
lines.append(f"- style_scope_checklist: {os.path.basename(os.environ['STYLE_SCOPE_CHECKLIST_PATH'])}")
if icon_enabled:
  lines.append(f"- icon_manifest: {os.path.basename(os.environ['ICON_MANIFEST_PATH'])}")
  lines.append(f"- icon_spec: {os.path.basename(os.environ['ICON_SPEC_PATH'])}")
  lines.append(f"- icon_sprite: {os.path.basename(os.environ['ICON_SPRITE_PATH'])}")
  lines.append(f"- canvas_icon_demo: {os.path.basename(os.environ['ICON_CANVAS_DEMO_PATH'])}")
lines.append(f"- tokens_json: {os.path.basename(os.environ['TOKENS_JSON_PATH'])}")
lines.append(f"- tokens_css: {os.path.basename(os.environ['TOKENS_CSS_PATH'])}")
lines.append(f"- stage_status: {os.path.basename(os.environ['STAGE_STATUS_PATH'])}")
lines.append(f"- quality_gates: {os.path.basename(os.environ['QUALITY_GATES_PATH'])}")
lines.append(f"- self_eval_scorecard: {os.path.basename(os.environ['SCORECARD_PATH'])}")
lines.append(f"- optimization_plan: {os.path.basename(os.environ['OPTIMIZATION_PLAN_PATH'])}")
lines.append(f"- decision_trace: {os.path.basename(os.environ['DECISION_TRACE_PATH'])}")
lines.append("")

section_idx += 1
lines.append(f"## {section_idx}. enenenenenen")
for row in stage_status:
  lines.append(f"- {row['name']}: {row['status']} ({row['evidence']})")
lines.append("")

section_idx += 1
lines.append(f"## {section_idx}. enenenexecuteenen")
for idx, name in enumerate(next_skills, start=1):
  lines.append(f"{idx}. {name}")
lines.append("")

section_idx += 1
lines.append(f"## {section_idx}. FlowOutput")
lines.append("```json")
lines.append(json.dumps({
  "recommended_library": top[0].get("library", {}).get("name", "N/A") if top else "N/A",
  "recommended_direction": os.environ.get("DIRECTION", ""),
  "icon_enabled": icon_enabled,
  "artifacts": (
    [
      "flow.input.json",
      os.path.basename(os.environ["REQ_SUMMARY_PATH"]),
      os.path.basename(os.environ["STYLE_SCOPE_LOCK_PATH"]),
      os.path.basename(os.environ["STYLE_SCOPE_CHECKLIST_PATH"]),
    ]
    + (
      [
        os.path.basename(os.environ["ICON_MANIFEST_PATH"]),
        os.path.basename(os.environ["ICON_SPEC_PATH"]),
        os.path.basename(os.environ["ICON_SPRITE_PATH"]),
      ]
      if icon_enabled
      else []
    )
    + [
      os.path.basename(os.environ["REQ_PRD_PATH"]),
      os.path.basename(os.environ["REQ_QUESTIONS_PATH"]),
      os.path.basename(os.environ["STYLE_PROFILE_PATH"]),
      "selector.recommend.json",
      "selector.evaluate.json",
      "aesthetic.score.json",
      os.path.basename(os.environ["TOKENS_JSON_PATH"]),
      os.path.basename(os.environ["TOKENS_CSS_PATH"]),
      os.path.basename(os.environ["STAGE_STATUS_PATH"]),
      os.path.basename(os.environ["QUALITY_GATES_PATH"]),
      os.path.basename(os.environ["SCORECARD_PATH"]),
      os.path.basename(os.environ["OPTIMIZATION_PLAN_PATH"]),
      os.path.basename(os.environ["DECISION_TRACE_PATH"]),
      "fullflow.report.md",
    ]
  ),
  "next_skills": next_skills
}, ensure_ascii=False, indent=2))
lines.append("```")
lines.append("")

with open(os.environ["REPORT_PATH"], "w", encoding="utf-8") as f:
  f.write("\n".join(lines) + "\n")
PY

echo "fullflow complete"
echo "output: $OUT_DIR"
echo "style_scope_lock: $STYLE_SCOPE_LOCK_PATH"
if [[ "$ICON_ENABLED" == "1" ]]; then
  echo "icon_manifest: $ICON_MANIFEST_PATH"
fi
echo "stage_status: $STAGE_STATUS_PATH"
echo "quality_gates: $QUALITY_GATES_PATH"
echo "scorecard: $SCORECARD_PATH"
echo "optimization_plan: $OPTIMIZATION_PLAN_PATH"
echo "decision_trace: $DECISION_TRACE_PATH"
echo "report: $REPORT_PATH"
