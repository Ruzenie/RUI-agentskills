#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../../.." && pwd)"

usage() {
  cat <<'USAGE'
run_fullflow_pipeline.sh

Usage:
  bash skills/ui-fullflow-orchestrator/scripts/run_fullflow_pipeline.sh \
    --brief "SaaS数据看板，强调可读性和主CTA" \
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
  --scope-file <path>          (可重复，也支持逗号分隔)
  --icon-mode <auto|on|off>
  --icon-style <outline|filled|two-tone>
  --priority <id>             (可重复，也支持逗号分隔)
  --design-style <id>
  --team-size <id>
  --density <id>
  --brand-color <#RRGGBB>
  --top <n>
  --auto-complete            (自动执行 Phase 4/5)
  --refactor-threshold <n>   (Phase 4 文件行数阈值，默认 200)
  --render-threshold <n>     (Phase 4 渲染逻辑行阈值，默认 30)
  --duplicate-threshold <n>  (Phase 4 重复模式阈值，默认 3)
  --props-depth-threshold <n> (Phase 4 props透传层级阈值，默认 3)
  --acceptance-level <id>    (Phase 5 验收级别: strict|normal|loose)
  --out-dir <dir>
  --workspace-root <dir>      (默认使用调用命令时的工作区目录)
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
AUTO_COMPLETE="0"
REFACTOR_THRESHOLD="200"
RENDER_THRESHOLD="30"
DUPLICATE_THRESHOLD="3"
PROPS_DEPTH_THRESHOLD="3"
ACCEPTANCE_LEVEL="strict"
OUT_DIR=""
WORKSPACE_ROOT_ARG=""
DIRECTION=""
CALLER_PWD="$(pwd -P)"
ARG_AUTO_COMPLETE_SET="0"
ARG_REFACTOR_THRESHOLD_SET="0"
ARG_RENDER_THRESHOLD_SET="0"
ARG_DUPLICATE_THRESHOLD_SET="0"
ARG_PROPS_DEPTH_THRESHOLD_SET="0"
ARG_ACCEPTANCE_LEVEL_SET="0"
ARG_DENSITY_SET="0"
ARG_ICON_STYLE_SET="0"

now_ms() {
  date +%s%3N
}

peak_rss_kb() {
  awk '/VmHWM:/ {print $2}' "/proc/$$/status" 2>/dev/null || echo 0
}

dir_size_kb() {
  du -sk "$1" 2>/dev/null | awk '{print $1}'
}

is_under_repo_root() {
  local candidate="$1"
  case "$candidate" in
    "$REPO_ROOT"|"$REPO_ROOT"/*) return 0 ;;
    *) return 1 ;;
  esac
}

resolve_workspace_root() {
  local candidate=""
  if [[ -n "$WORKSPACE_ROOT_ARG" ]]; then
    candidate="$WORKSPACE_ROOT_ARG"
  elif [[ -n "${RUI_WORKSPACE_ROOT:-}" ]]; then
    candidate="$RUI_WORKSPACE_ROOT"
  else
    candidate="$CALLER_PWD"
    if is_under_repo_root "$candidate"; then
      if [[ -n "${OLDPWD:-}" && -d "${OLDPWD:-}" ]]; then
        local oldpwd_real
        oldpwd_real="$(cd "${OLDPWD}" && pwd -P)"
        if ! is_under_repo_root "$oldpwd_real"; then
          candidate="$oldpwd_real"
        fi
      fi
    fi
  fi

  if [[ "$candidate" != /* ]]; then
    candidate="$CALLER_PWD/$candidate"
  fi

  if [[ -d "$candidate" ]]; then
    (cd "$candidate" && pwd -P)
    return
  fi

  echo "Error: workspace root 不存在: $candidate" >&2
  exit 1
}

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
    --icon-style) ICON_STYLE="$2"; ARG_ICON_STYLE_SET="1"; shift 2 ;;
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
    --density) DENSITY="$2"; ARG_DENSITY_SET="1"; shift 2 ;;
    --brand-color) BRAND_COLOR="$2"; shift 2 ;;
    --top) TOP="$2"; shift 2 ;;
    --auto-complete) AUTO_COMPLETE="1"; ARG_AUTO_COMPLETE_SET="1"; shift 1 ;;
    --refactor-threshold) REFACTOR_THRESHOLD="$2"; ARG_REFACTOR_THRESHOLD_SET="1"; shift 2 ;;
    --render-threshold) RENDER_THRESHOLD="$2"; ARG_RENDER_THRESHOLD_SET="1"; shift 2 ;;
    --duplicate-threshold) DUPLICATE_THRESHOLD="$2"; ARG_DUPLICATE_THRESHOLD_SET="1"; shift 2 ;;
    --props-depth-threshold) PROPS_DEPTH_THRESHOLD="$2"; ARG_PROPS_DEPTH_THRESHOLD_SET="1"; shift 2 ;;
    --acceptance-level) ACCEPTANCE_LEVEL="$2"; ARG_ACCEPTANCE_LEVEL_SET="1"; shift 2 ;;
    --out-dir) OUT_DIR="$2"; shift 2 ;;
    --workspace-root) WORKSPACE_ROOT_ARG="$2"; shift 2 ;;
    --direction) DIRECTION="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown arg: $1"; usage; exit 1 ;;
  esac
done

if [[ -n "$BRIEF_FILE" ]]; then
  BRIEF="$(cat "$BRIEF_FILE")"
fi

if [[ -z "$BRIEF" || -z "$FRAMEWORK" || -z "$PROJECT_TYPE" ]]; then
  echo "Error: 缺少必填参数（--brief/--brief-file, --framework, --project-type）" >&2
  usage
  exit 1
fi

if [[ "$ICON_MODE" != "auto" && "$ICON_MODE" != "on" && "$ICON_MODE" != "off" ]]; then
  echo "Error: --icon-mode 仅支持 auto|on|off" >&2
  exit 1
fi

WORKSPACE_ROOT="$(resolve_workspace_root)"
eval "$(python3 "$REPO_ROOT/skills/skill-structure-governor/scripts/config_loader.py" --repo-root "$REPO_ROOT" --workspace-root "$WORKSPACE_ROOT" --print-env)"
if [[ "$ARG_DENSITY_SET" != "1" && -n "${RUI_CFG_DENSITY:-}" ]]; then
  DENSITY="$RUI_CFG_DENSITY"
fi
if [[ "$ARG_ICON_STYLE_SET" != "1" && -n "${RUI_CFG_ICON_STYLE:-}" ]]; then
  ICON_STYLE="$RUI_CFG_ICON_STYLE"
fi
if [[ "$ARG_AUTO_COMPLETE_SET" != "1" ]]; then
  AUTO_COMPLETE="${RUI_CFG_AUTO_COMPLETE:-0}"
fi
if [[ "$ARG_REFACTOR_THRESHOLD_SET" != "1" && -n "${RUI_CFG_REFACTOR_FILE_LINES:-}" ]]; then
  REFACTOR_THRESHOLD="$RUI_CFG_REFACTOR_FILE_LINES"
fi
if [[ "$ARG_RENDER_THRESHOLD_SET" != "1" && -n "${RUI_CFG_REFACTOR_RENDER_LINES:-}" ]]; then
  RENDER_THRESHOLD="$RUI_CFG_REFACTOR_RENDER_LINES"
fi
if [[ "$ARG_DUPLICATE_THRESHOLD_SET" != "1" && -n "${RUI_CFG_REFACTOR_PATTERN_REPEAT:-}" ]]; then
  DUPLICATE_THRESHOLD="$RUI_CFG_REFACTOR_PATTERN_REPEAT"
fi
if [[ "$ARG_PROPS_DEPTH_THRESHOLD_SET" != "1" && -n "${RUI_CFG_REFACTOR_PROP_DRILL:-}" ]]; then
  PROPS_DEPTH_THRESHOLD="$RUI_CFG_REFACTOR_PROP_DRILL"
fi
if [[ "$ARG_ACCEPTANCE_LEVEL_SET" != "1" && -n "${RUI_CFG_ACCEPTANCE_LEVEL:-}" ]]; then
  ACCEPTANCE_LEVEL="$RUI_CFG_ACCEPTANCE_LEVEL"
fi

if [[ "$ACCEPTANCE_LEVEL" != "strict" && "$ACCEPTANCE_LEVEL" != "normal" && "$ACCEPTANCE_LEVEL" != "loose" ]]; then
  echo "Error: --acceptance-level 仅支持 strict|normal|loose" >&2
  exit 1
fi
for v in "$REFACTOR_THRESHOLD" "$RENDER_THRESHOLD" "$DUPLICATE_THRESHOLD" "$PROPS_DEPTH_THRESHOLD"; do
  if ! [[ "$v" =~ ^[0-9]+$ ]]; then
    echo "Error: Phase4 阈值参数必须是非负整数" >&2
    exit 1
  fi
done

if [[ -z "$OUT_DIR" ]]; then
  OUT_DIR="$WORKSPACE_ROOT/Ruiagents/$(date +%Y%m%d-%H%M%S)"
elif [[ "$OUT_DIR" != /* ]]; then
  OUT_DIR="$WORKSPACE_ROOT/$OUT_DIR"
fi
mkdir -p "$OUT_DIR"
OUT_DIR_SIZE_START_KB="$(dir_size_kb "$OUT_DIR")"
if [[ -z "$OUT_DIR_SIZE_START_KB" ]]; then
  OUT_DIR_SIZE_START_KB="0"
fi
WORKFLOW_ID="rui-flow-$(date +%Y%m%d-%H%M%S)"
STARTED_AT_UTC="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
PIPELINE_START_MS="$(now_ms)"
PHASE1_DURATION_MS="0"
PHASE2_DURATION_MS="0"
PHASE3_DURATION_MS="0"
PHASE4_DURATION_MS="0"
PHASE5_DURATION_MS="0"
REQ_ENGINE_DURATION_MS="0"
STYLE_SCOPE_BUILD_DURATION_MS="0"
STYLE_SCOPE_VALIDATE_DURATION_MS="0"
ICON_DETECT_DURATION_MS="0"
ICON_GENERATE_DURATION_MS="0"
SELECTOR_RECOMMEND_DURATION_MS="0"
SELECTOR_EVALUATE_DURATION_MS="0"
AESTHETIC_SCORE_DURATION_MS="0"
TOKENS_DURATION_MS="0"
ADAPTER_SELECT_DURATION_MS="0"
PHASE4_HOOK_BEFORE_DURATION_MS="0"
PHASE4_SCRIPT_DURATION_MS="0"
PHASE5_SCRIPT_DURATION_MS="0"
PHASE5_HOOK_AFTER_DURATION_MS="0"
GATE_VALIDATE_PRE_DURATION_MS="0"
GATE_VALIDATE_POST_DURATION_MS="0"

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
ICON_ANALYSIS_PATH="$OUT_DIR/icon.need.analysis.json"
RECOMMEND_PATH="$OUT_DIR/selector.recommend.json"
EVALUATE_PATH="$OUT_DIR/selector.evaluate.json"
SCORE_PATH="$OUT_DIR/aesthetic.score.json"
TOKENS_JSON_PATH="$OUT_DIR/tokens.json"
TOKENS_CSS_PATH="$OUT_DIR/tokens.css"
ADAPTER_MANIFEST_PATH="$OUT_DIR/framework.adapter.manifest.json"
FLOW_METRICS_PATH="$OUT_DIR/flow.metrics.json"
STYLE_SCOPE_VALIDATION_PATH="$OUT_DIR/style.scope.validation.json"
PLUGIN_PHASE4_HOOKS_PATH="$OUT_DIR/plugin.hooks.phase4.before.json"
PLUGIN_PHASE5_HOOKS_PATH="$OUT_DIR/plugin.hooks.phase5.after.json"
SCORECARD_PATH="$OUT_DIR/self-eval.scorecard.json"
OPTIMIZATION_PLAN_PATH="$OUT_DIR/optimization.plan.md"
REPORT_PATH="$OUT_DIR/fullflow.report.md"
STAGE_STATUS_PATH="$OUT_DIR/stage.status.json"
QUALITY_GATES_PATH="$OUT_DIR/quality.gates.md"
DECISION_TRACE_PATH="$OUT_DIR/decision.trace.md"
FLOW_STATE_PATH="$OUT_DIR/flow.state.json"
GATE_VALIDATION_PATH="$OUT_DIR/gate-validation-report.json"
PHASE4_REPORT_PATH="$OUT_DIR/phase4.refactor.report.json"
PHASE5_REPORT_PATH="$OUT_DIR/phase5.acceptance.report.json"
STATE_MACHINE_RULES_PATH="$REPO_ROOT/skills/contracts/state-machine-rules.yaml"
STATE_MACHINE_VALIDATION_PATH="$OUT_DIR/state-machine.validation.json"

export BRIEF FRAMEWORK PROJECT_TYPE STYLE_TARGET SCOPE_FILES_CSV PRIORITY_CSV ICON_MODE ICON_STYLE DESIGN_STYLE TEAM_SIZE DENSITY FLOW_INPUT_PATH AUTO_COMPLETE REFACTOR_THRESHOLD RENDER_THRESHOLD DUPLICATE_THRESHOLD PROPS_DEPTH_THRESHOLD ACCEPTANCE_LEVEL
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
  "auto_complete": os.environ.get("AUTO_COMPLETE") == "1",
  "refactor_threshold": int(os.environ.get("REFACTOR_THRESHOLD", "200")),
  "render_threshold": int(os.environ.get("RENDER_THRESHOLD", "30")),
  "duplicate_threshold": int(os.environ.get("DUPLICATE_THRESHOLD", "3")),
  "props_depth_threshold": int(os.environ.get("PROPS_DEPTH_THRESHOLD", "3")),
  "acceptance_level": os.environ.get("ACCEPTANCE_LEVEL", "strict"),
}
with open(os.environ["FLOW_INPUT_PATH"], "w", encoding="utf-8") as f:
  json.dump(payload, f, ensure_ascii=False, indent=2)
  f.write("\n")
PY

PHASE1_START_MS="$(now_ms)"
REQ_ENGINE_START_MS="$(now_ms)"
(
  cd "$REPO_ROOT"
  python3 skills/requirements-elicitation-engine/scripts/generate_requirements_brief.py \
    --brief "$BRIEF" \
    --out-dir "$OUT_DIR" \
    --json
) > "$REQ_SUMMARY_PATH"
REQ_ENGINE_DURATION_MS="$(( $(now_ms) - REQ_ENGINE_START_MS ))"

SCOPE_CMD=(
  python3 skills/style-scope-guard/scripts/build_style_scope_lock.py
  --brief "$BRIEF"
  --json-out "$STYLE_SCOPE_LOCK_PATH"
  --md-out "$STYLE_SCOPE_CHECKLIST_PATH"
)
STYLE_SCOPE_REQUIRED="0"
if [[ -n "$STYLE_TARGET" ]]; then
  SCOPE_CMD+=(--target "$STYLE_TARGET")
  STYLE_SCOPE_REQUIRED="1"
fi
IFS=',' read -r -a SCOPE_FILES_ITEMS <<< "$SCOPE_FILES_CSV"
for item in "${SCOPE_FILES_ITEMS[@]}"; do
  trimmed="${item// /}"
  if [[ -n "$trimmed" ]]; then
    SCOPE_CMD+=(--allowed-file "$trimmed")
    STYLE_SCOPE_REQUIRED="1"
  fi
done

STYLE_SCOPE_BUILD_START_MS="$(now_ms)"
(
  cd "$REPO_ROOT"
  "${SCOPE_CMD[@]}" >/dev/null
)
STYLE_SCOPE_BUILD_DURATION_MS="$(( $(now_ms) - STYLE_SCOPE_BUILD_START_MS ))"

export STYLE_SCOPE_LOCK_PATH
SCOPE_LOCKED="$(python3 - <<'PY'
import json, os
with open(os.environ["STYLE_SCOPE_LOCK_PATH"], "r", encoding="utf-8") as f:
  data = json.load(f)
print("1" if data.get("scope_locked") else "0")
PY
)"

if [[ "$STYLE_SCOPE_REQUIRED" == "1" && "$SCOPE_LOCKED" != "1" ]]; then
  echo "Error: 样式改动范围未锁定，请提供 --style-target（建议同时提供 --scope-file）" >&2
  exit 1
fi
if [[ "$STYLE_SCOPE_REQUIRED" != "1" && "$SCOPE_LOCKED" != "1" ]]; then
  echo "Warning: 未启用 style-scope-guard 强约束（本次未提供 --style-target/--scope-file）" >&2
fi
if git -C "$WORKSPACE_ROOT" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  CHANGED_FILES_CSV="$(git -C "$WORKSPACE_ROOT" diff --name-only | paste -sd, -)"
else
  CHANGED_FILES_CSV=""
fi
if [[ "$STYLE_SCOPE_REQUIRED" == "1" ]]; then
  STYLE_SCOPE_VALIDATE_START_MS="$(now_ms)"
  (
    cd "$REPO_ROOT"
    python3 skills/style-scope-guard/scripts/validate_scope_change.py \
      --lock-file "$STYLE_SCOPE_LOCK_PATH" \
      --changed-files "$CHANGED_FILES_CSV" \
      --workspace-root "$WORKSPACE_ROOT" \
      --json-out "$STYLE_SCOPE_VALIDATION_PATH" >/dev/null || true
  )
  STYLE_SCOPE_VALIDATE_DURATION_MS="$(( $(now_ms) - STYLE_SCOPE_VALIDATE_START_MS ))"
else
  STYLE_SCOPE_VALIDATE_START_MS="$(now_ms)"
  python3 - <<'PY' "$STYLE_SCOPE_VALIDATION_PATH"
import json, sys
obj = {
  "scope_lock_valid": True,
  "summary": {"changed_count": 0, "violation_count": 0},
  "note": "style-scope-guard 未启用强约束，跳过联动验证"
}
with open(sys.argv[1], "w", encoding="utf-8") as f:
  json.dump(obj, f, ensure_ascii=False, indent=2)
  f.write("\n")
PY
  STYLE_SCOPE_VALIDATE_DURATION_MS="$(( $(now_ms) - STYLE_SCOPE_VALIDATE_START_MS ))"
fi
PHASE1_DURATION_MS="$(( $(now_ms) - PHASE1_START_MS ))"

PHASE2_START_MS="$(now_ms)"
ICON_ENABLED="0"
if [[ "$ICON_MODE" == "on" ]]; then
  ICON_ENABLED="1"
  ICON_DETECT_START_MS="$(now_ms)"
  python3 - <<'PY' "$ICON_ANALYSIS_PATH"
import json, sys
obj = {
  "needed": True,
  "confidence": 1.0,
  "categories": ["forced"],
  "estimated_count": 8,
  "style_preference": "outline",
  "rationale": "icon-mode=on 强制开启图标生成",
  "keywords_found": []
}
with open(sys.argv[1], "w", encoding="utf-8") as f:
  json.dump(obj, f, ensure_ascii=False, indent=2)
  f.write("\n")
PY
  ICON_DETECT_DURATION_MS="$(( $(now_ms) - ICON_DETECT_START_MS ))"
elif [[ "$ICON_MODE" == "auto" ]]; then
  ICON_DETECT_START_MS="$(now_ms)"
  (
    cd "$REPO_ROOT"
    python3 skills/svg-canvas-icon-engine/scripts/detect_icon_need.py --brief "$BRIEF" --json
  ) > "$ICON_ANALYSIS_PATH"
  ICON_DETECT_DURATION_MS="$(( $(now_ms) - ICON_DETECT_START_MS ))"
  ICON_ENABLED="$(python3 - <<'PY' "$ICON_ANALYSIS_PATH"
import json, sys
with open(sys.argv[1], "r", encoding="utf-8") as f:
  data = json.load(f)
print("1" if data.get("needed") else "0")
PY
)"
  if [[ "$ARG_ICON_STYLE_SET" != "1" ]]; then
    ICON_STYLE="$(python3 - <<'PY' "$ICON_ANALYSIS_PATH"
import json, sys
with open(sys.argv[1], "r", encoding="utf-8") as f:
  data = json.load(f)
print(data.get("style_preference", "outline"))
PY
)"
  fi
else
  ICON_DETECT_START_MS="$(now_ms)"
  python3 - <<'PY' "$ICON_ANALYSIS_PATH"
import json, sys
obj = {
  "needed": False,
  "confidence": 1.0,
  "categories": [],
  "estimated_count": 0,
  "style_preference": "outline",
  "rationale": "icon-mode=off 关闭图标生成",
  "keywords_found": []
}
with open(sys.argv[1], "w", encoding="utf-8") as f:
  json.dump(obj, f, ensure_ascii=False, indent=2)
  f.write("\n")
PY
  ICON_DETECT_DURATION_MS="$(( $(now_ms) - ICON_DETECT_START_MS ))"
fi

if [[ "$ICON_ENABLED" == "1" ]]; then
  ICON_GENERATE_START_MS="$(now_ms)"
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
  ICON_GENERATE_DURATION_MS="$(( $(now_ms) - ICON_GENERATE_START_MS ))"
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

SELECTOR_RECOMMEND_START_MS="$(now_ms)"
(
  cd "$REPO_ROOT"
  "${REC_CMD[@]}"
) > "$RECOMMEND_PATH"
SELECTOR_RECOMMEND_DURATION_MS="$(( $(now_ms) - SELECTOR_RECOMMEND_START_MS ))"

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
  echo "Error: 推荐结果为空，无法继续" >&2
  exit 1
fi

SELECTOR_EVALUATE_START_MS="$(now_ms)"
(
  cd "$REPO_ROOT"
  node skills/ui-selector-pro/scripts/ui_library_engine.mjs evaluate --libraries "$TOP_IDS" --format json
) > "$EVALUATE_PATH"
SELECTOR_EVALUATE_DURATION_MS="$(( $(now_ms) - SELECTOR_EVALUATE_START_MS ))"

AESTHETIC_SCORE_START_MS="$(now_ms)"
(
  cd "$REPO_ROOT"
  python3 skills/ui-aesthetic-coach/scripts/score_ui_brief.py --text "$BRIEF" --json
) > "$SCORE_PATH"
AESTHETIC_SCORE_DURATION_MS="$(( $(now_ms) - AESTHETIC_SCORE_START_MS ))"

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

TOKENS_START_MS="$(now_ms)"
(
  cd "$REPO_ROOT"
  "${TOKEN_CMD[@]}" >/dev/null
)
TOKENS_DURATION_MS="$(( $(now_ms) - TOKENS_START_MS ))"

ADAPTER_SELECT_START_MS="$(now_ms)"
(
  cd "$REPO_ROOT"
  python3 skills/framework-adapters/scripts/select_adapter.py \
    --framework "$FRAMEWORK" \
    --repo-root "$REPO_ROOT" \
    --out-dir "$OUT_DIR" \
    --manifest "$ADAPTER_MANIFEST_PATH" \
    --emit-templates >/dev/null
)
ADAPTER_SELECT_DURATION_MS="$(( $(now_ms) - ADAPTER_SELECT_START_MS ))"
PHASE2_DURATION_MS="$(( $(now_ms) - PHASE2_START_MS ))"
PHASE3_DURATION_MS="0"
INITIAL_VERSION_NAME="$(
  cd "$REPO_ROOT"
  python3 skills/ui-fullflow-orchestrator/scripts/snapshot_artifacts.py \
    --out-dir "$OUT_DIR" \
    --label auto
)"

PHASE4_STATUS="pending"
PHASE5_STATUS="pending"
if [[ "$AUTO_COMPLETE" == "1" ]]; then
  PHASE4_START_MS="$(now_ms)"
  PHASE4_HOOK_BEFORE_START_MS="$(now_ms)"
  (
    cd "$REPO_ROOT"
    python3 skills/ui-fullflow-orchestrator/scripts/run_plugin_hooks.py \
      --repo-root "$REPO_ROOT" \
      --phase phase4_self_review \
      --when before \
      --workspace-root "$WORKSPACE_ROOT" \
      --out-dir "$OUT_DIR" \
      --state-file "$FLOW_STATE_PATH" \
      --report "$PLUGIN_PHASE4_HOOKS_PATH" >/dev/null || true
  )
  PHASE4_HOOK_BEFORE_DURATION_MS="$(( $(now_ms) - PHASE4_HOOK_BEFORE_START_MS ))"
  PHASE4_SCRIPT_START_MS="$(now_ms)"
  (
    cd "$REPO_ROOT"
    bash skills/ui-fullflow-orchestrator/scripts/run_phase4_refactor.sh \
      --workspace-root "$WORKSPACE_ROOT" \
      --out-dir "$OUT_DIR" \
      --refactor-threshold "$REFACTOR_THRESHOLD" \
      --render-threshold "$RENDER_THRESHOLD" \
      --duplicate-threshold "$DUPLICATE_THRESHOLD" \
      --props-depth-threshold "$PROPS_DEPTH_THRESHOLD" >/dev/null
  )
  PHASE4_SCRIPT_DURATION_MS="$(( $(now_ms) - PHASE4_SCRIPT_START_MS ))"
  PHASE4_STATUS="$(python3 - <<'PY' "$PHASE4_REPORT_PATH"
import json, sys
path = sys.argv[1]
with open(path, "r", encoding="utf-8") as f:
  data = json.load(f)
print(data.get("status", "pending"))
PY
)"
  PHASE4_DURATION_MS="$(( $(now_ms) - PHASE4_START_MS ))"

  GATE_VALIDATE_PRE_START_MS="$(now_ms)"
  (
    cd "$REPO_ROOT"
    python3 skills/quality-gate-validator/scripts/validate_gates.py \
      --out-dir "$OUT_DIR" \
      --workspace-root "$WORKSPACE_ROOT" \
      --repo-root "$REPO_ROOT" \
      --report "$GATE_VALIDATION_PATH" \
      --tool-checks off >/dev/null || true
  )
  GATE_VALIDATE_PRE_DURATION_MS="$(( $(now_ms) - GATE_VALIDATE_PRE_START_MS ))"

  PHASE5_START_MS="$(now_ms)"
  PHASE5_SCRIPT_START_MS="$(now_ms)"
  (
    cd "$REPO_ROOT"
    bash skills/ui-fullflow-orchestrator/scripts/run_phase5_acceptance.sh \
      --out-dir "$OUT_DIR" \
      --workspace-root "$WORKSPACE_ROOT" \
      --acceptance-level "$ACCEPTANCE_LEVEL" >/dev/null
  )
  PHASE5_SCRIPT_DURATION_MS="$(( $(now_ms) - PHASE5_SCRIPT_START_MS ))"
  PHASE5_STATUS="$(python3 - <<'PY' "$PHASE5_REPORT_PATH"
import json, sys
path = sys.argv[1]
with open(path, "r", encoding="utf-8") as f:
  data = json.load(f)
print(data.get("status", "pending"))
PY
)"
  PHASE5_DURATION_MS="$(( $(now_ms) - PHASE5_START_MS ))"
  PHASE5_HOOK_AFTER_START_MS="$(now_ms)"
  (
    cd "$REPO_ROOT"
    python3 skills/ui-fullflow-orchestrator/scripts/run_plugin_hooks.py \
      --repo-root "$REPO_ROOT" \
      --phase phase5_acceptance \
      --when after \
      --workspace-root "$WORKSPACE_ROOT" \
      --out-dir "$OUT_DIR" \
      --state-file "$FLOW_STATE_PATH" \
      --report "$PLUGIN_PHASE5_HOOKS_PATH" >/dev/null || true
  )
  PHASE5_HOOK_AFTER_DURATION_MS="$(( $(now_ms) - PHASE5_HOOK_AFTER_START_MS ))"
else
  python3 - <<'PY' "$PHASE4_REPORT_PATH" "$PHASE5_REPORT_PATH"
import json, sys
phase4 = {
  "phase": "phase4_self_review",
  "status": "pending",
  "summary": {"message": "auto-complete 未启用，待执行 run_phase4_refactor.sh"},
}
phase5 = {
  "phase": "phase5_acceptance",
  "status": "pending",
  "summary": {"message": "auto-complete 未启用，待执行 run_phase5_acceptance.sh"},
}
with open(sys.argv[1], "w", encoding="utf-8") as f:
  json.dump(phase4, f, ensure_ascii=False, indent=2)
  f.write("\n")
with open(sys.argv[2], "w", encoding="utf-8") as f:
  json.dump(phase5, f, ensure_ascii=False, indent=2)
  f.write("\n")
PY
  python3 - <<'PY' "$PLUGIN_PHASE4_HOOKS_PATH" "$PLUGIN_PHASE5_HOOKS_PATH"
import json, sys
for path in sys.argv[1:]:
  with open(path, "w", encoding="utf-8") as f:
    json.dump({"hooks": [], "note": "auto-complete 未启用，插件hook未执行"}, f, ensure_ascii=False, indent=2)
    f.write("\n")
PY
  PHASE4_DURATION_MS="0"
  PHASE5_DURATION_MS="0"
  PHASE4_HOOK_BEFORE_DURATION_MS="0"
  PHASE4_SCRIPT_DURATION_MS="0"
  PHASE5_SCRIPT_DURATION_MS="0"
  PHASE5_HOOK_AFTER_DURATION_MS="0"
  GATE_VALIDATE_PRE_DURATION_MS="0"
fi

TOTAL_DURATION_MS="$(( $(now_ms) - PIPELINE_START_MS ))"
PIPELINE_PEAK_RSS_KB="$(peak_rss_kb)"
if [[ -z "$PIPELINE_PEAK_RSS_KB" ]]; then
  PIPELINE_PEAK_RSS_KB="0"
fi
OUT_DIR_SIZE_END_KB="$(dir_size_kb "$OUT_DIR")"
if [[ -z "$OUT_DIR_SIZE_END_KB" ]]; then
  OUT_DIR_SIZE_END_KB="0"
fi
OUT_DIR_SIZE_DELTA_KB="$(( OUT_DIR_SIZE_END_KB - OUT_DIR_SIZE_START_KB ))"
if [[ "$OUT_DIR_SIZE_DELTA_KB" -lt 0 ]]; then
  OUT_DIR_SIZE_DELTA_KB="0"
fi
export WORKFLOW_ID TOTAL_DURATION_MS PHASE1_DURATION_MS PHASE2_DURATION_MS PHASE3_DURATION_MS PHASE4_DURATION_MS PHASE5_DURATION_MS ICON_ENABLED AUTO_COMPLETE REQ_ENGINE_DURATION_MS STYLE_SCOPE_BUILD_DURATION_MS STYLE_SCOPE_VALIDATE_DURATION_MS ICON_DETECT_DURATION_MS ICON_GENERATE_DURATION_MS SELECTOR_RECOMMEND_DURATION_MS SELECTOR_EVALUATE_DURATION_MS AESTHETIC_SCORE_DURATION_MS TOKENS_DURATION_MS ADAPTER_SELECT_DURATION_MS PHASE4_HOOK_BEFORE_DURATION_MS PHASE4_SCRIPT_DURATION_MS PHASE5_SCRIPT_DURATION_MS PHASE5_HOOK_AFTER_DURATION_MS GATE_VALIDATE_PRE_DURATION_MS GATE_VALIDATE_POST_DURATION_MS PIPELINE_PEAK_RSS_KB OUT_DIR_SIZE_DELTA_KB
python3 - <<'PY' "$FLOW_METRICS_PATH" "$OUT_DIR"
import json, os, sys
from pathlib import Path
out_dir = Path(sys.argv[2])
files = [p for p in out_dir.glob("*") if p.is_file()]
icon_enabled = os.environ.get("ICON_ENABLED", "0") == "1"
skill_breakdown = {
  "requirements-elicitation-engine": int(os.environ.get("REQ_ENGINE_DURATION_MS", "0")),
  "style-scope-guard": int(os.environ.get("STYLE_SCOPE_BUILD_DURATION_MS", "0")) + int(os.environ.get("STYLE_SCOPE_VALIDATE_DURATION_MS", "0")),
  "svg-canvas-icon-engine": int(os.environ.get("ICON_DETECT_DURATION_MS", "0")) + int(os.environ.get("ICON_GENERATE_DURATION_MS", "0")),
  "ui-selector-playbook": int(os.environ.get("SELECTOR_RECOMMEND_DURATION_MS", "0")) + int(os.environ.get("SELECTOR_EVALUATE_DURATION_MS", "0")),
  "ui-aesthetic-coach": int(os.environ.get("AESTHETIC_SCORE_DURATION_MS", "0")),
  "ui-aesthetic-generator": int(os.environ.get("TOKENS_DURATION_MS", "0")),
  "framework-adapters": int(os.environ.get("ADAPTER_SELECT_DURATION_MS", "0")),
  "ui-generation-workflow-runner": int(os.environ.get("PHASE3_DURATION_MS", "0")),
  "ui-self-reviewer": int(os.environ.get("PHASE4_SCRIPT_DURATION_MS", "0")),
  "ui-acceptance-auditor": int(os.environ.get("PHASE5_SCRIPT_DURATION_MS", "0")),
  "quality-gate-validator": int(os.environ.get("GATE_VALIDATE_PRE_DURATION_MS", "0")) + int(os.environ.get("GATE_VALIDATE_POST_DURATION_MS", "0")),
}
if not icon_enabled:
  skill_breakdown["svg-canvas-icon-engine"] = 0
obj = {
  "workflow_id": os.environ.get("WORKFLOW_ID", "rui-flow-unknown"),
  "metrics": {
    "pipeline_execution": {
      "total_duration_ms": int(os.environ.get("TOTAL_DURATION_MS", "0")),
      "breakdown": {
        "phase1_requirements": int(os.environ.get("PHASE1_DURATION_MS", "0")),
        "phase2_architecture": int(os.environ.get("PHASE2_DURATION_MS", "0")),
        "phase3_implementation": int(os.environ.get("PHASE3_DURATION_MS", "0")),
        "phase4_self_review": int(os.environ.get("PHASE4_DURATION_MS", "0")),
        "phase5_acceptance": int(os.environ.get("PHASE5_DURATION_MS", "0")),
      },
      "skill_breakdown": skill_breakdown,
      "timeline": {
        "requirements_elicitation": int(os.environ.get("REQ_ENGINE_DURATION_MS", "0")),
        "style_scope_lock_build": int(os.environ.get("STYLE_SCOPE_BUILD_DURATION_MS", "0")),
        "style_scope_validation": int(os.environ.get("STYLE_SCOPE_VALIDATE_DURATION_MS", "0")),
        "icon_need_detection": int(os.environ.get("ICON_DETECT_DURATION_MS", "0")),
        "icon_generation": int(os.environ.get("ICON_GENERATE_DURATION_MS", "0")),
        "selector_recommend": int(os.environ.get("SELECTOR_RECOMMEND_DURATION_MS", "0")),
        "selector_evaluate": int(os.environ.get("SELECTOR_EVALUATE_DURATION_MS", "0")),
        "aesthetic_score": int(os.environ.get("AESTHETIC_SCORE_DURATION_MS", "0")),
        "token_generation": int(os.environ.get("TOKENS_DURATION_MS", "0")),
        "framework_adapter_select": int(os.environ.get("ADAPTER_SELECT_DURATION_MS", "0")),
        "phase4_hook_before": int(os.environ.get("PHASE4_HOOK_BEFORE_DURATION_MS", "0")),
        "phase4_refactor": int(os.environ.get("PHASE4_SCRIPT_DURATION_MS", "0")),
        "phase5_acceptance": int(os.environ.get("PHASE5_SCRIPT_DURATION_MS", "0")),
        "phase5_hook_after": int(os.environ.get("PHASE5_HOOK_AFTER_DURATION_MS", "0")),
        "gate_validation_pre": int(os.environ.get("GATE_VALIDATE_PRE_DURATION_MS", "0")),
        "gate_validation_post": int(os.environ.get("GATE_VALIDATE_POST_DURATION_MS", "0")),
      },
    },
    "resource_usage": {
      "peak_memory_mb": round(int(os.environ.get("PIPELINE_PEAK_RSS_KB", "0")) / 1024.0, 2),
      "temp_files_count": len(files),
      "disk_io_mb": round(int(os.environ.get("OUT_DIR_SIZE_DELTA_KB", "0")) / 1024.0, 2),
    },
    "external_calls": {
      "requirements_engine_runs": 1,
      "ui_selector_calls": 2,
      "aesthetic_calls": 2,
      "icon_engine_calls": 1 if icon_enabled else 0,
      "validator_calls": 2 if os.environ.get("AUTO_COMPLETE", "0") == "1" else 1,
    },
  },
}
with open(sys.argv[1], "w", encoding="utf-8") as f:
  json.dump(obj, f, ensure_ascii=False, indent=2)
  f.write("\n")
PY

WORKSPACE_BASELINE="未检测到 app/info.md"
if [[ -f "$WORKSPACE_ROOT/app/info.md" ]]; then
  WORKSPACE_BASELINE="$(head -n 1 "$WORKSPACE_ROOT/app/info.md")"
fi

export FLOW_INPUT_PATH REQ_SUMMARY_PATH REQ_PRD_PATH REQ_QUESTIONS_PATH STYLE_PROFILE_PATH STYLE_SCOPE_LOCK_PATH STYLE_SCOPE_CHECKLIST_PATH ICON_MANIFEST_PATH ICON_SPEC_PATH ICON_SPRITE_PATH ICON_CANVAS_DEMO_PATH ICON_ANALYSIS_PATH ICON_ENABLED RECOMMEND_PATH EVALUATE_PATH SCORE_PATH TOKENS_JSON_PATH TOKENS_CSS_PATH ADAPTER_MANIFEST_PATH FLOW_METRICS_PATH STYLE_SCOPE_VALIDATION_PATH PLUGIN_PHASE4_HOOKS_PATH PLUGIN_PHASE5_HOOKS_PATH SCORECARD_PATH OPTIMIZATION_PLAN_PATH REPORT_PATH STAGE_STATUS_PATH QUALITY_GATES_PATH DECISION_TRACE_PATH WORKSPACE_BASELINE WORKSPACE_ROOT DIRECTION STYLE_SCOPE_REQUIRED FLOW_STATE_PATH GATE_VALIDATION_PATH WORKFLOW_ID STARTED_AT_UTC PHASE4_STATUS PHASE5_STATUS PHASE4_REPORT_PATH PHASE5_REPORT_PATH AUTO_COMPLETE RUI_CFG_GATE_REQUIREMENTS RUI_CFG_GATE_DESIGN RUI_CFG_GATE_REUSE RUI_CFG_GATE_COMPLEXITY RUI_CFG_GATE_TS REQ_ENGINE_DURATION_MS STYLE_SCOPE_BUILD_DURATION_MS STYLE_SCOPE_VALIDATE_DURATION_MS ICON_DETECT_DURATION_MS ICON_GENERATE_DURATION_MS SELECTOR_RECOMMEND_DURATION_MS SELECTOR_EVALUATE_DURATION_MS AESTHETIC_SCORE_DURATION_MS TOKENS_DURATION_MS ADAPTER_SELECT_DURATION_MS PHASE4_HOOK_BEFORE_DURATION_MS PHASE4_SCRIPT_DURATION_MS PHASE5_SCRIPT_DURATION_MS PHASE5_HOOK_AFTER_DURATION_MS GATE_VALIDATE_PRE_DURATION_MS GATE_VALIDATE_POST_DURATION_MS STATE_MACHINE_VALIDATION_PATH
python3 - <<'PY'
import json, os
from datetime import datetime, timezone

with open(os.environ["FLOW_INPUT_PATH"], "r", encoding="utf-8") as f:
  flow = json.load(f)
with open(os.environ["REQ_SUMMARY_PATH"], "r", encoding="utf-8") as f:
  req = json.load(f)
with open(os.environ["STYLE_SCOPE_LOCK_PATH"], "r", encoding="utf-8") as f:
  scope = json.load(f)
icon_enabled = os.environ.get("ICON_ENABLED", "0") == "1"
icon_analysis = {}
if os.path.exists(os.environ["ICON_ANALYSIS_PATH"]):
  with open(os.environ["ICON_ANALYSIS_PATH"], "r", encoding="utf-8") as f:
    icon_analysis = json.load(f)
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
style_scope_required = os.environ.get("STYLE_SCOPE_REQUIRED", "0") == "1"
style_scope_gate = style_scope_locked if style_scope_required else True
phase4_status = os.environ.get("PHASE4_STATUS", "pending")
phase5_status = os.environ.get("PHASE5_STATUS", "pending")
auto_complete = os.environ.get("AUTO_COMPLETE", "0") == "1"
icon_artifacts_ready = (
  icon_enabled
  and os.path.exists(os.environ["ICON_MANIFEST_PATH"])
  and os.path.exists(os.environ["ICON_SPEC_PATH"])
  and os.path.exists(os.environ["ICON_SPRITE_PATH"])
)
duration_by_skill = {
  "requirements-elicitation-engine": int(os.environ.get("REQ_ENGINE_DURATION_MS", "0")),
  "style-scope-guard": int(os.environ.get("STYLE_SCOPE_BUILD_DURATION_MS", "0")) + int(os.environ.get("STYLE_SCOPE_VALIDATE_DURATION_MS", "0")),
  "svg-canvas-icon-engine": int(os.environ.get("ICON_DETECT_DURATION_MS", "0")) + int(os.environ.get("ICON_GENERATE_DURATION_MS", "0")),
  "ui-selector-pro": int(os.environ.get("SELECTOR_RECOMMEND_DURATION_MS", "0")) + int(os.environ.get("SELECTOR_EVALUATE_DURATION_MS", "0")),
  "ui-selector-playbook": int(os.environ.get("SELECTOR_RECOMMEND_DURATION_MS", "0")) + int(os.environ.get("SELECTOR_EVALUATE_DURATION_MS", "0")),
  "ui-aesthetic-coach": int(os.environ.get("AESTHETIC_SCORE_DURATION_MS", "0")),
  "ui-aesthetic-generator": int(os.environ.get("TOKENS_DURATION_MS", "0")),
  "framework-adapters": int(os.environ.get("ADAPTER_SELECT_DURATION_MS", "0")),
  "ui-generation-workflow-runner": int(os.environ.get("PHASE3_DURATION_MS", "0")),
  "ui-self-reviewer": int(os.environ.get("PHASE4_SCRIPT_DURATION_MS", "0")),
  "ui-acceptance-auditor": int(os.environ.get("PHASE5_SCRIPT_DURATION_MS", "0")),
  "quality-gate-validator": int(os.environ.get("GATE_VALIDATE_PRE_DURATION_MS", "0")) + int(os.environ.get("GATE_VALIDATE_POST_DURATION_MS", "0")),
  "ui-agent-workspace": 0,
  "ui-codegen-master": int(os.environ.get("PHASE3_DURATION_MS", "0")),
}
must_pass_skills = [
  "requirements-elicitation-engine",
  "ui-codegen-master",
  "ui-selector-playbook",
  "ui-aesthetic-coach",
  "ui-aesthetic-generator",
  "ui-generation-workflow-runner",
  "ui-acceptance-auditor",
  "ui-self-reviewer",
  "ui-agent-workspace",
]
must_pass_evidence = {
  "requirements-elicitation-engine": "requirements.summary.json",
  "ui-codegen-master": "fullflow.report.md",
  "ui-selector-playbook": "selector.recommend.json/selector.evaluate.json",
  "ui-aesthetic-coach": "aesthetic.score.json",
  "ui-aesthetic-generator": "tokens.json/tokens.css",
  "ui-generation-workflow-runner": "tokens.json/tokens.css",
  "ui-acceptance-auditor": os.path.basename(os.environ.get("PHASE5_REPORT_PATH", "phase5.acceptance.report.json")),
  "ui-self-reviewer": os.path.basename(os.environ.get("PHASE4_REPORT_PATH", "phase4.refactor.report.json")),
  "ui-agent-workspace": "workspace_root baseline",
}
must_pass_passed = {
  "requirements-elicitation-engine": True,
  "ui-codegen-master": True,
  "ui-selector-playbook": True,
  "ui-aesthetic-coach": True,
  "ui-aesthetic-generator": True,
  "ui-generation-workflow-runner": True,
  "ui-acceptance-auditor": phase5_status == "completed",
  "ui-self-reviewer": phase4_status in {"completed", "completed_with_findings"},
  "ui-agent-workspace": bool(os.environ.get("WORKSPACE_ROOT")),
}
must_pass_status = []
for skill in must_pass_skills:
  passed = bool(must_pass_passed.get(skill, False))
  must_pass_status.append({
    "skill": skill,
    "status": "passed" if passed else "pending",
    "mode": "auto" if passed else "manual",
    "evidence": must_pass_evidence.get(skill, "待执行"),
  })
must_pass_gate = all(row["status"] == "passed" for row in must_pass_status)
next_skills = [row["skill"] for row in must_pass_status if row["status"] != "passed"]
if icon_enabled:
  next_skills.insert(0, "svg-canvas-icon-engine")

stage_status = [
  {
    "phase": "phase1_requirements",
    "name": "需求分析与设计探索",
    "status": "completed_with_risk" if req_completeness < 70 else "completed",
    "evidence": f"requirements.prd.md + {'style.scope.lock.json' if style_scope_required else 'style.scope.lock.json(可选)'} + completeness={req_completeness}/100",
    "duration_ms": int(os.environ.get("PHASE1_DURATION_MS", "0")),
  },
  {
    "phase": "phase2_architecture",
    "name": "架构规划与组件设计",
    "status": "completed_with_risk" if (icon_enabled and not icon_artifacts_ready) else "completed",
    "evidence": "selector.recommend.json + icon.manifest.json" if icon_enabled else "selector.recommend.json",
    "duration_ms": int(os.environ.get("PHASE2_DURATION_MS", "0")),
  },
  {
    "phase": "phase3_implementation",
    "name": "代码生成与实现",
    "status": "completed",
    "evidence": "tokens.json/tokens.css",
    "duration_ms": int(os.environ.get("PHASE3_DURATION_MS", "0")),
  },
  {
    "phase": "phase4_self_review",
    "name": "自我审查与重构",
    "status": phase4_status,
    "evidence": os.path.basename(os.environ.get("PHASE4_REPORT_PATH", "phase4.refactor.report.json")),
    "duration_ms": int(os.environ.get("PHASE4_DURATION_MS", "0")),
  },
  {
    "phase": "phase5_acceptance",
    "name": "验收与交付",
    "status": phase5_status,
    "evidence": os.path.basename(os.environ.get("PHASE5_REPORT_PATH", "phase5.acceptance.report.json")),
    "duration_ms": int(os.environ.get("PHASE5_DURATION_MS", "0")),
  },
]

score_value = int(score.get("total_score", 0))
quality_lines = []
quality_lines.append("# Quality Gates Checklist")
quality_lines.append("")
quality_lines.append("## 自动上下文")
quality_lines.append(f"- brief_score: {score_value}/35")
quality_lines.append(f"- recommended_direction: {os.environ.get('DIRECTION', '')}")
quality_lines.append(f"- style_target: {scope.get('style_target') or 'N/A'}")
quality_lines.append(f"- style_scope_required: {style_scope_required}")
quality_lines.append(f"- auto_complete: {auto_complete}")
quality_lines.append(f"- phase4_thresholds: file={flow.get('refactor_threshold')}, render={flow.get('render_threshold')}, duplicate={flow.get('duplicate_threshold')}, props_depth={flow.get('props_depth_threshold')}")
quality_lines.append(f"- phase4_status: {phase4_status}")
quality_lines.append(f"- phase5_status: {phase5_status}")
quality_lines.append(f"- requirement_completeness: {req.get('completeness_score', 'N/A')}/100")
quality_lines.append(f"- design_score_5: {design_score_5}/5")
quality_lines.append(f"- icon_enabled: {icon_enabled}")
if icon_analysis:
  quality_lines.append(f"- icon_confidence: {icon_analysis.get('confidence', 'N/A')}")
quality_lines.append(f"- must_pass_gate: {must_pass_gate}")
quality_lines.append("")
quality_lines.append("## 全流程必过技能链（固定9项）")
for row in must_pass_status:
  checkbox = "x" if row["status"] == "passed" else " "
  quality_lines.append(f"- [{checkbox}] {row['skill']} ({row['mode']})")
quality_lines.append("")
quality_lines.append("## 量化门槛（mimoskills对齐）")
quality_lines.append(f"- [ ] 需求完备度 >= {os.environ.get('RUI_CFG_GATE_REQUIREMENTS', '70')}（当前 {req_completeness}）")
quality_lines.append(f"- [ ] 审美评分 >= {os.environ.get('RUI_CFG_GATE_DESIGN', '4.0')}/5.0（当前 {design_score_5}）")
quality_lines.append("- [ ] 组件复用率 >= 40%（待代码阶段）")
quality_lines.append("- [ ] 圈复杂度 <= 10（待代码阶段）")
quality_lines.append("- [ ] TS 类型覆盖 >= 90%（待代码阶段）")
quality_lines.append("")
if req_completeness < 70:
  quality_lines.append("## 需求完备度告警")
  quality_lines.append("- [ ] 完备度低于 70，建议先补齐 requirements.questions.md")
  quality_lines.append("")
quality_lines.append("## 样式改动边界")
if style_scope_required:
  quality_lines.append("- [ ] 已确认 style.scope.lock.json 且 scope_locked=true")
  quality_lines.append("- [ ] 仅修改 style_target 对应区域")
  quality_lines.append("- [ ] 仅修改 allowed_files 中声明文件（如已声明）")
  quality_lines.append("- [ ] 未改动业务逻辑/API/路由/状态结构")
else:
  quality_lines.append("- [ ] 本次未启用强约束（未提供 style_target/scope_file）")
  quality_lines.append("- [ ] 如涉及样式边界风险，建议补充 style-scope-guard 产物")
quality_lines.append("")
quality_lines.append("## 功能验收")
quality_lines.append("- [ ] 核心功能路径通过")
quality_lines.append("- [ ] 异常/边界流程通过")
quality_lines.append("")
quality_lines.append("## 视觉验收")
quality_lines.append("- [ ] 视觉层级与留白节奏一致")
quality_lines.append("- [ ] 色彩对比达到 WCAG AA")
quality_lines.append("- [ ] 交互状态完整（hover/focus/disabled/loading/error）")
quality_lines.append("")
if icon_enabled:
  quality_lines.append("## 图标验收")
  quality_lines.append("- [ ] icon.manifest.json 与 icon.spec.md 已生成")
  quality_lines.append("- [ ] 图标尺寸层级统一（16/20/24）")
  quality_lines.append("- [ ] 图标命名符合 icon-<category>-<name>")
  quality_lines.append("")
quality_lines.append("## 代码验收")
quality_lines.append("- [ ] 无 any 类型")
quality_lines.append("- [ ] 渲染逻辑与文件长度符合阈值")
quality_lines.append("- [ ] 重复模式完成抽离")
quality_lines.append("")
quality_lines.append("## 性能验收")
quality_lines.append("- [ ] 关键页面加载与渲染指标达标")
quality_lines.append("- [ ] 大列表/图片资源有优化策略")
quality_lines.append("")
quality_lines.append("## 安全与兼容验收")
quality_lines.append("- [ ] 输入安全与敏感信息检查通过")
quality_lines.append("- [ ] Chrome/Firefox/Safari/Edge 主流程通过")
quality_lines.append("")
quality_lines.append("## 自评权重")
quality_lines.append("- 完整性 30%")
quality_lines.append("- 美学 25%")
quality_lines.append("- 可维护性 25%")
quality_lines.append("- 性能 20%")

with open(os.environ["STAGE_STATUS_PATH"], "w", encoding="utf-8") as f:
  json.dump(stage_status, f, ensure_ascii=False, indent=2)
  f.write("\n")

with open(os.environ["QUALITY_GATES_PATH"], "w", encoding="utf-8") as f:
  f.write("\n".join(quality_lines) + "\n")

scorecard = {
  "thresholds": {
    "requirement_completeness_min": int(os.environ.get("RUI_CFG_GATE_REQUIREMENTS", "70")),
    "design_score_min_5": float(os.environ.get("RUI_CFG_GATE_DESIGN", "4.0")),
    "component_reuse_rate_min": int(os.environ.get("RUI_CFG_GATE_REUSE", "40")),
    "cyclomatic_complexity_max": int(os.environ.get("RUI_CFG_GATE_COMPLEXITY", "10")),
    "ts_type_coverage_min": int(os.environ.get("RUI_CFG_GATE_TS", "90")),
  },
  "metrics": {
    "requirement_completeness": req_completeness,
    "design_score_5": design_score_5,
    "style_scope_locked": style_scope_locked,
    "style_scope_required": style_scope_required,
    "icon_enabled": icon_enabled,
    "icon_artifacts_ready": icon_artifacts_ready if icon_enabled else None,
    "must_pass_total": len(must_pass_skills),
    "must_pass_passed": len([row for row in must_pass_status if row["status"] == "passed"]),
    "must_pass_pending": [row["skill"] for row in must_pass_status if row["status"] != "passed"],
    "component_reuse_rate": None,
    "cyclomatic_complexity": None,
    "ts_type_coverage": None,
  },
  "gates": {
    "requirements_gate": req_completeness >= int(os.environ.get("RUI_CFG_GATE_REQUIREMENTS", "70")),
    "design_gate": design_score_5 >= float(os.environ.get("RUI_CFG_GATE_DESIGN", "4.0")),
    "style_scope_gate": style_scope_gate,
    "icon_gate": (icon_artifacts_ready if icon_enabled else True),
    "must_pass_gate": must_pass_gate,
    "code_quality_gate": None,
  },
}
scorecard["readiness"] = {
  "ready_for_generation": bool(
    scorecard["gates"]["requirements_gate"]
    and scorecard["gates"]["style_scope_gate"]
    and scorecard["gates"]["icon_gate"]
  ),
  "ready_for_delivery": bool(
    scorecard["gates"]["requirements_gate"]
    and scorecard["gates"]["design_gate"]
    and scorecard["gates"]["style_scope_gate"]
    and scorecard["gates"]["icon_gate"]
    and scorecard["gates"]["must_pass_gate"]
  ),
}
with open(os.environ["SCORECARD_PATH"], "w", encoding="utf-8") as f:
  json.dump(scorecard, f, ensure_ascii=False, indent=2)
  f.write("\n")

gate_details = [
  {
    "gate": "requirements_gate",
    "threshold": f"completeness_score >= {os.environ.get('RUI_CFG_GATE_REQUIREMENTS', '70')}",
    "actual": req_completeness,
    "status": "✅ PASS" if scorecard["gates"]["requirements_gate"] else "❌ FAIL",
    "evidence": "requirements.summary.json",
  },
  {
    "gate": "design_gate",
    "threshold": f"design_score_5 >= {os.environ.get('RUI_CFG_GATE_DESIGN', '4.0')}",
    "actual": design_score_5,
    "status": "✅ PASS" if scorecard["gates"]["design_gate"] else "❌ FAIL",
    "evidence": "aesthetic.score.json",
  },
  {
    "gate": "style_scope_gate",
    "threshold": "scope_locked=true (when style scope required)",
    "actual": style_scope_locked if style_scope_required else "optional",
    "status": "✅ PASS" if scorecard["gates"]["style_scope_gate"] else "❌ FAIL",
    "evidence": "style.scope.lock.json",
  },
  {
    "gate": "icon_gate",
    "threshold": "icon artifacts ready (when icon enabled)",
    "actual": icon_artifacts_ready if icon_enabled else "optional",
    "status": "✅ PASS" if scorecard["gates"]["icon_gate"] else "❌ FAIL",
    "evidence": "icon.manifest.json/icon.spec.md/icon.sprite.svg",
  },
  {
    "gate": "must_pass_gate",
    "threshold": "must-pass skills all passed",
    "actual": len([row for row in must_pass_status if row["status"] == "passed"]),
    "status": "✅ PASS" if scorecard["gates"]["must_pass_gate"] else "❌ FAIL",
    "evidence": "flow.state.json -> skills_status",
  },
]
gate_failed = [d for d in gate_details if d["status"].startswith("❌")]
gate_report = {
  "validation_id": f"gate-val-{datetime.now(timezone.utc).strftime('%Y%m%d-%H%M%S')}",
  "timestamp": datetime.now(timezone.utc).isoformat(),
  "summary": {
    "total_gates": len(gate_details),
    "passed": len(gate_details) - len(gate_failed),
    "failed": len(gate_failed),
    "pass_rate": f"{((len(gate_details) - len(gate_failed)) / len(gate_details)) * 100:.1f}%",
    "overall_passed": len(gate_failed) == 0,
  },
  "details": gate_details,
  "recommendations": [f"修复 {row['gate']} 未通过项" for row in gate_failed],
}
with open(os.environ["GATE_VALIDATION_PATH"], "w", encoding="utf-8") as f:
  json.dump(gate_report, f, ensure_ascii=False, indent=2)
  f.write("\n")

skills_status = {}
for row in must_pass_status:
  skills_status[row["skill"]] = {
    "status": "completed" if row["status"] == "passed" else "pending",
    "mode": row["mode"],
    "output": [row["evidence"]] if row["evidence"] != "待执行" else [],
    "checkpoint": datetime.now(timezone.utc).isoformat(),
    "duration_ms": duration_by_skill.get(row["skill"], 0),
  }
skills_status["style-scope-guard"] = {
  "status": "completed" if (style_scope_gate and style_scope_locked) else ("completed" if not style_scope_required else "failed"),
  "mode": "required" if style_scope_required else "optional",
  "output": [os.path.basename(os.environ["STYLE_SCOPE_LOCK_PATH"]), os.path.basename(os.environ["STYLE_SCOPE_VALIDATION_PATH"])],
  "checkpoint": datetime.now(timezone.utc).isoformat(),
  "duration_ms": duration_by_skill.get("style-scope-guard", 0),
}
skills_status["ui-selector-pro"] = {
  "status": "completed",
  "mode": "auto",
  "output": ["selector.recommend.json", "selector.evaluate.json"],
  "checkpoint": datetime.now(timezone.utc).isoformat(),
  "duration_ms": duration_by_skill.get("ui-selector-pro", 0),
}
skills_status["framework-adapters"] = {
  "status": "completed",
  "mode": "auto",
  "output": [os.path.basename(os.environ["ADAPTER_MANIFEST_PATH"])],
  "checkpoint": datetime.now(timezone.utc).isoformat(),
  "duration_ms": duration_by_skill.get("framework-adapters", 0),
}
skills_status["quality-gate-validator"] = {
  "status": "completed" if len(gate_failed) == 0 else "completed_with_findings",
  "mode": "auto",
  "output": [os.path.basename(os.environ["GATE_VALIDATION_PATH"])],
  "checkpoint": datetime.now(timezone.utc).isoformat(),
  "duration_ms": duration_by_skill.get("quality-gate-validator", 0),
}
if icon_enabled:
  skills_status["svg-canvas-icon-engine"] = {
    "status": "completed" if icon_artifacts_ready else "failed",
    "mode": "auto",
    "output": ["icon.manifest.json", "icon.spec.md", "icon.sprite.svg"] if icon_artifacts_ready else [],
    "checkpoint": datetime.now(timezone.utc).isoformat(),
    "duration_ms": duration_by_skill.get("svg-canvas-icon-engine", 0),
  }
artifact_list = [
  "flow.input.json",
  os.path.basename(os.environ["REQ_SUMMARY_PATH"]),
  os.path.basename(os.environ["REQ_PRD_PATH"]),
  os.path.basename(os.environ["REQ_QUESTIONS_PATH"]),
  os.path.basename(os.environ["STYLE_PROFILE_PATH"]),
  os.path.basename(os.environ["STYLE_SCOPE_LOCK_PATH"]),
  os.path.basename(os.environ["STYLE_SCOPE_CHECKLIST_PATH"]),
  os.path.basename(os.environ["STYLE_SCOPE_VALIDATION_PATH"]),
  os.path.basename(os.environ["ICON_ANALYSIS_PATH"]),
  "selector.recommend.json",
  "selector.evaluate.json",
  "aesthetic.score.json",
  os.path.basename(os.environ["TOKENS_JSON_PATH"]),
  os.path.basename(os.environ["TOKENS_CSS_PATH"]),
  os.path.basename(os.environ["ADAPTER_MANIFEST_PATH"]),
  os.path.basename(os.environ["FLOW_METRICS_PATH"]),
  os.path.basename(os.environ["PLUGIN_PHASE4_HOOKS_PATH"]),
  os.path.basename(os.environ["PLUGIN_PHASE5_HOOKS_PATH"]),
  os.path.basename(os.environ["STAGE_STATUS_PATH"]),
  os.path.basename(os.environ["PHASE4_REPORT_PATH"]),
  os.path.basename(os.environ["PHASE5_REPORT_PATH"]),
  os.path.basename(os.environ["QUALITY_GATES_PATH"]),
  os.path.basename(os.environ["SCORECARD_PATH"]),
  os.path.basename(os.environ["OPTIMIZATION_PLAN_PATH"]),
  os.path.basename(os.environ["DECISION_TRACE_PATH"]),
  os.path.basename(os.environ["GATE_VALIDATION_PATH"]),
  os.path.basename(os.environ["FLOW_STATE_PATH"]),
  os.path.basename(os.environ.get("STATE_MACHINE_VALIDATION_PATH", "state-machine.validation.json")),
  "CHANGELOG.md",
  "fullflow.report.md",
]
if icon_enabled:
  artifact_list.extend([
    os.path.basename(os.environ["ICON_MANIFEST_PATH"]),
    os.path.basename(os.environ["ICON_SPEC_PATH"]),
    os.path.basename(os.environ["ICON_SPRITE_PATH"]),
  ])
transition_log = [
  {"from": "pending", "to": "phase1_requirements", "event": "pipeline_started", "at": datetime.now(timezone.utc).isoformat()},
  {"from": "phase1_requirements", "to": "phase2_architecture", "event": "phase1_completed", "at": datetime.now(timezone.utc).isoformat()},
  {"from": "phase2_architecture", "to": "phase3_implementation", "event": "phase2_completed", "at": datetime.now(timezone.utc).isoformat()},
]
if auto_complete:
  transition_log.extend([
    {"from": "phase3_implementation", "to": "phase4_self_review", "event": "phase3_completed", "at": datetime.now(timezone.utc).isoformat()},
    {"from": "phase4_self_review", "to": "phase5_acceptance", "event": "phase4_completed", "at": datetime.now(timezone.utc).isoformat()},
  ])
if phase5_status == "completed" and scorecard["readiness"]["ready_for_delivery"]:
  transition_log.append({"from": "phase5_acceptance", "to": "completed", "event": "pipeline_completed", "at": datetime.now(timezone.utc).isoformat()})
flow_state = {
  "workflow_id": os.environ.get("WORKFLOW_ID", "rui-flow-unknown"),
  "version": "1.2.0",
  "state_machine_ref": "skills/contracts/state-machine-rules.yaml",
  "started_at": os.environ.get("STARTED_AT_UTC"),
  "updated_at": datetime.now(timezone.utc).isoformat(),
  "current_phase": (
    "completed"
    if (phase5_status == "completed" and scorecard["readiness"]["ready_for_delivery"])
    else (
      "phase5_acceptance"
      if (
        phase5_status in {"pending", "completed", "completed_with_risk"}
        and phase4_status in {"completed", "completed_with_findings"}
      )
      else "phase4_self_review"
    )
  ),
  "skills_status": skills_status,
  "blockers": [f"{row['gate']} 未通过" for row in gate_failed],
  "warnings": [f"{row['gate']} 需关注" for row in gate_failed] if gate_failed else [],
  "transition_log": transition_log,
  "next_actions": next_skills,
  "artifacts_manifest": {
    "total": len(artifact_list),
    "completed": len([name for name in artifact_list if name]),
    "pending": len(next_skills),
  },
}
with open(os.environ["FLOW_STATE_PATH"], "w", encoding="utf-8") as f:
  json.dump(flow_state, f, ensure_ascii=False, indent=2)
  f.write("\n")

plan_lines = []
plan_lines.append("# Optimization Plan")
plan_lines.append("")
plan_lines.append("## Priority Actions")
actions = []
if req_completeness < 70:
  missing_dims = req.get("missing_dimensions", []) or []
  missing_text = "、".join(missing_dims) if missing_dims else "关键维度"
  actions.append(f"[High] 补齐需求维度（当前 {req_completeness}/100）: {missing_text}。")
if design_score_5 < 4.0:
  actions.append(f"[High] 先修复审美短板（当前 {design_score_5}/5），优先处理 aesthetic.top_issues。")
if icon_enabled and not icon_artifacts_ready:
  actions.append("[High] 重新生成图标资产（manifest/spec/sprite）并复核命名与尺寸规则。")
if style_scope_required and not style_scope_locked:
  actions.append("[High] 先锁定样式改动范围，再进入实现。")
if not must_pass_gate:
  pending = [row["skill"] for row in must_pass_status if row["status"] != "passed"]
  actions.append(f"[High] 全流程必过技能未全部通过，需先完成: {', '.join(pending)}。")
if not actions:
  actions.append("[Medium] 按当前输入可进入实现，建议先执行生成与重构链路。")
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
trace_lines.append("## 1. 输入摘要")
trace_lines.append(f"- brief: {flow.get('brief', '')}")
trace_lines.append(f"- framework: {flow.get('framework', '')}")
trace_lines.append(f"- project_type: {flow.get('project_type', '')}")
trace_lines.append(f"- priorities: {', '.join(flow.get('priorities', [])) or 'none'}")
trace_lines.append(f"- requirement_completeness: {req.get('completeness_score', 'N/A')}/100")
trace_lines.append(f"- design_score_5: {design_score_5}/5")
trace_lines.append("")
trace_lines.append("## 2. 决策路径（可见摘要）")
trace_lines.append("1. requirements-elicitation-engine: 生成 PRD 草案、待确认问题与风格档案")
if style_scope_required:
  trace_lines.append("2. style-scope-guard: 锁定样式改动范围与可改文件边界")
else:
  trace_lines.append("2. style-scope-guard: 按需可选（本次未启用强约束）")
step_idx = 3
if icon_enabled:
  trace_lines.append(f"{step_idx}. svg-canvas-icon-engine: 生成图标清单、规范与可复用 sprite")
  step_idx += 1
trace_lines.append(f"{step_idx}. ui-selector-pro: 基于项目类型与优先级做候选库推荐")
step_idx += 1
trace_lines.append(f"{step_idx}. ui-selector-pro evaluate: 对 Top 3 候选做量化评估")
step_idx += 1
trace_lines.append(f"{step_idx}. ui-aesthetic-coach: brief 审美评分与方向建议")
step_idx += 1
trace_lines.append(f"{step_idx}. ui-aesthetic-coach tokens: 生成可实现 design tokens")
trace_lines.append("")
trace_lines.append("## 2.1 必过技能状态")
for idx, row in enumerate(must_pass_status, start=1):
  trace_lines.append(f"{idx}. {row['skill']}: {row['status']} ({row['mode']})")
trace_lines.append(f"- must_pass_gate: {must_pass_gate}")
trace_lines.append("")
trace_lines.append("## 3. 关键决策")
top_lib = top[0].get("library", {}).get("name", "N/A") if top else "N/A"
if style_scope_required:
  trace_lines.append(f"- 样式边界决策: {scope.get('style_target') or 'N/A'}（依据 style.scope.lock.json）")
else:
  trace_lines.append("- 样式边界决策: 本次未启用（style-scope-guard 非强制流程）")
if icon_enabled:
  trace_lines.append(f"- 图标决策: {icon_manifest.get('engine', 'svg')} / {icon_manifest.get('style', 'outline')}（依据 icon.manifest.json）")
trace_lines.append(f"- 选型决策: {top_lib}（依据推荐分与评估得分）")
trace_lines.append(f"- 风格决策: {os.environ.get('DIRECTION', '')}（依据审美评分推荐方向）")
trace_lines.append("")
trace_lines.append("## 4. 风险与待确认")
trace_lines.append(f"- 待确认问题数量: {req.get('question_count', 0)}（见 requirements.questions.md）")
if req_completeness < 70:
  trace_lines.append(f"- 需求完备度偏低: {req_completeness}/100（建议先补齐关键维度）")
if design_score_5 < 4.0:
  trace_lines.append(f"- 审美评分未达门槛: {design_score_5}/5（建议先处理视觉问题）")
trace_allowed_files = scope.get("allowed_files") or []
if trace_allowed_files:
  trace_lines.append(f"- 样式允许文件: {', '.join(trace_allowed_files)}")
else:
  trace_lines.append("- 样式允许文件: 未声明（建议补充）")
if phase4_status == "pending" or phase5_status == "pending":
  trace_lines.append("- 自我审查与验收阶段尚未全部执行，质量结论为部分完成")
else:
  trace_lines.append("- 自我审查与验收阶段已执行，详见 phase4/phase5 报告")
trace_lines.append(f"- 生成就绪状态: {'ready' if scorecard['readiness']['ready_for_generation'] else 'not-ready'}（见 self-eval.scorecard.json）")
trace_lines.append("")
trace_lines.append("## 5. 下一步")
for idx, name in enumerate(next_skills, start=1):
  trace_lines.append(f"{idx}. {name}")

with open(os.environ["DECISION_TRACE_PATH"], "w", encoding="utf-8") as f:
  f.write("\n".join(trace_lines) + "\n")

lines = []
lines.append("# Fullflow Pipeline Report")
lines.append("")
lines.append("## 0. 输入概览")
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
lines.append(f"- auto_complete: {flow.get('auto_complete')}")
lines.append(f"- refactor_threshold: {flow.get('refactor_threshold')}")
lines.append(f"- render_threshold: {flow.get('render_threshold')}")
lines.append(f"- duplicate_threshold: {flow.get('duplicate_threshold')}")
lines.append(f"- props_depth_threshold: {flow.get('props_depth_threshold')}")
lines.append(f"- acceptance_level: {flow.get('acceptance_level')}")
lines.append(f"- workspace_root: {os.environ.get('WORKSPACE_ROOT', '')}")
lines.append(f"- workspace_baseline: {os.environ.get('WORKSPACE_BASELINE', 'N/A')}")
lines.append(f"- requirement_questions: {req.get('question_count', 0)}")
lines.append(f"- requirement_completeness: {req.get('completeness_score', 'N/A')}/100")
lines.append(f"- design_score_5: {design_score_5}/5")
lines.append(f"- must_pass_gate: {must_pass_gate}")
lines.append("")

lines.append("## 1. 样式改动边界（style-scope-guard，可选）")
lines.append(f"- style_scope_required: {style_scope_required}")
lines.append(f"- scope_locked: {scope.get('scope_locked')}")
lines.append(f"- style_target: {scope.get('style_target') or 'N/A'}")
allowed_files = scope.get("allowed_files") or []
lines.append(f"- allowed_files: {', '.join(allowed_files) if allowed_files else 'none'}")
lines.append("")

if icon_enabled:
  lines.append("## 2. 图标系统（svg-canvas-icon-engine）")
  lines.append(f"- need_confidence: {icon_analysis.get('confidence', 'N/A')}")
  lines.append(f"- rationale: {icon_analysis.get('rationale', '')}")
  lines.append(f"- engine: {icon_manifest.get('engine', 'svg')}")
  lines.append(f"- style: {icon_manifest.get('style', 'outline')}")
  lines.append(f"- categories: {', '.join(icon_manifest.get('categories', [])) or 'none'}")
  lines.append(f"- icon_count: {icon_manifest.get('icon_count', 0)}")
  lines.append("")

section_idx = 3 if icon_enabled else 2
lines.append(f"## {section_idx}. 选型推荐（ui-selector-pro）")
for item in top:
  lib = item.get("library", {})
  lines.append(f"- {lib.get('name', 'N/A')}: {item.get('score', 0):.1f} 分 ({' / '.join(item.get('reasons', []))})")
lines.append("")

section_idx += 1
lines.append(f"## {section_idx}. 候选评估（ui-selector-pro evaluate）")
for idx, row in enumerate(eva.get("result", []), start=1):
  lines.append(f"{idx}. {row.get('library', {}).get('name', 'N/A')}: {row.get('totalScore', 0):.1f}/100")
lines.append("")

section_idx += 1
lines.append(f"## {section_idx}. 审美诊断（ui-aesthetic-coach）")
lines.append(f"- total_score: {score.get('total_score', 0)}")
lines.append(f"- band: {score.get('band', '')}")
lines.append(f"- recommended_direction: {os.environ.get('DIRECTION', '')}")
lines.append("- top_issues:")
for issue in issues:
  lines.append(f"  - {issue.get('label', '')}: {issue.get('improve', '')}")
lines.append("")

section_idx += 1
lines.append(f"## {section_idx}. 量化评估看板")
lines.append(f"- requirements_gate(>=70): {scorecard['gates']['requirements_gate']}")
lines.append(f"- design_gate(>=4.0/5): {scorecard['gates']['design_gate']}")
lines.append(f"- style_scope_gate: {scorecard['gates']['style_scope_gate']}")
lines.append(f"- icon_gate: {scorecard['gates']['icon_gate']}")
lines.append(f"- must_pass_gate: {scorecard['gates']['must_pass_gate']}")
lines.append(f"- ready_for_generation: {scorecard['readiness']['ready_for_generation']}")
lines.append(f"- ready_for_delivery: {scorecard['readiness']['ready_for_delivery']}")
lines.append("")

section_idx += 1
lines.append(f"## {section_idx}. 设计令牌与产物")
lines.append(f"- requirements_prd: {os.path.basename(os.environ['REQ_PRD_PATH'])}")
lines.append(f"- requirements_questions: {os.path.basename(os.environ['REQ_QUESTIONS_PATH'])}")
lines.append(f"- style_profile: {os.path.basename(os.environ['STYLE_PROFILE_PATH'])}")
lines.append(f"- style_scope_lock: {os.path.basename(os.environ['STYLE_SCOPE_LOCK_PATH'])}")
lines.append(f"- style_scope_checklist: {os.path.basename(os.environ['STYLE_SCOPE_CHECKLIST_PATH'])}")
lines.append(f"- style_scope_validation: {os.path.basename(os.environ['STYLE_SCOPE_VALIDATION_PATH'])}")
lines.append(f"- icon_need_analysis: {os.path.basename(os.environ['ICON_ANALYSIS_PATH'])}")
if icon_enabled:
  lines.append(f"- icon_manifest: {os.path.basename(os.environ['ICON_MANIFEST_PATH'])}")
  lines.append(f"- icon_spec: {os.path.basename(os.environ['ICON_SPEC_PATH'])}")
  lines.append(f"- icon_sprite: {os.path.basename(os.environ['ICON_SPRITE_PATH'])}")
  lines.append(f"- canvas_icon_demo: {os.path.basename(os.environ['ICON_CANVAS_DEMO_PATH'])}")
lines.append(f"- tokens_json: {os.path.basename(os.environ['TOKENS_JSON_PATH'])}")
lines.append(f"- tokens_css: {os.path.basename(os.environ['TOKENS_CSS_PATH'])}")
lines.append(f"- framework_adapter_manifest: {os.path.basename(os.environ['ADAPTER_MANIFEST_PATH'])}")
lines.append(f"- flow_metrics: {os.path.basename(os.environ['FLOW_METRICS_PATH'])}")
lines.append(f"- plugin_phase4_hooks: {os.path.basename(os.environ['PLUGIN_PHASE4_HOOKS_PATH'])}")
lines.append(f"- plugin_phase5_hooks: {os.path.basename(os.environ['PLUGIN_PHASE5_HOOKS_PATH'])}")
lines.append(f"- stage_status: {os.path.basename(os.environ['STAGE_STATUS_PATH'])}")
lines.append(f"- phase4_report: {os.path.basename(os.environ['PHASE4_REPORT_PATH'])}")
lines.append(f"- phase5_report: {os.path.basename(os.environ['PHASE5_REPORT_PATH'])}")
lines.append(f"- quality_gates: {os.path.basename(os.environ['QUALITY_GATES_PATH'])}")
lines.append(f"- self_eval_scorecard: {os.path.basename(os.environ['SCORECARD_PATH'])}")
lines.append(f"- gate_validation: {os.path.basename(os.environ['GATE_VALIDATION_PATH'])}")
lines.append(f"- flow_state: {os.path.basename(os.environ['FLOW_STATE_PATH'])}")
lines.append(f"- state_machine_validation: {os.path.basename(os.environ['STATE_MACHINE_VALIDATION_PATH'])}")
lines.append(f"- optimization_plan: {os.path.basename(os.environ['OPTIMIZATION_PLAN_PATH'])}")
lines.append(f"- decision_trace: {os.path.basename(os.environ['DECISION_TRACE_PATH'])}")
lines.append("")

section_idx += 1
lines.append(f"## {section_idx}. 生命周期状态")
for row in stage_status:
  lines.append(f"- {row['name']}: {row['status']} ({row['evidence']})")
lines.append("")

section_idx += 1
lines.append(f"## {section_idx}. 必过技能状态（固定9项）")
for row in must_pass_status:
  lines.append(f"- {row['skill']}: {row['status']} ({row['mode']}, {row['evidence']})")
lines.append(f"- must_pass_gate: {must_pass_gate}")
lines.append("")

section_idx += 1
lines.append(f"## {section_idx}. 下一步执行链路")
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
  "must_pass_status": must_pass_status,
  "must_pass_gate": must_pass_gate,
  "artifacts": (
    [
      "flow.input.json",
      os.path.basename(os.environ["REQ_SUMMARY_PATH"]),
      os.path.basename(os.environ["STYLE_SCOPE_LOCK_PATH"]),
      os.path.basename(os.environ["STYLE_SCOPE_CHECKLIST_PATH"]),
      os.path.basename(os.environ["STYLE_SCOPE_VALIDATION_PATH"]),
      os.path.basename(os.environ["ICON_ANALYSIS_PATH"]),
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
      os.path.basename(os.environ["ADAPTER_MANIFEST_PATH"]),
      os.path.basename(os.environ["FLOW_METRICS_PATH"]),
      os.path.basename(os.environ["PLUGIN_PHASE4_HOOKS_PATH"]),
      os.path.basename(os.environ["PLUGIN_PHASE5_HOOKS_PATH"]),
      os.path.basename(os.environ["STAGE_STATUS_PATH"]),
      os.path.basename(os.environ["PHASE4_REPORT_PATH"]),
      os.path.basename(os.environ["PHASE5_REPORT_PATH"]),
      os.path.basename(os.environ["QUALITY_GATES_PATH"]),
      os.path.basename(os.environ["GATE_VALIDATION_PATH"]),
      os.path.basename(os.environ["FLOW_STATE_PATH"]),
      os.path.basename(os.environ["STATE_MACHINE_VALIDATION_PATH"]),
      os.path.basename(os.environ["SCORECARD_PATH"]),
      os.path.basename(os.environ["OPTIMIZATION_PLAN_PATH"]),
      os.path.basename(os.environ["DECISION_TRACE_PATH"]),
      "CHANGELOG.md",
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

STATE_MACHINE_VALIDATION_FAILED="0"
(
  cd "$REPO_ROOT"
  python3 skills/ui-fullflow-orchestrator/scripts/validate_state_machine.py \
    --state-file "$FLOW_STATE_PATH" \
    --rules-file "$STATE_MACHINE_RULES_PATH" \
    --stage-status "$STAGE_STATUS_PATH" \
    --report "$STATE_MACHINE_VALIDATION_PATH" >/dev/null
) || STATE_MACHINE_VALIDATION_FAILED="1"

python3 - <<'PY' "$FLOW_STATE_PATH" "$STATE_MACHINE_VALIDATION_PATH" "$STATE_MACHINE_VALIDATION_FAILED"
import json
import sys
state_path = sys.argv[1]
validation_path = sys.argv[2]
failed = sys.argv[3] == "1"

with open(state_path, "r", encoding="utf-8") as f:
    state = json.load(f)

validation = {}
try:
    with open(validation_path, "r", encoding="utf-8") as f:
        validation = json.load(f)
except Exception:
    validation = {"overall_valid": False, "issues": ["state_machine.validation.json 不可读取"]}

state["state_machine_validation"] = {
    "overall_valid": bool(validation.get("overall_valid", False)),
    "report": validation_path.split("/")[-1],
    "issues_count": len(validation.get("issues", [])),
}
if failed or not validation.get("overall_valid", False):
    blockers = list(state.get("blockers") or [])
    blockers.append("state_machine_validation 未通过")
    state["blockers"] = blockers
    warnings = list(state.get("warnings") or [])
    warnings.extend(validation.get("issues") or ["state_machine_validation 未通过"])
    state["warnings"] = warnings
    state["current_phase"] = "failed"

with open(state_path, "w", encoding="utf-8") as f:
    json.dump(state, f, ensure_ascii=False, indent=2)
    f.write("\n")
PY

GATE_VALIDATE_POST_START_MS="$(now_ms)"
(
  cd "$REPO_ROOT"
  python3 skills/quality-gate-validator/scripts/validate_gates.py \
    --out-dir "$OUT_DIR" \
    --workspace-root "$WORKSPACE_ROOT" \
    --repo-root "$REPO_ROOT" \
    --report "$GATE_VALIDATION_PATH" \
    --tool-checks auto >/dev/null || true
)
GATE_VALIDATE_POST_DURATION_MS="$(( $(now_ms) - GATE_VALIDATE_POST_START_MS ))"

FINAL_SNAPSHOT_LABEL="after-feedback"
if [[ "$AUTO_COMPLETE" == "1" && "$PHASE5_STATUS" == "completed" ]]; then
  FINAL_SNAPSHOT_LABEL="final"
fi
VERSION_NAME="$(
  cd "$REPO_ROOT"
  python3 skills/ui-fullflow-orchestrator/scripts/snapshot_artifacts.py \
    --out-dir "$OUT_DIR" \
    --label "$FINAL_SNAPSHOT_LABEL"
)"
if [[ "$(dirname "$OUT_DIR")" == "$WORKSPACE_ROOT/Ruiagents" ]]; then
  ln -sfn "$(basename "$OUT_DIR")" "$WORKSPACE_ROOT/Ruiagents/current"
fi

echo "fullflow complete"
echo "workspace_root: $WORKSPACE_ROOT"
echo "output: $OUT_DIR"
echo "style_scope_lock: $STYLE_SCOPE_LOCK_PATH"
if [[ "$ICON_ENABLED" == "1" ]]; then
  echo "icon_manifest: $ICON_MANIFEST_PATH"
fi
echo "stage_status: $STAGE_STATUS_PATH"
echo "phase4_report: $PHASE4_REPORT_PATH"
echo "phase5_report: $PHASE5_REPORT_PATH"
echo "quality_gates: $QUALITY_GATES_PATH"
echo "gate_validation: $GATE_VALIDATION_PATH"
echo "state_machine_validation: $STATE_MACHINE_VALIDATION_PATH"
echo "flow_metrics: $FLOW_METRICS_PATH"
echo "style_scope_validation: $STYLE_SCOPE_VALIDATION_PATH"
echo "icon_analysis: $ICON_ANALYSIS_PATH"
echo "plugin_phase4_hooks: $PLUGIN_PHASE4_HOOKS_PATH"
echo "plugin_phase5_hooks: $PLUGIN_PHASE5_HOOKS_PATH"
echo "artifact_changelog: $OUT_DIR/CHANGELOG.md"
echo "artifact_version_initial: $INITIAL_VERSION_NAME"
echo "artifact_version: $VERSION_NAME"
echo "flow_state: $FLOW_STATE_PATH"
echo "scorecard: $SCORECARD_PATH"
echo "optimization_plan: $OPTIMIZATION_PLAN_PATH"
echo "decision_trace: $DECISION_TRACE_PATH"
echo "report: $REPORT_PATH"
