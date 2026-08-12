# Packages

One section per stow package. "Target" is where the package lands when stowed
with `-t "$HOME"` from a clone at `~/dotfiles`.

Paths in each section's **File** column are relative to that section's package
(`conf/monitors.conf` under `hyprland` means
`hyprland/.config/hypr/conf/monitors.conf`). Everywhere else, a path without a
leading `~` is relative to the repo root and a path with a leading `~` is the
deployed location.

`scripts/` and `docs/` are **not** stow packages. `scripts/theme-switch.sh` is
run from the repo, not from `$HOME`.

---

## `config`

**Target:** `~/.config/scripts`, `~/.config/settings`, `~/.config/cache`

Shared helpers that are not tied to one program.

| File                                                                     | What it does                                                                                                                                                                         |
| ------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `scripts/term-startup.sh`                                                | Runs `figlet qdrtech` then `fastfetch`. Called from `zshrc/.zshrc:10`.                                                                                                               |
| `scripts/import-gsettings.sh`                                            | Reads `gtk-3.0/settings.ini` and pushes theme/icon/cursor/font into `org.gnome.desktop.interface` via `gsettings`. Run on login from `hyprland/.config/hypr/conf/autostart.conf:8`.  |
| `scripts/git-prune.sh`                                                   | `git fetch --prune`, then interactively deletes local branches whose upstream is gone. Aliased to `gitprune`.                                                                        |
| `scripts/docker-login-ecr.sh`                                            | Work-specific AWS ECR login. Aliased to `dle`. Not generally useful.                                                                                                                 |
| `scripts/wal`                                                            | A vendored copy of the pywal shell script (`wal`) by Dylan Araps. Requires ImageMagick's `convert`.                                                                                  |
| `settings/rofi-border.rasi`, `rofi-border-radius.rasi`, `rofi-font.rasi` | One-line rofi settings fragments. Nothing in this repo imports them.                                                                                                                 |
| `cache/blurred_wallpaper.png`                                            | Lock screen background. Read by `hyprland/.config/hypr/hyprlock.conf:15`.                                                                                                            |
| `cache/current_wallpaper`, `cache/current_wallpaper.rasi`                | Wallpaper path record and a rofi snippet that points at `blurred_wallpaper.png`.                                                                                                     |

`~/.config/scripts` is on `PATH` (`zshrc/.zshrc:42`).

Note: `config/.config/base` is not in this repo, and `~/.config/base` does not
exist on the reference machine either — `ls -ld` reports _No such file or
directory_, so there is no dangling symlink to clean up. Only the removed
file-first theme switcher ever referenced the path.

---

## `ghostty`

**Target:** `~/.config/ghostty`

| File         | What it does                                                                                                                                                                                                   |
| ------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `config`     | Ghostty settings: `.SF NS Mono` at 14pt, ligatures, 10px horizontal padding, `background-blur-radius = 20`, `background-opacity = 0.2`, GTK titlebar, sudo shell integration, and `config-file = ?theme.conf` to load the generated palette. |
| `theme.conf` | **Generated**, not authored. Written by `scripts/theme-switch.sh`. `~/.config/ghostty` is a folded symlink into this repo, so the switcher writes straight into the working tree; the path is in `.gitignore`. |

`config` pulls in `theme.conf` with `config-file = ?theme.conf`. The path is
relative to `config`, and the leading `?` makes it optional, so a fresh clone
whose switcher has not run yet still starts instead of failing with
`error opening config-file ...: error.FileNotFound`. Ghostty applies an included
file *after* the file that pulls it in, regardless of where the directive
appears, so within Ghostty's config resolution the generated palette wins over
colours set in `config` — which is why `config` sets none.

That precedence is about config load order only, not about what ends up on
screen. `zshrc/.zshrc:51-53` replays `~/.cache/wal/sequences` on every shell
start, stripping only OSC 11/17/19/708. What survives the strip still sets
OSC 4;0-15, OSC 10 and OSC 12, so pywal overrides the palette, foreground and
cursor at runtime — 18 of the 21 values in `theme.conf`. Background and the two
`selection-*` values survive, because their sequences (OSC 11, 17, 19) are the
stripped ones.

---

## `gtk-3.0`

**Target:** `~/.config/gtk-3.0/settings.ini`

Requests the `Tokyonight-Dark` GTK theme and `Tokyonight-Moon` icons, 24px
default cursor, dark-theme preference, and full hinting. The font lines are
commented out. `config/.config/scripts/import-gsettings.sh` mirrors these into
gsettings at login.

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

