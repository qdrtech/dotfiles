# Theme switching

**Status: broken and half-migrated. Read this before running either switcher.**

There are two theme switchers in this repo. They use incompatible theme formats
and write to different places. Neither one applies a theme correctly against the
themes that are actually committed here. This document describes what is true
today, not what was intended.

## The two switchers

| | `scripts/theme-switch.sh` | `config/.config/scripts/theme-switch.sh` |
| --- | --- | --- |
| Style | palette-first: generates colour files from ~10 variables | file-first: symlinks or copies whole per-component files |
| Theme format | `BG`, `SURFACE`, `TEXT`, `ACCENT`, … | `THEME_BG_WINDOW`, `THEME_ACCENT_BLUE`, … |
| Covers | Hyprland, Waybar, Rofi, Ghostty | Hyprland, Waybar, Rofi, Ghostty, SwayNC, Starship |
| Reached via | run from the repo | the `ts` alias (`zshrc/.zshrc:21`) |
| Themes dir | `$DOTFILES_ROOT/themes` | `~/.config/themes` |

The committed themes in `themes/.config/themes/` are all in the **second**
format, and so is the one design spec that names variables at all
(`docs/macos-theme-spec.md:659,1019`). The top-level `README` describes neither
format in detail — it notes that both switchers exist and defers here.

## What actually happens

### `scripts/theme-switch.sh` — palette-first

```
Usage: theme-switch.sh <command> [args]

Commands:
  list                     List available themes
  current                  Show the currently linked theme
  set [--no-reload] <name> Switch to the specified theme (reload Hyprland unless --no-reload)
  help                     Show this help message

Environment overrides:
  THEMES_DIR           Path to themes directory (default: repo/themes)
```

Writes:

- `~/.config/themes/current` — symlink to the chosen theme directory
- `~/.config/themes/colors.conf` — symlink to the active palette
- `~/.config/themes/current.txt` — the active theme name
- `~/.config/hypr/theme-colors.conf`
- `~/.config/waybar/theme-colors.css`
- `~/.config/rofi/theme-colors.rasi` and `~/.config/rofi/generated-theme.rasi`
- `~/.config/ghostty/theme.conf`

Expected palette format — a `colors.conf` of plain shell assignments:

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

**Confirmed defects:**

1. **`list` prints nothing.** It scans `$DOTFILES_ROOT/themes`, but the themes
   are two levels deeper at `themes/.config/themes/`, and the `! -name '.*'`
   filter excludes the `.config` directory on the way. Workaround:
   `THEMES_DIR=themes/.config/themes ./scripts/theme-switch.sh list`.

2. **No committed theme is in the palette format.** Every `colors.conf` under
   `themes/.config/themes/` uses `THEME_*` names. Sourcing one sets none of
   `BG`/`SURFACE`/`TEXT`/`ACCENT`, so `load_palette` falls through to its
   hardcoded Catppuccin defaults. The consequence is that `set default` and
   `set macos-dark` produce **byte-identical output** — the theme argument has
   no effect.

3. **Running it would change the live colours.** The generated files currently on
   the reference machine hold a dark macOS-ish palette (`#0f1115`, `#0a84ff`)
   that is not derivable from any `colors.conf` in this repo. The source palette
   could not be located: `~/.config/themes/current` points at
   `/home/qdrtech/dotfiles/themes/macos-dark`, and that path does not exist (the
   committed theme lives at `themes/.config/themes/macos-dark`). Running `set`
   today replaces those colours with the Catppuccin fallback.

4. **`write_atomic` fails on a fresh machine.** It calls
   `mktemp "${dest}.XXXX"` *before* `mkdir -p "$(dirname "$dest")"`, so it
   errors out if `~/.config/hypr`, `~/.config/waybar`, `~/.config/rofi`, or
   `~/.config/ghostty` does not already exist.

5. **`set --no-reload` exits 1 on success.** The last statement is
   `[ "$reload" -eq 1 ] && hypr_reload`, which is false under `--no-reload`, and
   the script has no trailing `exit 0`.

6. **It writes into the repo.** `~/.config/ghostty` and `~/.config/rofi` are
   folded symlinks into this checkout, so `ghostty/.config/ghostty/theme.conf`,
   `rofi/.config/rofi/theme-colors.rasi`, and
   `rofi/.config/rofi/generated-theme.rasi` are generated files that ended up
   tracked in git.

### `config/.config/scripts/theme-switch.sh` — file-first

