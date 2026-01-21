# ubuntu-audio-output-switcher

This repository provides a small utility to cycle audio outputs (sinks) using `pactl`.

Files added
- `bin/audio-switcher` — the switcher script (Python 3)
- `bin/install.sh` — installer for user setup (installs to `~/.local/bin`)
- `config/order.txt` — sample whitelist of devices to cycle in order
- `docs/AUDIO_SWITCHER.md` — usage and keybinding notes

Installer
---------

A helper installer script is provided at `bin/install.sh`. It copies the `audio-switcher` script
to `~/.local/bin`, copies a sample whitelist to `~/.config/audio-switcher/order.txt` (if missing),
and can optionally create a GNOME custom shortcut.

Quick install:

```bash
chmod +x bin/audio-switcher bin/install.sh
bin/install.sh
# Optional: create GNOME shortcut (replace binding):
bin/install.sh --bind '<Primary><Alt>a'
```

After install, bind a keyboard shortcut to `~/.local/bin/audio-switcher` if you didn't use `--bind`.

Documentation
-------------

See `docs/AUDIO_SWITCHER.md` for more details and keybinding instructions.

License
-------

See LICENSE in the repository root.
# ubuntu-audio-output-switcher