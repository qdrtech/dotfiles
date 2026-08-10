# Installation

There is no install script. Deployment is `stow`, run by hand.

## 1. Clone

```sh
git clone --recurse-submodules <this-repo> ~/dotfiles
cd ~/dotfiles
```

Clone to `~/dotfiles`. Stow is not the reason: it creates the `~/.config`
symlinks itself at stow time and computes each relative target from wherever
you cloned, so stow's own links work from any location. The clone path matters
for exactly one thing — `tmux/.tmux.conf:16` hardcodes
`bind r source-file ~/dotfiles/tmux/.tmux.conf`, so the tmux reload binding only
works from a clone at `~/dotfiles`.

Two symlinks *are* committed, and both have **absolute** targets:
`rofi/.config/rofi/theme.rasi` and `swaync/.config/swaync/style.css` point at
`/home/qdrtech/.config/themes/default/`. Those are unaffected by where you clone
and dangle for any other user. See [packages.md](packages.md).

The `nvim` package is a git submodule pointing at
`git@github.com:qdrtech/xghost-config` over SSH. Without access to that repo the
submodule stays empty; skip the `nvim` package below if so.

## 2. Back up anything already there

Stow refuses to overwrite existing regular files. Move them out of the way first:

```sh
mkdir -p ~/dotfiles-backup
for p in hypr waybar rofi ghostty swaync themes gtk-3.0 hyprshade wal wofi yay scripts settings cache wallpapers; do
  [ -e "$HOME/.config/$p" ] && mv "$HOME/.config/$p" ~/dotfiles-backup/
done
[ -e ~/.zshrc ] && mv ~/.zshrc ~/dotfiles-backup/
[ -e ~/.tmux.conf ] && mv ~/.tmux.conf ~/dotfiles-backup/
```

## 3. Stow

Dry run first. `-n` simulates, `-v` shows what it would do:

```sh
cd ~/dotfiles
stow -nv -t "$HOME" hyprland waybar rofi ghostty swaync themes config \
                    gtk-3.0 hyprshade tmux wal wallpapers wofi yay zshrc nvim
```

If the output looks right, drop `-n`:

```sh
stow -v -t "$HOME" hyprland waybar rofi ghostty swaync themes config \
                   gtk-3.0 hyprshade tmux wal wallpapers wofi yay zshrc nvim
```

Packages are independent. You can stow a subset — for example just the shell:

```sh
stow -t "$HOME" zshrc tmux
```

To remove a package's symlinks:

```sh
stow -D -t "$HOME" waybar
```

To re-apply after adding files to a package:

```sh
stow -R -t "$HOME" waybar
```

### Folded vs unfolded directories

On the reference machine some targets are a single symlink to the package
directory (`~/.config/rofi -> ../dotfiles/rofi/.config/rofi`, "folded"), and
some are a real directory holding one symlink per file (`~/.config/hypr`,
`~/.config/waybar`, `~/.config/themes`, `~/.config/gtk-3.0`, `~/.config/yay`,
"unfolded"). Stow unfolds automatically when a non-stow file needs to live
alongside stowed ones. Both work. Which one you get depends on what already
exists in the target directory when you stow.

This matters for one reason: when a directory is **folded**, anything a program
writes into it is written into this repo and shows up in `git status`. See
[packages.md](packages.md).

## 4. Dependencies

Nothing here installs dependencies. The list below is derived from what the
committed configs actually invoke — each row names the file that references it.
Package names are the usual Arch/AUR names; confirm with `pacman -F <binary>`
before installing.

### Required for the desktop session

| Command / thing | Arch package | Referenced by |
| --- | --- | --- |
| `stow` | `stow` | deployment itself |
| `Hyprland`, `hyprctl` | `hyprland` | the whole `hyprland` package |
| `hypridle` | `hypridle` | `hypr/conf/autostart.conf`, `hypr/hypridle.conf` |
| `hyprlock` | `hyprlock` | `hypr/conf/keybinding.conf:20`, `hypr/hyprlock.conf`, `hypridle.conf` |
| `hyprpaper` | `hyprpaper` | `hypr/conf/autostart.conf:23`, `hypr/scripts/hyprpaper.sh` |
| `hyprshade` | `hyprshade` (AUR) | `hypr/conf/autostart.conf:20`, `hyprshade/config.toml` |
| `hyprshot` | `hyprshot` (AUR) | `hypr/conf/keybinding.conf:18-19` |
| `waybar` | `waybar` | `hypr/conf/autostart.conf:14`, `waybar/scripts/*` |
| `rofi` | `rofi` / `rofi-wayland` | `hypr/hyprland.conf:17` (`$menu = rofi -show drun`) |
| `ghostty` | `ghostty` | `hypr/hyprland.conf:15` (`$terminal`) |
| `nautilus` | `nautilus` | `hypr/hyprland.conf:16` (`$fileManager`) |
| `swaync`, `swaync-client` | `swaync` | `waybar/config` notification module, `swaync/` package |
| `nm-applet` | `network-manager-applet` | `hypr/conf/autostart.conf:23` |
| `blueman-applet`, `blueman-manager` | `blueman` | `hypr/conf/autostart.conf:23`, `waybar/config` |
| `wpctl` | `wireplumber` | `hypr/conf/keybinding.conf:65-68` (volume keys) |
| `brightnessctl` | `brightnessctl` | `hypr/conf/keybinding.conf:69-70` |
| `playerctl` | `playerctl` | `hypr/conf/keybinding.conf:73-76` |
| `gsettings` | `glib2` | `config/scripts/import-gsettings.sh` |
| `killall` | `psmisc` | `waybar/scripts/launch.sh`, `hypr/scripts/hyprpaper.sh` |

