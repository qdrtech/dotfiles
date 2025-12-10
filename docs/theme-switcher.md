# Theme Switching Notes

## Current approach (palette-first)
- Each theme directory only carries a `colors.conf` with semantic keys (`BG`, `SURFACE`, `SURFACE_ALT`, `TEXT`, `TEXT_MUTED`, `ACCENT`, `ACCENT_ALT`, `WARN`, `ERROR`, `SUCCESS`).
- `scripts/theme-switch.sh` links the chosen theme to `~/.config/themes/current` and renders per-app color includes:
  - `~/.config/themes/colors.conf` (symlink to active palette)
  - `~/.config/hypr/theme.conf` (colors only; source in your Hypr config)
  - `~/.config/waybar/theme-colors.css` (CSS variables; import in Waybar style)
  - `~/.config/rofi/theme-colors.rasi` (variables; import in Rofi theme)
  - `~/.config/ghostty/theme.conf` (background/foreground/palette)
- Sample palettes: `themes/catppuccin-mocha/colors.conf`, `themes/macos-dark/colors.conf`.
- Override theme location with `THEMES_DIR=/path/to/themes ./scripts/theme-switch.sh set …` if you keep themes elsewhere.

## Hooking it into your configs
- Hyprland: source the generated palette early (e.g., `source = ~/.config/hypr/theme-colors.conf`) so `$accent`, `$bg`, etc. are available. Repo provides `hyprland/.config/hypr/hyprland.conf` with that include plus `conf/theme.conf` wired to use the palette. Palette file only sets variables—styling stays in `conf/theme.conf`.
- Waybar: add `@import url("theme-colors.css");` near the top of your style (generated file lives alongside it). Repo provides `waybar/.config/waybar/style.css` wired to the generated colors—restow to refresh the symlink.
- Rofi: add `@theme "theme-colors.rasi"` in your base theme. Repo provides `rofi/.config/rofi/config.rasi` already importing it—restow to refresh the symlink.
- Ghostty: add `include=~/.config/ghostty/theme.conf` to your `~/.config/ghostty/config`. Repo provides `ghostty/config` with the include—restow to refresh the symlink.

Repo defaults (symlink or copy to `~/.config/...` as you prefer):
- Hyprland entrypoint: `hyprland/hyprland.conf`
- Waybar style: `waybar/.config/waybar/style.css`
- Rofi config: `rofi/config.rasi`
- Ghostty config: `ghostty/config`

## Usage
- List themes: `./scripts/theme-switch.sh list`
- Show current theme: `./scripts/theme-switch.sh current`
- Switch theme (reloads Hyprland): `./scripts/theme-switch.sh set catppuccin-mocha`
- Skip reload if needed: `./scripts/theme-switch.sh set --no-reload catppuccin-mocha`
- Themes are symlinked to `~/.config/themes/current`; the selected name is recorded at `~/.config/themes/current.txt`.

## Next steps to flesh it out
- Wire Hyprland/Waybar/Rofi/Ghostty configs in this repo to import the generated color files.
- Extend apply logic for wallpapers (`swww`), cursors, GTK/Qt themes, terminals, swaync/wofi, and add a Rofi selector menu.
- Add a light variant and day/night auto-switching once base configs are present.
