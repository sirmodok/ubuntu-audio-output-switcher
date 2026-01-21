#!/usr/bin/env bash
set -euo pipefail

# Installer for ubuntu-audio-output-switcher
# Installs the `audio-switcher` script into ~/.local/bin and copies sample config
# Optional: create a GNOME custom shortcut with --bind '<Primary><Alt>a'

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="$REPO_DIR/bin/audio-switcher"
DEST="$HOME/.local/bin/audio-switcher"
CONFIG_DIR="$HOME/.config/audio-switcher"
SAMPLE_CONFIG="$REPO_DIR/config/order.txt"

usage(){
  cat <<EOF
Usage: $0 [--bind '<Binding>']

Installs audio-switcher to ~/.local/bin and copies sample config to ~/.config/audio-switcher/order.txt

Options:
  --bind '<Binding>'   Create a GNOME custom shortcut bound to the given keybinding (e.g. '<Primary><Alt>a')
  --help               Show this help
EOF
}

BINDING=""
while [[ ${#@} -gt 0 ]]; do
  case "$1" in
    --bind)
      shift
      BINDING="$1"
      shift
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      echo "Unknown arg: $1" >&2
      usage
      exit 1
      ;;
  esac
done

if [[ ! -x "$SRC" ]]; then
  echo "Source script not found or not executable: $SRC" >&2
  echo "Make sure you're running this from the repository and have run: chmod +x bin/audio-switcher" >&2
  exit 1
fi

mkdir -p "$HOME/.local/bin"
cp "$SRC" "$DEST"
chmod +x "$DEST"
echo "Installed $DEST"

mkdir -p "$CONFIG_DIR"
if [[ ! -f "$CONFIG_DIR/order.txt" && -f "$SAMPLE_CONFIG" ]]; then
  cp "$SAMPLE_CONFIG" "$CONFIG_DIR/order.txt"
  echo "Copied sample config to $CONFIG_DIR/order.txt"
else
  echo "Config already exists at $CONFIG_DIR/order.txt or sample missing"
fi

if [[ -n "$BINDING" ]]; then
  echo "Creating GNOME custom shortcut with binding $BINDING"
  SCHEMA=org.gnome.settings-daemon.plugins.media-keys
  CK_KEY=custom-keybindings
  existing=$(gsettings get $SCHEMA $CK_KEY || echo "@as []")
  # find next index
  i=0
  while echo "$existing" | grep -q "custom$i/"; do i=$((i+1)); done
  path="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom$i/"

  if [[ "$existing" = "@as []" || "$existing" = "[]" ]]; then
    new="['$path']"
  else
    # Append new path before the final ] in a robust, sed-free way
    # Remove the trailing ']' then append the new entry
    base="${existing%]}"
    # If base already ends with a comma, just append the entry; otherwise add a comma
    case "$base" in
      *",")
        new="$base '$path']"
        ;;
      *)
        new="$base, '$path']"
        ;;
    esac
  fi

  gsettings set $SCHEMA $CK_KEY "$new"
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$path name 'Cycle audio output'
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$path command "$DEST"
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$path binding "$BINDING"

  echo "Custom shortcut created. Listing custom-keybindings:"
  gsettings get $SCHEMA $CK_KEY
fi

echo "Done. You can now run: $DEST"
