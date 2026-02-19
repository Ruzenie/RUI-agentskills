#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../../.." && pwd)"
VALIDATOR_PATH="$REPO_ROOT/skills/style-scope-guard/scripts/validate_scope_change.py"

usage() {
  cat <<'USAGE'
install_precommit_hook.sh

Usage:
  bash skills/style-scope-guard/scripts/install_precommit_hook.sh --workspace-root /path/to/workspace
USAGE
}

WORKSPACE_ROOT=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --workspace-root) WORKSPACE_ROOT="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown arg: $1" >&2; usage; exit 1 ;;
  esac
done

if [[ -z "$WORKSPACE_ROOT" ]]; then
  usage
  exit 1
fi

if ! git -C "$WORKSPACE_ROOT" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Error: workspace 不是 git 仓库: $WORKSPACE_ROOT" >&2
  exit 1
fi

HOOK_PATH="$WORKSPACE_ROOT/.git/hooks/pre-commit"
mkdir -p "$(dirname "$HOOK_PATH")"

cat > "$HOOK_PATH" <<'HOOK'
#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(git rev-parse --show-toplevel)"
LATEST_LOCK="$(find "$ROOT_DIR/Ruiagents" -type f -name 'style.scope.lock.json' 2>/dev/null | sort | tail -n1 || true)"
if [[ -z "$LATEST_LOCK" ]]; then
  exit 0
fi

CHANGED="$(git diff --cached --name-only | paste -sd, -)"
python3 "__VALIDATOR_PATH__" \
  --lock-file "$LATEST_LOCK" \
  --changed-files "$CHANGED" \
  --workspace-root "$ROOT_DIR" >/dev/null
HOOK
sed -i "s#__VALIDATOR_PATH__#$VALIDATOR_PATH#g" "$HOOK_PATH"

chmod +x "$HOOK_PATH"
echo "installed: $HOOK_PATH"