This is what `ts` runs. Commands: `list`, `current`, `set THEME`, `status`,
`help`. It reads `~/.config/themes/`, records the choice in
`~/.config/theme-preference`, logs to `~/.cache/theme-switch.log`, and for each
component symlinks or copies the theme's own file:

| Component | Action | Destination |
| --- | --- | --- |
| Hyprland | copy `hyprland-style.conf` (falls back to `hyprland.conf`) | `~/.config/hypr/conf/theme.conf` |
| Waybar | symlink `waybar.css` | `~/.config/waybar/style.css` |
| Rofi | symlink `rofi.rasi` | `~/.config/rofi/theme.rasi` |
| SwayNC | symlink `swaync.css` | `~/.config/swaync/style.css` |
| Ghostty | copy `ghostty.conf` | `~/.config/ghostty/theme.conf` |
| Starship | symlink `starship.toml` | `~/.config/starship.toml` |

**Confirmed defects:**

1. **It clobbers tracked files.** `~/.config/hypr/conf` is a symlink into this
   repo, so the Hyprland step overwrites the tracked
   `hyprland/.config/hypr/conf/theme.conf`. The Waybar and Rofi steps repoint
   symlinks away from the repo's own `style.css` and `config.rasi` wiring.
2. **It breaks the generated-colour pipeline.** `waybar/.config/waybar/style.css`
   and `rofi/.config/rofi/config.rasi` as committed consume the palette-first
   switcher's output
   (`@import url("theme-colors.css")`, `@theme ".../generated-theme.rasi"`).
   Replacing them with a theme's own `waybar.css` / `rofi.rasi` drops that.
3. **`setup_base_configs` reads `~/.config/base/waybar/config`**, which is not in
   this repo. That path is a dangling symlink on the reference machine.
4. **`tokyonight` cannot be applied.** It has only `colors.conf`; every component
   step logs a warning and skips.
5. `themes/.config/themes/README.md` documents this switcher. It contradicts this
   file wherever the two disagree; this file is the accurate one.

## Leftovers on the reference machine

These exist because both switchers have been run at different times:

- `~/.config/themes/current -> /home/qdrtech/dotfiles/themes/macos-dark` — dangling.
- `~/.config/themes/colors.conf` — dangling, follows `current`.
- `~/.config/rofi/theme.rasi` and `~/.config/swaync/style.css` — committed
  symlinks with absolute `/home/qdrtech` targets, left by the file-first switcher.
- `~/.config/hypr/theme.conf` — a stray copy at the `hypr` root rather than in
  `conf/`. Nothing sources it; `hyprland/.config/hypr/hyprland.conf:41` sources
  `conf/theme.conf`.

Two more were orphaned by the dead-package removal in commit `5a2c847`:

- `~/.config/hypr/mocha.conf -> ../../dotfiles/hyprmocha/.config/hypr/mocha.conf`
  — now dangling, because the `hyprmocha` package was deleted. Nothing in this
  repo sources `mocha.conf`, so nothing breaks.
- `~/hyprland.conf -> dotfiles/hyprland/hyprland.conf` — now dangling, because
  the stub at the `hyprland` package root was deleted. Nothing sources it. That
  a Hyprland config was ever stowed to `$HOME` rather than `~/.config/hypr` is
  itself the evidence that the stub was dead weight.

Both are safe to delete once this branch is merged:

```sh
rm ~/.config/hypr/mocha.conf ~/hyprland.conf
```

## What has to happen to fix this

Not done in this repo yet. Consolidating onto the palette-first switcher needs,
at minimum:

1. A `BG`/`SURFACE`/`TEXT`/`ACCENT` palette authored for each theme — these are
   design decisions, not a mechanical rename of the `THEME_*` values.
2. SwayNC and Starship handling added to `scripts/theme-switch.sh`, or an
   explicit decision to drop them.
3. The other four of the six defects above fixed (`list` path, `write_atomic`
   ordering, `set` exit code, generated output escaping into the repo). Defects
   2 and 3 are covered by item 1.
4. `ts` in `zshrc/.zshrc:21` repointed, the file-first switcher removed, and
   `themes/.config/themes/README.md` retired.

Until then, do not run either switcher on a working setup.

## Design specs

`docs/macos-theme-spec.md` and `docs/warm-theme-design-spec.md` are aspirational
design documents. They describe intended visual direction. Their implementation
status has not been verified against the configs in this repo — do not read them
as descriptions of current behaviour.
