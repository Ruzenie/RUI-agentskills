#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
WORKSPACE_ROOT="$(cd "$ROOT_DIR/.." && pwd)"

BUNDLES=(
  "RUI-codex-cn"
  "RUI-codex-en"
  "RUI-claude-cn"
  "RUI-claude-en"
)

for b in "${BUNDLES[@]}"; do
  bash -n \
    "$ROOT_DIR/$b/skills/ui-fullflow-orchestrator/scripts/run_fullflow_pipeline.sh" \
    "$ROOT_DIR/$b/skills/ui-fullflow-orchestrator/scripts/run_phase4_refactor.sh" \
    "$ROOT_DIR/$b/skills/ui-fullflow-orchestrator/scripts/run_phase5_acceptance.sh" \
    "$ROOT_DIR/$b/skills/ui-fullflow-orchestrator/scripts/flow_status.sh"

  python3 -m py_compile \
    "$ROOT_DIR/$b/skills/ui-fullflow-orchestrator/scripts/run_plugin_hooks.py" \
    "$ROOT_DIR/$b/skills/ui-fullflow-orchestrator/scripts/validate_state_machine.py" \
    "$ROOT_DIR/$b/skills/framework-adapters/scripts/select_adapter.py" \
    "$ROOT_DIR/$b/skills/quality-gate-validator/scripts/validate_gates.py" \
    "$ROOT_DIR/$b/skills/style-scope-guard/scripts/validate_scope_change.py"
done

OUT_DIR="$WORKSPACE_ROOT/Ruiagents/integration-smoke-$(date +%Y%m%d-%H%M%S)"
bash "$ROOT_DIR/RUI-codex-cn/skills/ui-fullflow-orchestrator/scripts/run_fullflow_pipeline.sh" \
  --brief "集成测试：验证全流程状态机与门禁实测" \
  --framework react \
  --project-type saas-modern \
  --style-target "hero 区域" \
  --scope-file "src/pages/home.tsx" \
  --priority performance \
  --auto-complete \
  --workspace-root "$WORKSPACE_ROOT" \
  --out-dir "$OUT_DIR" >/dev/null

python3 "$ROOT_DIR/tests/integration/assert_fullflow_artifacts.py" "$OUT_DIR"

bash "$ROOT_DIR/RUI-codex-cn/skills/ui-fullflow-orchestrator/scripts/flow_status.sh" \
  --workflow-dir "$OUT_DIR" --format table >/dev/null
bash "$ROOT_DIR/RUI-codex-cn/skills/ui-fullflow-orchestrator/scripts/flow_status.sh" \
  --workflow-dir "$OUT_DIR" --format markdown >/dev/null

echo "smoke suite passed: $OUT_DIR"
