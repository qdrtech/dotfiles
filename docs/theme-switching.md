# Theme switching

There is one theme switcher: `scripts/theme-switch.sh`, aliased to `ts`
(`zshrc/.zshrc:21`). It is palette-first — a theme is ten colour variables, and
the switcher generates every per-application colour file from them.

The older file-first switcher (`config/.config/scripts/theme-switch.sh`), which
symlinked whole per-component files into place, has been removed. Its SwayNC and
Starship coverage was carried over.

## Applying this change on a machine that already had the old switcher

Four things go unstyled the moment the change lands, and stay that way until the
switcher is run once:

- `~/.config/rofi/theme-colors.rasi` and `generated-theme.rasi` are deleted, so
  `config.rasi:9` has no theme to load.
- `~/.config/swaync/style.css` stops being a per-theme symlink and becomes a
  real file whose first line is `@import url("theme-colors.css")` — a file that
  has never existed here. SwayNC comes up unstyled.
- `~/.config/starship.toml` pointed into the deleted `default` theme, so it
  dangles and Starship falls back to its built-in prompt.
- `~/.config/ghostty/theme.conf` is deleted. Nothing `include`s it, so nothing
  changes visibly.

**Do not run `ts` in a shell you already had open.** `ts` is a zsh alias, fixed
at shell start; a shell that predates the change still holds the old
`sh ~/.config/scripts/theme-switch.sh`, and `~/.config/scripts` is a symlink
into this repo, where that script no longer exists. `ts set macos-dark` there
fails with *no such file*, in exactly the window where rofi, SwayNC and Starship
are unstyled. Reload the alias first:

```sh
exec zsh && ts set macos-dark
```

or skip the alias entirely:

```sh
bash "${DOTFILES_DIR:-$HOME/dotfiles}/scripts/theme-switch.sh" set macos-dark
```

Hyprland and Waybar read untracked files in real `~/.config` directories that
this change never touches, so the bar and the window borders stay themed
throughout.

## A theme is ten variables

`themes/.config/themes/<name>/colors.conf`:

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

Nothing else in a theme directory is read. Values must be `#RRGGBB`: Waybar,
Rofi, SwayNC, Ghostty and Starship interpolate them verbatim, and the Hyprland
`0xffRRGGBB` form is produced by `hex_with_alpha` in the script — so a palette
file must never contain a `0x` value.

Shipped themes: `macos-dark`, `tokyonight`.

`macos-dark` is the reference machine's live palette, recovered from
`ea8edf1:themes/macos-dark/colors.conf`. That file was deleted by `7658a3b`
(2026-05-07), which is what broke theming: no committed theme was left in the
format the switcher reads, so every theme fell through to the script's hardcoded
Catppuccin defaults and rendered identically. Applying `macos-dark` reproduces
`~/.config/hypr/theme-colors.conf`, `~/.config/waybar/theme-colors.css` and
`~/.config/ghostty/theme.conf` byte for byte.

A third theme, `default`, was deleted. Its colour values were byte-identical to
`tokyonight`'s, its component files were copies of `macos-dark`'s, and its
waybar stylesheet was pywal-driven — three mutually exclusive identities and
nothing in the repo to arbitrate between them. See issue #43.

## Usage

```
Usage: theme-switch.sh <command> [args]

Commands:
  list                     List available themes
  current                  Show the currently linked theme
  set [--no-reload] <name> Switch to the specified theme (reload Hyprland unless --no-reload)
  help                     Show this help message

Environment overrides:
  THEMES_DIR           Path to themes directory (default: repo/themes/.config/themes)
```

`NO_HYPR_RELOAD=1` also suppresses the Hyprland reload.

## What `set` writes

Bookkeeping:

- `~/.config/themes/current` — symlink to the chosen theme directory
- `~/.config/themes/colors.conf` — symlink to the active palette
- `~/.config/themes/current.txt` — the active theme name

Generated colour files:

