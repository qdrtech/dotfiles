# Installation

There is no install script. Deployment is `stow`, run by hand.

## 1. Clone

```sh
git clone --recurse-submodules <this-repo> ~/dotfiles
cd ~/dotfiles
```

`~/dotfiles` is a convention, not a requirement. Stow creates the `~/.config`
symlinks at stow time and computes each relative target from wherever you
cloned, and nothing in the repo assumes a particular clone path.

The `nvim` package is a git submodule pointing at
`git@github.com:qdrtech/xghost-config` over SSH. Without access to that repo the
submodule stays empty; skip the `nvim` package below if so.

## 2. Back up anything already there

Stow refuses to overwrite existing regular files. Move them out of the way first:

```sh
mkdir -p ~/dotfiles-backup
for p in hypr waybar rofi ghostty swaync themes gtk-3.0 hyprshade wal yay scripts settings cache wallpapers; do
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
                    gtk-3.0 hyprshade tmux wal wallpapers yay zshrc nvim
```

If the output looks right, drop `-n`:

```sh
stow -v -t "$HOME" hyprland waybar rofi ghostty swaync themes config \
                   gtk-3.0 hyprshade tmux wal wallpapers yay zshrc nvim
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

**Path notation.** Throughout these docs, a path without a leading `~` is a path
inside this repo, relative to the repo root (`hyprland/.config/hypr/conf/`), and
a path with a leading `~` is where the file lands after stowing
(`~/.config/hypr/conf/`). The repo form is used whenever a file of this repo is
cited, because the deployed form is ambiguous — `~/.config/scripts/` comes from
the `config` package, while the repo's top-level `scripts/` directory is not a
stow package at all. The one exception is the per-package file tables in
[packages.md](packages.md), whose paths are relative to that section's package.

### Required for the desktop session

| Command / thing                     | Arch package             | Referenced by                                                                                                                 |
| ----------------------------------- | ------------------------ | ----------------------------------------------------------------------------------------------------------------------------- |
| `stow`                              | `stow`                   | deployment itself                                                                                                             |
| `Hyprland`, `hyprctl`               | `hyprland`               | the whole `hyprland` package                                                                                                  |
| `hypridle`                          | `hypridle`               | `hyprland/.config/hypr/conf/autostart.conf`, `hyprland/.config/hypr/hypridle.conf`                                            |
| `hyprlock`                          | `hyprlock`               | `hyprland/.config/hypr/conf/keybinding.conf:20`, `hyprland/.config/hypr/hyprlock.conf`, `hyprland/.config/hypr/hypridle.conf` |
| `hyprpaper`                         | `hyprpaper`              | `hyprland/.config/hypr/conf/autostart.conf:23`, `hyprland/.config/hypr/scripts/hyprpaper.sh`                                  |
| `hyprshade`                         | `hyprshade` (AUR)        | `hyprland/.config/hypr/conf/autostart.conf:20`, `hyprshade/.config/hyprshade/config.toml`                                     |
| `hyprshot`                          | `hyprshot` (AUR)         | `hyprland/.config/hypr/conf/keybinding.conf:18-19`                                                                            |
| `waybar`                            | `waybar`                 | `hyprland/.config/hypr/conf/autostart.conf:14`, `waybar/.config/waybar/scripts/*`                                             |
| `rofi`                              | `rofi` / `rofi-wayland`  | `hyprland/.config/hypr/hyprland.conf:17` (`$menu = rofi -show drun`)                                                          |
| `ghostty`                           | `ghostty`                | `hyprland/.config/hypr/hyprland.conf:15` (`$terminal`)                                                                        |
| `nautilus`                          | `nautilus`               | `hyprland/.config/hypr/hyprland.conf:16` (`$fileManager`)                                                                     |
| `swaync`, `swaync-client`           | `swaync`                 | `waybar/.config/waybar/config` notification module, `swaync/` package                                                         |
| `nm-applet`                         | `network-manager-applet` | `hyprland/.config/hypr/conf/autostart.conf:23`                                                                                |
| `blueman-applet`, `blueman-manager` | `blueman`                | `hyprland/.config/hypr/conf/autostart.conf:23`, `waybar/.config/waybar/config`                                                |
| `wpctl`                             | `wireplumber`            | `hyprland/.config/hypr/conf/keybinding.conf:65-68` (volume keys)                                                              |
| `brightnessctl`                     | `brightnessctl`          | `hyprland/.config/hypr/conf/keybinding.conf:69-70`                                                                            |
| `playerctl`                         | `playerctl`              | `hyprland/.config/hypr/conf/keybinding.conf:73-76`                                                                            |
| `gsettings`                         | `glib2`                  | `config/.config/scripts/import-gsettings.sh`                                                                                  |
| `killall`                           | `psmisc`                 | `waybar/.config/waybar/scripts/launch.sh`, `hyprland/.config/hypr/scripts/hyprpaper.sh`                                       |

### Required by Waybar modules

| Command / thing         | Arch package              | Referenced by                                                                                                     |
| ----------------------- | ------------------------- | ----------------------------------------------------------------------------------------------------------------- |
| `checkupdates`          | `pacman-contrib`          | `waybar/.config/waybar/config` `custom/pacman`                                                                    |
| `yay`                   | `yay` (AUR)               | `waybar/.config/waybar/config` `custom/pacman` on-click; `yay/` package                                           |
| `kitty`                 | `kitty`                   | `waybar/.config/waybar/config` network + pacman on-click (hardcoded, even though the session terminal is Ghostty) |
| `hyprpicker`            | `hyprpicker`              | `waybar/.config/waybar/scripts/colorpicker.sh`                                                                    |
| `wl-copy`               | `wl-clipboard`            | `waybar/.config/waybar/scripts/colorpicker.sh`                                                                    |
| `notify-send`           | `libnotify`               | `waybar/.config/waybar/scripts/colorpicker.sh`                                                                    |
| JetBrainsMono Nerd Font | `ttf-jetbrains-mono-nerd` | `waybar/.config/waybar/style.css:5`, `rofi/.config/rofi/config.rasi:5`                                            |

### Required by the shell

| Command / thing         | Arch package                   | Referenced by                                                                                                           |
| ----------------------- | ------------------------------ | ----------------------------------------------------------------------------------------------------------------------- |
| `zsh`                   | `zsh`                          | `zshrc/.zshrc`; `tmux/.tmux.conf` hardcodes `/usr/bin/zsh`                                                              |
| zsh-syntax-highlighting | `zsh-syntax-highlighting`      | `zshrc/.zshrc:26` (loads from `/usr/share/zsh/plugins/`)                                                                |
| zsh-autosuggestions     | `zsh-autosuggestions`          | `zshrc/.zshrc:27` (same path)                                                                                           |
| `starship`              | `starship`                     | `zshrc/.zshrc:29`                                                                                                       |
| `nvim`                  | `neovim`                       | `zshrc/.zshrc:1` (`EDITOR`)                                                                                             |
| `fd`                    | `fd`                           | `zshrc/.zshrc:41` (`FZF_DEFAULT_COMMAND`)                                                                               |
| `figlet`                | `figlet`                       | `config/.config/scripts/term-startup.sh`                                                                                |
| `fastfetch`             | `fastfetch`                    | `config/.config/scripts/term-startup.sh`                                                                                |
| `tmux`                  | `tmux`                         | `tmux/.tmux.conf`                                                                                                       |
| tpm                     | clone to `~/.tmux/plugins/tpm` | `tmux/.tmux.conf:4` declares it, `tmux/.tmux.conf:64` runs it — plugin manager, loads tmux-resurrect and tmux-continuum |
| pywal                   | `python-pywal`                 | `zshrc/.zshrc:51` reads `~/.cache/wal/sequences`; `wal/` package holds its templates                                    |
| `convert`               | `imagemagick`                  | required by `config/.config/scripts/wal` (a vendored copy of the pywal shell script)                                    |

`zshrc/.zshrc` also puts `bun`, `nvm`, `pnpm`, `flyctl`, and `opencode` on `PATH`.
Those are optional developer tools; their `source` lines are guarded with
existence checks, so a missing tool does not break the shell.

### GTK themes

`gtk-3.0/.config/gtk-3.0/settings.ini` requests the `Tokyonight-Dark` GTK theme and the
`Tokyonight-Moon` icon theme. Neither is in this repo. Install them separately
or the setting silently falls back.

## 5. Known gaps after stowing

These are real, verified gaps. Fix or ignore, but do not expect them to work.

- **The generated colour files do not exist until you run the theme switcher.**
  None of them are tracked. Run this once, immediately after stowing:

  ```sh
  bash "${DOTFILES_DIR:-$HOME/dotfiles}/scripts/theme-switch.sh" set macos-dark
  ```

  Until you do, the committed configs are missing their colours:

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
  - `swaync/.config/swaync/style.css:1` does the same with
    `~/.config/swaync/theme-colors.css`.
  - `rofi/.config/rofi/config.rasi:9` points `@theme` at `generated-theme.rasi`.
    With the file absent rofi falls back to its built-in theme and the launcher
    still opens. It does not warn: `rofi -config <config.rasi> -dump-theme`
    exits 0 with empty stderr. Note for anyone testing rofi theming, here or
    elsewhere: rofi exits 0 on a theme _parse failure_ too, so empty stderr is
    the only usable success criterion.
  - `~/.config/starship.toml` is generated too. Without it, starship uses its
    own defaults.

- **`~/.config/hypr/scripts/xdg.sh` does not exist.**
  `hyprland/.config/hypr/conf/autostart.conf:8` runs it on every login. It was
  never committed. Its stated job was XDG desktop portal setup for screen
  sharing.
- **`ghostty/.config/ghostty/config` does not `include` `theme.conf`.** The
  switcher writes the file; Ghostty never reads it. See
  [packages.md](packages.md).

No absolute path carrying a username is left in the tree, including symlink
targets.

Re-check with `git grep -n /home/` — it returns only this
document's own mentions of the pattern — plus
`git ls-tree -r HEAD | grep 120000`, because `git grep` does not read symlink
targets.
