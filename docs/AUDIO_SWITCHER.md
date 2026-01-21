Audio Switcher
================

This repository includes a simple audio output switcher script that cycles through a user-defined ordered list of sinks and sets the system default sink.

Files added
- `bin/audio-switcher`: the switcher script (Python 3). Make executable with `chmod +x bin/audio-switcher`.
- `config/order.txt`: sample whitelist (matches substrings in sink names).

Quick start

1. Make the script executable:

```bash
chmod +x bin/audio-switcher
```

2. (Optional) Copy the sample whitelist to your user config and edit order:

```bash
mkdir -p ~/.config/audio-switcher
cp config/order.txt ~/.config/audio-switcher/order.txt
# Edit ~/.config/audio-switcher/order.txt and replace/add lines to match your devices
```

3. Dry-run to see what would happen:

```bash
bin/audio-switcher --dry-run
```

4. Run to actually switch:

```bash
bin/audio-switcher
```

Keybinding (GNOME / Wayland)

Open Settings → Keyboard → Custom Shortcuts and add a new shortcut:
- Name: Cycle audio output
- Command: /home/USERNAME/Documents/ubuntu-audio-output-switcher/bin/audio-switcher
- Shortcut: assign the key you want

Replace `USERNAME` with your login. Alternatively use `gsettings` to add the shortcut.

Notes and behavior
- The script matches whitelist entries against the sink `NAME` reported by `pactl list short sinks`.
- If no whitelist matches are found, it will cycle through all available sinks.
- It sets the default sink and attempts to move existing sink-inputs to the new sink.
- The script uses a lock at `/tmp/audio-switcher.lock` to avoid races from concurrent invocations.
