#!/bin/sh
set -eu
app="$HOME/.local/share/DSH-CachyOs-local-build/deepseek-harness"
node="$app/apps/desktop/.desktop-build/targets/linux-x64/runtime/primary-runtime/dependencies/node/bin/node"
export PATH="$(dirname "$node"):$app/node_modules/.bin:$PATH"
export npm_config_verify_deps_before_run=false
export DSH_HOME="${DSH_HOME:-$HOME/.local/share/deepseek-harness-data}"
export DSH_DESKTOP_USER_DATA_DIR="${DSH_DESKTOP_USER_DATA_DIR:-$HOME/.config/deepseek-harness-desktop}"
export DSH_DESKTOP_OPEN_DEVTOOLS=0
unset ELECTRON_RUN_AS_NODE
mkdir -p "$HOME/.local/state"
exec "$node" "$app/node_modules/pnpm/bin/pnpm.cjs" --dir "$app" run start:desktop >> "$HOME/.local/state/deepseek-harness.log" 2>&1
