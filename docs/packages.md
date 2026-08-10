# Packages

One section per stow package. "Target" is where the package lands when stowed
with `-t "$HOME"` from a clone at `~/dotfiles`.

`scripts/` and `docs/` are **not** stow packages. `scripts/theme-switch.sh` is
run from the repo, not from `$HOME`.

---

## `config`

**Target:** `~/.config/scripts`, `~/.config/settings`, `~/.config/cache`

Shared helpers that are not tied to one program.

| File | What it does |
| --- | --- |
| `scripts/term-startup.sh` | Runs `figlet qdrtech` then `fastfetch`. Called from `.zshrc:10`. |
| `scripts/import-gsettings.sh` | Reads `gtk-3.0/settings.ini` and pushes theme/icon/cursor/font into `org.gnome.desktop.interface` via `gsettings`. Run on login from `hypr/conf/autostart.conf:11`. |
| `scripts/git-prune.sh` | `git fetch --prune`, then interactively deletes local branches whose upstream is gone. Aliased to `gitprune`. |
| `scripts/docker-login-ecr.sh` | Work-specific AWS ECR login. Aliased to `dle`. Not generally useful. |
| `scripts/wal` | A vendored copy of the pywal shell script (`wal`) by Dylan Araps. Requires ImageMagick's `convert`. |
| `scripts/theme-switch.sh` | The **older** theme switcher. See [theme-switching.md](theme-switching.md). |
| `settings/rofi-border.rasi`, `rofi-border-radius.rasi`, `rofi-font.rasi` | One-line rofi settings fragments. Nothing in this repo imports them. |
| `cache/blurred_wallpaper.png` | Lock screen background. Read by `hypr/hyprlock.conf:15`. |
| `cache/current_wallpaper`, `cache/current_wallpaper.rasi` | Wallpaper path record and a rofi snippet that points at `blurred_wallpaper.png`. |

`~/.config/scripts` is on `PATH` (`.zshrc:42`).

Note: `~/.config/base` exists on the reference machine as a dangling symlink to
`config/.config/base`, which is not in this repo. Only the older theme switcher
referenced it.

---

## `ghostty`

**Target:** `~/.config/ghostty`

| File | What it does |
| --- | --- |
| `config` | Ghostty settings: `.SF NS Mono` at 14pt, ligatures, 10px horizontal padding, `background-blur-radius = 20`, `background-opacity = 0.2`, GTK titlebar, sudo shell integration. |
| `theme.conf` | **Generated**, not authored. Written by `scripts/theme-switch.sh`. It is committed because `~/.config/ghostty` is a folded symlink into this repo, so the switcher writes straight into the working tree. |

`config` does **not** `include` `theme.conf`. As committed, Ghostty never reads
the generated colours.

---

## `gtk-3.0`

**Target:** `~/.config/gtk-3.0/settings.ini`

Requests the `Tokyonight-Dark` GTK theme and `Tokyonight-Moon` icons, 24px
default cursor, dark-theme preference, and full hinting. The font lines are
commented out. `config/scripts/import-gsettings.sh` mirrors these into gsettings
at login.

---

## `hyprland`

**Target:** `~/.config/hypr`

The main desktop config. `hyprland.conf` is the entry point; it defines the
program variables and then `source`s everything else.

```
$terminal    = ghostty
$fileManager = nautilus
$menu        = rofi -show drun
```

Source order (`hyprland.conf:22-41`): `theme-colors.conf` (generated), then
`conf/` in order — `monitors`, `cursor`, `autostart`, `environment`, `animation`,
`layout`, `misc`, `keyboard`, `keybinding`, `layerrule`, `window`, `windowrule`,
`workspace` — and `conf/theme.conf` **last**, so styling overrides the base.

