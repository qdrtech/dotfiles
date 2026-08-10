# dotfiles

Configuration for a Hyprland desktop on Arch Linux: compositor, bar, launcher,
terminal, notifications, shell, and theming.

**Read this first.** This repo is a personal machine setup, not a distributable
config framework. A clean clone will **not** just work. See
[Known limitations](#known-limitations) before you try to use it.

## How it is deployed

The repo is a [GNU Stow](https://www.gnu.org/software/stow/) layout, applied by
hand. There is no bootstrap script, no `Makefile`, no `.stowrc`, and no package
manifest.

Each top-level directory is a **stow package**. The tree inside a package mirrors
the tree that should appear in `$HOME`. Stow creates symlinks from `$HOME` back
into the repo:

```
waybar/.config/waybar/config   ->  ~/.config/waybar/config
zshrc/.zshrc                   ->  ~/.zshrc
```

Nothing is copied. Editing a file in `~/.config` edits the file in this repo.

Two directories are **not** stow packages: `scripts/` and `docs/`.

## Packages

| Package      | Configures                             | Lands at                  |
| ------------ | -------------------------------------- | ------------------------- |
| `config`     | shared helper scripts, rofi snippets, wallpaper cache | `~/.config/scripts`, `~/.config/settings`, `~/.config/cache` |
| `ghostty`    | Ghostty terminal                       | `~/.config/ghostty`       |
| `gtk-3.0`    | GTK 3 theme/font settings              | `~/.config/gtk-3.0/settings.ini` |
| `hyprland`   | Hyprland, hypridle, hyprlock, hyprpaper | `~/.config/hypr`         |
| `hyprshade`  | hyprshade blue-light schedule          | `~/.config/hyprshade`     |
| `nvim`       | Neovim (**git submodule**)             | `~/.config/nvim`          |
| `rofi`       | Rofi launcher                          | `~/.config/rofi`          |
| `swaync`     | SwayNotificationCenter                 | `~/.config/swaync`        |
| `themes`     | colour themes for the theme switcher   | `~/.config/themes`        |
| `tmux`       | tmux                                   | `~/.tmux.conf`            |
| `wal`        | pywal templates and colorschemes       | `~/.config/wal`           |
| `wallpapers` | wallpaper images (~57 MB)              | `~/.config/wallpapers`    |
| `waybar`     | Waybar status bar                      | `~/.config/waybar`        |
| `wofi`       | Wofi menu styling                      | `~/.config/wofi`          |
| `yay`        | yay AUR helper                         | `~/.config/yay`           |
| `zshrc`      | Zsh                                    | `~/.zshrc`                |

Per-package detail, including which files are generated rather than authored:
[docs/packages.md](docs/packages.md).

## Install

Full steps, dependency list, and post-install checks:
[docs/installation.md](docs/installation.md).

Short version:

```sh
git clone --recurse-submodules <this-repo> ~/dotfiles
cd ~/dotfiles
stow -t "$HOME" hyprland waybar rofi ghostty swaync themes config \
                gtk-3.0 hyprshade tmux wal wallpapers wofi yay zshrc nvim
```

`stow` defaults its target to the parent of the repo directory. Cloning to
`~/dotfiles` makes the default target `$HOME`; `-t "$HOME"` states it
explicitly and works from any clone location, because stow computes its
symlink targets relative to wherever the repo actually is.

The clone path still matters for one thing: `tmux/.tmux.conf:16` hardcodes
`bind r source-file ~/dotfiles/tmux/.tmux.conf`.

## Theming

Themes and the theme switcher are in a partially migrated state. Two switchers
exist, they use incompatible theme formats, and neither currently applies a
theme end to end. Read [docs/theme-switching.md](docs/theme-switching.md) before
running either one — it documents what actually happens today, including what
will break.

## Known limitations

This config is tied to one machine. Specifically:

- **Hardcoded home directory.** `/home/qdrtech` is written literally in
  `zshrc/.zshrc` and `rofi/.config/rofi/config.rasi`. Another user's shell and
  launcher will not work unmodified.
- **Committed absolute-path symlinks.** `rofi/.config/rofi/theme.rasi` and
  `swaync/.config/swaync/style.css` are symlinks whose targets start with
  `/home/qdrtech`. They are dangling for anyone else.
- **Monitor-specific.** `hyprland/.config/hypr/conf/monitors.conf` and
  `workspace.conf` name `DP-1` and `DP-2` with fixed modes and workspace
  assignments. `hyprland/.config/hypr/hyprpaper.conf` and `hyprlock.conf` also
  name those outputs.
- **Submodule over SSH.** `.gitmodules` uses `git@github.com:qdrtech/xghost-config`.
  Cloning `--recurse-submodules` requires an SSH key with access to that repo.
- **Work-specific script.** `config/.config/scripts/docker-login-ecr.sh` targets
  a specific AWS ECR setup.
- **macOS fonts.** `ghostty/.config/ghostty/config` sets `font-family = .SF NS Mono`
  and `gtk-3.0/settings.ini` references SF Pro. These are Apple fonts and are not
  present on Arch by default.
- **Generated files are committed.** Because `~/.config/ghostty` and
  `~/.config/rofi` are symlinks into this repo, the theme switcher writes its
  generated output back into tracked files. See
  [docs/packages.md](docs/packages.md).

None of these are fixed in this repo today. They are listed so you know what to
change before reusing it.

## License

MIT. See [LICENSE](LICENSE).
