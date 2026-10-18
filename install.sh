#!/bin/sh
set -eu

archive=$(realpath "${1:?Usage: sh install.sh /path/to/build.tar.zst}")
scripts=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
root="$HOME/.local/share/DSH-CachyOs-local-build"
test "$(uname -m)" = x86_64 || { printf '%s\n' 'This build requires Linux x86_64.' >&2; exit 1; }
test ! -e "$root" || { printf '%s\n' "Already exists: $root; close the app and move this directory before reinstalling." >&2; exit 1; }
test -f "$scripts/launch.sh"
mkdir -p "$root" "$HOME/.local/bin" "$HOME/.local/share/applications"
tar --zstd -xf "$archive" -C "$root"
app="$root/deepseek-harness"
node="$app/apps/desktop/.desktop-build/targets/linux-x64/runtime/primary-runtime/dependencies/node/bin/node"
"$node" "$app/check-linux-launch.mjs"
install -m755 "$scripts/launch.sh" "$HOME/.local/bin/dsh-cachyos"
desktop="$HOME/.local/share/applications/dsh-cachyos.desktop"
printf '%s\n' '[Desktop Entry]' 'Type=Application' 'Name=DeepSeek Harness (CachyOS local build)' \
  "Exec=\"$HOME/.local/bin/dsh-cachyos\"" "Icon=$app/apps/desktop/resources/icon.png" \
  'Terminal=false' 'Categories=Development;' > "$desktop"
if command -v update-desktop-database >/dev/null 2>&1; then
  update-desktop-database "$HOME/.local/share/applications"
fi
printf '%s\n' "Installed. Launch: $HOME/.local/bin/dsh-cachyos"