### Required by Waybar modules

| Command / thing | Arch package | Referenced by |
| --- | --- | --- |
| `checkupdates` | `pacman-contrib` | `waybar/config` `custom/pacman` |
| `yay` | `yay` (AUR) | `waybar/config` `custom/pacman` on-click; `yay/` package |
| `kitty` | `kitty` | `waybar/config` network + pacman on-click (hardcoded, even though the session terminal is Ghostty) |
| `hyprpicker` | `hyprpicker` | `waybar/scripts/colorpicker.sh` |
| `wl-copy` | `wl-clipboard` | `waybar/scripts/colorpicker.sh` |
| `notify-send` | `libnotify` | `waybar/scripts/colorpicker.sh` |
| `wofi` | `wofi` | `waybar/scripts/select.sh` (see caveat below) |
| JetBrainsMono Nerd Font | `ttf-jetbrains-mono-nerd` | `waybar/style.css:5`, `rofi/config.rasi:5` |

### Required by the shell

| Command / thing | Arch package | Referenced by |
| --- | --- | --- |
| `zsh` | `zsh` | `zshrc/.zshrc`; `tmux/.tmux.conf` hardcodes `/usr/bin/zsh` |
| zsh-syntax-highlighting | `zsh-syntax-highlighting` | `.zshrc:26` (loads from `/usr/share/zsh/plugins/`) |
| zsh-autosuggestions | `zsh-autosuggestions` | `.zshrc:27` (same path) |
| `starship` | `starship` | `.zshrc:29` |
| `nvim` | `neovim` | `.zshrc:1` (`EDITOR`) |
| `fd` | `fd` | `.zshrc:41` (`FZF_DEFAULT_COMMAND`) |
| `figlet` | `figlet` | `config/scripts/term-startup.sh` |
| `fastfetch` | `fastfetch` | `config/scripts/term-startup.sh` |
| `tmux` | `tmux` | `tmux/.tmux.conf` |
| tpm | clone to `~/.tmux/plugins/tpm` | `.tmux.conf:4` declares it, `.tmux.conf:64` runs it — plugin manager, loads tmux-resurrect and tmux-continuum |
| pywal | `python-pywal` | `.zshrc:51` reads `~/.cache/wal/sequences`; `wal/` package holds its templates |
| `convert` | `imagemagick` | required by `config/scripts/wal` (a vendored copy of the pywal shell script) |

`.zshrc` also puts `bun`, `nvm`, `pnpm`, `flyctl`, and `opencode` on `PATH`.
Those are optional developer tools; their `source` lines are guarded with
existence checks, so a missing tool does not break the shell.

### GTK themes

`gtk-3.0/settings.ini` requests the `Tokyonight-Dark` GTK theme and the
`Tokyonight-Moon` icon theme. Neither is in this repo. Install them separately
or the setting silently falls back.

## 5. Known gaps after stowing

These are real, verified gaps. Fix or ignore, but do not expect them to work.

- **The generated colour files are missing and nothing can generate them.**
  This is the largest gap on a fresh machine. `~/.config/hypr/theme-colors.conf`
  and `~/.config/waybar/theme-colors.css` are produced by the theme switcher and
  are not tracked in this repo, but the committed configs require them:

  - `hyprland/.config/hypr/hyprland.conf:22` does
    `source = ~/.config/hypr/theme-colors.conf`. With the file absent that
    `source` fails and none of `$bg $surface $surface_alt $fg $fg_muted $accent
    $accent_alt $warn $error $success` are defined, so
    `hyprland/.config/hypr/conf/theme.conf:28-29`
    (`col.active_border = $fg_muted`, `col.inactive_border = $surface`) has no
    values to use.
  - `waybar/.config/waybar/style.css:1` does
    `@import url("theme-colors.css")`. With the file absent the import fails and
    `@bg`, `@surface` and `@text` — used at lines 9, 10, 19, 24 and 25 — are
    undefined, so the bar comes up unstyled.
  - Rofi is the exception: `rofi/.config/rofi/config.rasi:9` points `@theme` at
    the absolute path `/home/qdrtech/.config/rofi/generated-theme.rasi`, and
    `generated-theme.rasi` *is* committed, so it resolves for the user
    `qdrtech` and fails for anyone else.

  The only thing that writes these files is `scripts/theme-switch.sh`
  (`scripts/theme-switch.sh:15-18`), and it is broken — see
  [theme-switching.md](theme-switching.md). The other switcher never generates
  them. There is no working way to produce the missing files today.
- **`~/.config/hypr/scripts/xdg.sh` does not exist.**
  `hypr/conf/autostart.conf:8` runs it on every login. It was never committed.
  Its stated job was XDG desktop portal setup for screen sharing.
- **`waybar/scripts/select.sh` points at wofi configs that are not in this repo.**
  It calls `wofi -c ~/.config/wofi/waybar -s ~/.config/wofi/style-waybar.css`.
  The `wofi` package only ships `style.css`.
- **Theming does not apply cleanly.** See [theme-switching.md](theme-switching.md).
- **Hardcoded paths.** `/home/qdrtech` appears literally in `.zshrc` and
  `rofi/config.rasi`, and two committed symlinks have absolute targets. Grep for
  it and fix before using on another account.