| File                                          | Notes                                                                                                                                                                                                                               |
| --------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `conf/monitors.conf`                          | `DP-1` at 3840x2160@240.02 scaled 1.25; `DP-2` preferred, rotated (`transform, 1`). Machine specific.                                                                                                                               |
| `conf/workspace.conf`                         | Workspaces 1-4 pinned to `DP-1`, 5-8 to `DP-2`. Machine specific.                                                                                                                                                                   |
| `conf/keybinding.conf`                        | `SUPER` is the modifier. `SUPER+Return` terminal, `SUPER+Space` launcher, `SUPER+C` kill, `SUPER+E` files, `SUPER+H/J/K/L` focus (mapped left/right/up/down in that order), `Home` / `Shift+Home` screenshot, `SUPER+Shift+L` lock. |
| `conf/keyboard.conf`                          | US layout, `ctrl:nocaps`, natural scroll off.                                                                                                                                                                                       |
| `conf/autostart.conf`                         | Runs import-gsettings, Waybar launch, hypridle, `hyprshade auto`, nm-applet, hyprpaper, blueman-applet.                                                                                                                             |
| `conf/theme.conf`                             | Styling only. Consumes `$bg $surface $surface_alt $fg $fg_muted $accent $accent_alt $warn $error $success` from the generated `theme-colors.conf`. Blur and shadow are off.                                                         |
| `conf/window.conf`                            | dwindle layout, gaps 10/14, border 3. Its `general {}` block is overridden by `conf/theme.conf` because that is sourced later.                                                                                                      |
| `conf/environment.conf`                       | Empty file.                                                                                                                                                                                                                         |
| `conf/layerrule.conf`, `conf/windowrule.conf` | Fully commented out.                                                                                                                                                                                                                |
| `hypridle.conf`                               | Lock at 600s, DPMS off at 660s, `systemctl suspend` at 1800s.                                                                                                                                                                       |
| `hyprlock.conf`                               | Background is `~/.config/cache/blurred_wallpaper.png`. Input field pinned to `DP-1`. Clock label uses the `Fira Semibold` font.                                                                                                     |
| `hyprpaper.conf`                              | Same wallpaper on `DP-1` and `DP-2`, `fit_mode = cover`.                                                                                                                                                                            |
| `scripts/hyprpaper.sh`                        | `killall hyprpaper` then restart. Bound to `SUPER+Shift+P`.                                                                                                                                                                         |

`~/.config/hypr/theme-colors.conf` is generated by the theme switcher and is not
tracked here.

---

## `hyprshade`

**Target:** `~/.config/hyprshade`

One schedule: `blue-light-filter` from 20:30 to 06:00. Started by
`hyprland/.config/hypr/conf/autostart.conf:17` (`hyprshade auto`).

---

## `nvim`

**Target:** `~/.config/nvim`

A **git submodule** — `git@github.com:qdrtech/xghost-config` over SSH. Its
contents are not part of this repo. Clone with `--recurse-submodules`, and do not
commit a submodule pointer change unless you mean to.

---

## `rofi`

**Target:** `~/.config/rofi`

| File                   | What it does                                                                                                                                                                                              |
| ---------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `config.rasi`          | Launcher config and full widget styling. Line 9 loads the generated theme with `@theme "generated-theme.rasi"`; rofi resolves an `@import`/`@theme` filename against the directory of the including file. |
| `theme-colors.rasi`    | **Generated** by `scripts/theme-switch.sh`. The palette, as a `* { }` block. Imported by `generated-theme.rasi`.                                                                                          |
| `generated-theme.rasi` | **Generated** by `scripts/theme-switch.sh`. Widget styling built from the palette.                                                                                                                        |

Both generated files are in `.gitignore`; `~/.config/rofi` is a folded symlink
into this repo, so the switcher writes straight into the working tree. Run
`ts set <theme>` once after stowing to produce them.

`config.rasi` uses `@background`, `@foreground` and `@color11` — names inherited
from pywal's rofi template. The switcher defines them in `theme-colors.rasi` as
aliases onto `@bg`, `@fg` and `@accent`, so they resolve from the palette.
`@border-width`, `@border-radius` and `@current-image` come from the fragments
under `config/.config/settings/` and `config/.config/cache/`, which nothing
currently imports.

---

## `swaync`

**Target:** `~/.config/swaync`

