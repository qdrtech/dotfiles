# Theme Switching

How the palette-first theme switcher works and how to use it.

## Components
- Script: `scripts/theme-switch.sh`
- Themes live in: `themes/<name>/colors.conf`
- Active link: `~/.config/themes/current` (symlink to the selected theme)
- Generated outputs:
  - `~/.config/themes/colors.conf` (symlink back to the active palette)
  - `~/.config/themes/current.txt` (record of the active theme name)
  - `~/.config/hypr/theme-colors.conf`
  - `~/.config/waybar/theme-colors.css`
  - `~/.config/rofi/theme-colors.rasi` + `~/.config/rofi/generated-theme.rasi`
  - `~/.config/ghostty/theme.conf`

Make sure your app configs import those generated files (e.g., Hyprland `source = ~/.config/hypr/theme-colors.conf`, Waybar `@import "theme-colors.css";`, etc.).

## Palette format
Each theme directory only needs a `colors.conf` with shell variables:
```sh
BG="#1e1e2e"
SURFACE="#313244"
SURFACE_ALT="#313244"   # optional, defaults to SURFACE
TEXT="#cdd6f4"
TEXT_MUTED="#a6adc8"
ACCENT="#89b4fa"
ACCENT_ALT="#89dceb"    # optional, defaults to ACCENT
WARN="#f9e2af"
ERROR="#f38ba8"
SUCCESS="#a6e3a1"
```
Missing keys fall back to sensible defaults inside the script.

## Usage
From the repo root:
```sh
./scripts/theme-switch.sh list        # list available themes
./scripts/theme-switch.sh current     # show active theme
./scripts/theme-switch.sh set <name>  # switch theme and reload Hyprland
```
- Add `--no-reload` to skip the Hyprland reload.
- Set `NO_HYPR_RELOAD=1` to disable reloads globally.
- Override theme location with `THEMES_DIR=/path/to/themes ./scripts/theme-switch.sh set <name>`.

## What `set` does
1) Validates the theme exists and links it to `~/.config/themes/current`.
2) Ensures `colors.conf` is linked to `~/.config/themes/colors.conf`.
3) Renders per-app color files listed above.
4) Writes the active theme name to `~/.config/themes/current.txt`.
5) Reloads Hyprland (if available) unless told not to.