| File | Notes |
| --- | --- |
| `conf/monitors.conf` | `DP-1` at 3840x2160@240.02 scaled 1.25; `DP-2` preferred, rotated (`transform, 1`). Machine specific. |
| `conf/workspace.conf` | Workspaces 1-4 pinned to `DP-1`, 5-8 to `DP-2`. Machine specific. |
| `conf/keybinding.conf` | `SUPER` is the modifier. `SUPER+Return` terminal, `SUPER+Space` launcher, `SUPER+C` kill, `SUPER+E` files, `SUPER+H/J/K/L` focus (mapped left/right/up/down in that order), `Home` / `Shift+Home` screenshot, `SUPER+Shift+L` lock. |
| `conf/keyboard.conf` | US layout, `ctrl:nocaps`, natural scroll off. |
| `conf/autostart.conf` | Runs `~/.config/hypr/scripts/xdg.sh` (**missing from this repo**), import-gsettings, Waybar launch, hypridle, `hyprshade auto`, nm-applet, hyprpaper, blueman-applet. |
| `conf/theme.conf` | Styling only. Consumes `$bg $surface $surface_alt $fg $fg_muted $accent $accent_alt $warn $error $success` from the generated `theme-colors.conf`. Blur and shadow are off. |
| `conf/window.conf` | dwindle layout, gaps 10/14, border 3. Its `general {}` block is overridden by `conf/theme.conf` because that is sourced later. |
| `conf/environment.conf` | Empty file. |
| `conf/layerrule.conf`, `conf/windowrule.conf` | Fully commented out. |
| `hypridle.conf` | Lock at 600s, DPMS off at 660s, `systemctl suspend` at 1800s. |
| `hyprlock.conf` | Background is `~/.config/cache/blurred_wallpaper.png`. Input field pinned to `DP-1`. Clock label uses the `Fira Semibold` font. |
| `hyprpaper.conf` | Same wallpaper on `DP-1` and `DP-2`, `fit_mode = cover`. |
| `scripts/hyprpaper.sh` | `killall hyprpaper` then restart. Bound to `SUPER+Shift+P`. |

`~/.config/hypr/theme-colors.conf` is generated by the theme switcher and is not
tracked here.

---

## `hyprshade`

**Target:** `~/.config/hyprshade`

One schedule: `blue-light-filter` from 20:30 to 06:00. Started by
`hypr/conf/autostart.conf:20` (`hyprshade auto`).

---

## `nvim`

**Target:** `~/.config/nvim`

A **git submodule** — `git@github.com:qdrtech/xghost-config` over SSH. Its
contents are not part of this repo. Clone with `--recurse-submodules`, and do not
commit a submodule pointer change unless you mean to.

---

## `rofi`

**Target:** `~/.config/rofi`

| File | What it does |
| --- | --- |
| `config.rasi` | Launcher config and full widget styling. Line 9 loads the generated theme with an **absolute** path: `@theme "/home/qdrtech/.config/rofi/generated-theme.rasi"`. |
| `theme.rasi` | A committed **symlink** to `/home/qdrtech/.config/themes/default/rofi.rasi`. Left over from the older theme switcher; `config.rasi` no longer references it. Dangling on any other machine. |
| `theme-colors.rasi`, `generated-theme.rasi` | **Generated** by `scripts/theme-switch.sh`, committed for the same folded-symlink reason as Ghostty's `theme.conf`. |

`config.rasi` also uses `@color11` and `@background`, which come from pywal
output rather than from the theme switcher.

---

## `swaync`

**Target:** `~/.config/swaync`

| File | What it does |
| --- | --- |
| `config.json` | SwayNC behaviour. |
| `style.css` | A committed **symlink** to `/home/qdrtech/.config/themes/default/swaync.css`, written by the older theme switcher. Dangling on any other machine. |
| `refresh.sh` | `pkill swaync; swaync`. |

Waybar's `custom/notification` module toggles the panel via `swaync-client -t -sw`.

---

## `themes`

**Target:** `~/.config/themes`

Three theme directories — `default`, `macos-dark`, `tokyonight` — plus a
`README.md` describing the older switcher's design.

`default` and `macos-dark` each ship `colors.conf`, `ghostty.conf`, `rofi.rasi`,
`starship.toml`, `swaync.css`, `waybar.css`, and a Hyprland file
(`hyprland-style.conf` for `default`, `hyprland.conf` for `macos-dark`).
`tokyonight` ships only `colors.conf`, so it cannot be applied by the older
switcher.

**Important:** every `colors.conf` here uses `THEME_*` variables
(`THEME_BG_WINDOW`, `THEME_ACCENT_BLUE`, …). That is the older switcher's format.
The palette-first switcher in `scripts/` expects a different, much smaller set
(`BG`, `SURFACE`, `TEXT`, `ACCENT`, …), which no theme in this repo provides. See
[theme-switching.md](theme-switching.md).