| File               | What it does                                                                                                                                                                                            |
| ------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `config.json`      | SwayNC behaviour.                                                                                                                                                                                       |
| `style.css`        | Real stylesheet. First line is `@import url("theme-colors.css")`, so it depends on the generated file existing. Uses `@bg`, `@surface`, `@surface-alt`, `@text`, `@text-muted`, `@accent` and `@error`. |
| `theme-colors.css` | **Generated** by `scripts/theme-switch.sh`, and in `.gitignore` for the same folded-symlink reason as Ghostty's `theme.conf`.                                                                           |
| `refresh.sh`       | `pkill swaync; swaync`.                                                                                                                                                                                 |

Waybar's `custom/notification` module toggles the panel via `swaync-client -t -sw`.

---

## `themes`

**Target:** `~/.config/themes`

Two theme directories — `macos-dark` and `tokyonight` — plus a short
`README.md`.

Each theme is exactly one file, `colors.conf`, holding the ten `#RRGGBB`
variables `scripts/theme-switch.sh` reads: `BG`, `SURFACE`, `SURFACE_ALT`,
`TEXT`, `TEXT_MUTED`, `ACCENT`, `ACCENT_ALT`, `WARN`, `ERROR`, `SUCCESS`. There
are no per-component files; the switcher generates all of them. See
[theme-switching.md](theme-switching.md).

A third theme, `default`, was deleted — its palette duplicated `tokyonight`, its
component files duplicated `macos-dark`, and its waybar stylesheet was
pywal-driven. See issue #43.

If stow folds `~/.config/themes` into this package, the switcher's bookkeeping
files (`current`, `colors.conf`, `current.txt`) land here; they are in
`.gitignore`.

---

## `tmux`

**Target:** `~/.tmux.conf`

Prefix remapped to `C-a`. `|` and `-` split. `M-h/j/k/l` pane navigation. Mouse
on, `escape-time 0`, windows and panes indexed from 1. Default shell hardcoded to
`/usr/bin/zsh`. Plugins via tpm: `tmux-resurrect` and `tmux-continuum` with
`@continuum-restore on`. The reload binding sources `~/.tmux.conf`, the stowed
path, so it does not depend on where the repo is cloned.

tpm itself is not vendored — clone it to `~/.tmux/plugins/tpm`.

---

## `wal`

**Target:** `~/.config/wal`

pywal assets: `colorschemes/dark/ywal16.json` and four templates
(`colors-hyprland`, `colors-rofi-dark.rasi`, `colors-rofi-pywal.rasi`,
`tokyonight.rasi`). pywal renders templates into `~/.cache/wal/`.

`zshrc/.zshrc:51-53` replays `~/.cache/wal/sequences` on every shell start, stripping
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

| File                     | What it does                                                                                                                                                                                |
| ------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `config`                 | Top bar. Left: notifications, clock, pacman updates, tray. Center: Hyprland workspaces. Right: an expanding drawer group with colour picker, CPU, memory, temperature, bluetooth, network.  |
| `style.css`              | Real stylesheet. First line is `@import url("theme-colors.css")`, so it depends on the generated file existing. Uses `@bg`, `@surface`, `@text` from the switcher and `@color9` from pywal. |
| `scripts/launch.sh`      | `killall waybar`, then start it. Branches on `$USER = qdrtech`. Bound to `SUPER+Shift+B`.                                                                                                   |
| `scripts/refresh.sh`     | Toggle: kill if running, start if not.                                                                                                                                                      |
| `scripts/colorpicker.sh` | `hyprpicker` + `wl-copy`, keeps a 10-entry history in `~/.cache/colorpicker/colors`, and emits waybar JSON with `-j`.                                                                       |

`~/.config/waybar/theme-colors.css` is generated and not tracked.

`themes/{default,experimental,line,zen}/` (four `config-<name>` / `style-<name>.css`
pairs) and `assets/*.png` are still in the package but unused — they existed only
for the bar-theme picker removed in #44. Applying one is a manual copy of the pair
over `config` and `style.css`.

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

Aliases: `gitprune`, `dle`, `ts` (theme switch — runs
`${DOTFILES_DIR:-$HOME/dotfiles}/scripts/theme-switch.sh`), `ll`/`la`/`l`, and
`..` through `.........`.

`PATH` additions: `~/.config/scripts`, `~/.local/bin`, bun, pnpm, flyctl,
opencode. All of them go through `$HOME`; no home directory is hardcoded.