| File | Consumed by |
| --- | --- |
| `~/.config/hypr/theme-colors.conf` | `hyprland.conf:22` sources it; `conf/theme.conf` uses `$bg $surface $surface_alt $fg $fg_muted $accent $accent_alt $warn $error $success` |
| `~/.config/waybar/theme-colors.css` | `waybar/style.css:1` `@import url("theme-colors.css")` |
| `~/.config/rofi/theme-colors.rasi` | imported by `generated-theme.rasi` |
| `~/.config/rofi/generated-theme.rasi` | `rofi/config.rasi:9` `@theme "generated-theme.rasi"` |
| `~/.config/swaync/theme-colors.css` | `swaync/style.css:1` `@import url("theme-colors.css")` |
| `~/.config/ghostty/theme.conf` | nothing — `ghostty/config` does not `include` it |
| `~/.config/starship.toml` | `starship init zsh` (`zshrc/.zshrc:29`) |

After a successful `set`, Hyprland is reloaded via `hyprctl reload` and SwayNC
via `swaync-client --reload-config --reload-css`, unless `--no-reload` is given.
Waybar is not restarted; restart it by hand or with
`waybar/.config/waybar/scripts/`.

### Starship

The old switcher symlinked each theme's own `starship.toml`. The replacement
generates `~/.config/starship.toml` instead: the prompt layout is fixed in the
script and only the `[palettes.theme]` block changes per theme. If a
non-generated `starship.toml` is found, it is copied to
`starship.toml.backup-<timestamp>` before the first overwrite.

## Generated files are not tracked

`~/.config/ghostty`, `~/.config/rofi` and `~/.config/swaync` are folded stow
symlinks into this repo, so the switcher writes its output straight into the
working tree. Those four paths are listed in `.gitignore`:

```
ghostty/.config/ghostty/theme.conf
rofi/.config/rofi/theme-colors.rasi
rofi/.config/rofi/generated-theme.rasi
swaync/.config/swaync/theme-colors.css
```

The consequence on a fresh clone is that they do not exist until `ts set <name>`
is run once. Rofi in particular falls back to its built-in theme until then —
see [installation.md](installation.md).

## Rofi output format

Rofi 2.0.0 rejects two things the switcher used to emit:

- the top-level `@name: value;` declaration form, and
- underscores in property names (`surface_alt`, `fg_muted`, `accent_alt`).

Both were present in the old `theme-colors.rasi`, so it failed to parse
(`rofi -no-config -theme <file> -dump-theme` warned `Failed to parse theme`) and
rofi theming was broken independently of the palette problem. The switcher now
emits a `* { }` block with hyphenated names:

```rasi
* {
    bg:          #0f1115;
    surface-alt: #0f1115;
    /* Aliases for the names config.rasi references. */
    background:  @bg;
    foreground:  @fg;
    color11:     @accent;
}
```

`config.rasi` references `@background`, `@foreground` and `@color11` — names
inherited from pywal's rofi template — so the switcher defines them as aliases
onto the palette. `config.rasi` also references `@border-width`,
`@border-radius` and `@current-image`, which come from
`config/.config/settings/*.rasi` and `config/.config/cache/current_wallpaper.rasi`.
Nothing imports those fragments today; that is unchanged and unrelated to
colour.

## Leftovers on the reference machine

Deployed state that predates this switcher and is not recreated:

- `~/.config/themes/{default,macos-dark,tokyonight,README.md}` — per-entry
  symlinks from an older stow run. `default` now dangles and can be deleted.
- `~/.config/hypr/theme.conf` — a stray copy at the `hypr` root rather than in
  `conf/`. Nothing sources it; `hyprland.conf:41` sources `conf/theme.conf`.
- `~/.config/base` — dangling; only the removed file-first switcher used it.
- `~/.config/hypr/mocha.conf` — dangling since the `hyprmocha` package was
  deleted in `5a2c847`. Nothing sources it.
- `~/hyprland.conf` — dangling since the stub at the `hyprland` package root was
  deleted. Nothing sources it.

Safe to delete:

```sh
rm ~/.config/themes/default ~/.config/hypr/mocha.conf ~/hyprland.conf
```

## Design specs

`docs/macos-theme-spec.md` and `docs/warm-theme-design-spec.md` are aspirational
design documents. They describe intended visual direction, and they disagree
with the recovered `macos-dark` palette in several slots (the spec says
`WARN=#FFD60A`; the live value is `#ffc934`). The palette is what renders — do
not read the specs as descriptions of current behaviour.