`themes/.config/themes/README.md` describes the older switcher only. Treat it as
historical; it contradicts `docs/theme-switching.md`.

---

## `tmux`

**Target:** `~/.tmux.conf`

Prefix remapped to `C-a`. `|` and `-` split. `M-h/j/k/l` pane navigation. Mouse
on, `escape-time 0`, windows and panes indexed from 1. Default shell hardcoded to
`/usr/bin/zsh`. Plugins via tpm: `tmux-resurrect` and `tmux-continuum` with
`@continuum-restore on`. The reload binding hardcodes `~/dotfiles/tmux/.tmux.conf`.

tpm itself is not vendored — clone it to `~/.tmux/plugins/tpm`.

---

## `wal`

**Target:** `~/.config/wal`

pywal assets: `colorschemes/dark/ywal16.json` and four templates
(`colors-hyprland`, `colors-rofi-dark.rasi`, `colors-rofi-pywal.rasi`,
`tokyonight.rasi`). pywal renders templates into `~/.cache/wal/`.

`.zshrc:51-53` replays `~/.cache/wal/sequences` on every shell start, stripping
OSC 11/17/19/708 so the opaque background does not override Ghostty's
`background-opacity`.

---

## `wallpapers`

**Target:** `~/.config/wallpapers`

18 images, roughly 57 MB. `hyprpaper.conf` uses
`wp14372941-dark-ultrawide-4k-wallpapers.jpg`.

---

## `waybar`

**Target:** `~/.config/waybar`

| File | What it does |
| --- | --- |
| `config` | Top bar. Left: notifications, clock, pacman updates, tray. Center: Hyprland workspaces. Right: an expanding drawer group with colour picker, CPU, memory, temperature, bluetooth, network. |
| `style.css` | Real stylesheet. First line is `@import url("theme-colors.css")`, so it depends on the generated file existing. Uses `@bg`, `@surface`, `@text` from the switcher and `@color9` from pywal. |
| `scripts/launch.sh` | `killall waybar`, then start it. Branches on `$USER = qdrtech`. Bound to `SUPER+Shift+B`. |
| `scripts/refresh.sh` | Toggle: kill if running, start if not. |
| `scripts/colorpicker.sh` | `hyprpicker` + `wl-copy`, keeps a 10-entry history in `~/.cache/colorpicker/colors`, and emits waybar JSON with `-j`. |
| `scripts/select.sh` | Bar-theme picker. Copies one of `themes/<name>/` over `style.css` and `config`, then restarts waybar. **Its wofi config paths are not in this repo.** |
| `themes/{default,experimental,line,zen}/` | Four alternative bar layouts + stylesheets, used only by `select.sh`. |
| `assets/*.png` | Preview thumbnails for `select.sh`. |

`~/.config/waybar/theme-colors.css` is generated and not tracked.

Note: `scripts/select.sh` overwrites `style.css` in place. Since the package is
stowed, that writes into this repo.

---

## `wofi`

**Target:** `~/.config/wofi`

One file, `style.css`, a Catppuccin Mocha `@define-color` palette. Nothing in the
active config launches wofi except `waybar/scripts/select.sh`, and that asks for
`~/.config/wofi/waybar` and `~/.config/wofi/style-waybar.css`, neither of which
exists here. The launcher bound to `SUPER+Space` is rofi.

---

## `yay`

**Target:** `~/.config/yay/config.json`

`{"cleanAfter": true}`.

---

## `zshrc`

**Target:** `~/.zshrc`

Emacs keybindings, 1000-line history, `compinit`, syntax highlighting and
autosuggestions from `/usr/share/zsh/plugins/`, `starship init`, and the pywal
sequence replay described under `wal`.

Aliases: `gitprune`, `dle`, `ts` (theme switch — currently points at
`~/.config/scripts/theme-switch.sh`, the **older** switcher), `ll`/`la`/`l`, and
`..` through `.........`.

`PATH` additions: `~/.config/scripts`, `~/.local/bin`, bun, pnpm, flyctl,
opencode. `/home/qdrtech` is written literally on lines 14, 32, 45, 56 and 79.
