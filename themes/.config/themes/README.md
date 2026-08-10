# Themes

Each directory here is one theme, and a theme is exactly one file: `colors.conf`,
holding ten shell variables in `#RRGGBB` form.

```sh
BG="#0f1115"
SURFACE="#1c1f26"
SURFACE_ALT="#0f1115"   # optional, defaults to SURFACE
TEXT="#e8e8ed"
TEXT_MUTED="#a1a1aa"
ACCENT="#0a84ff"
ACCENT_ALT="#64d2ff"    # optional, defaults to ACCENT
WARN="#ffc934"
ERROR="#ff453a"
SUCCESS="#34c759"
```

Nothing else in a theme directory is read. There are no per-component files:
`scripts/theme-switch.sh` generates the Hyprland, Waybar, Rofi, Ghostty, SwayNC
and Starship colour files from these ten values.

Values must be `#RRGGBB`. Hyprland's `0xffRRGGBB` form is produced by the
switcher, so do not write `0x` here.

## Adding a theme

```sh
mkdir -p ~/dotfiles/themes/.config/themes/<name>
$EDITOR ~/dotfiles/themes/.config/themes/<name>/colors.conf   # the ten vars above
ts set <name>
```

## Usage

```sh
ts list              # list themes
ts current           # show the active theme
ts set macos-dark    # apply a theme
```

Full behaviour, generated file locations and known gaps:
[docs/theme-switching.md](../../../docs/theme-switching.md).
