# Hyprland Theme System

A comprehensive theming system for Hyprland with support for multiple themes and instant switching.

## Overview

This theme system provides a centralized way to manage visual themes across all Hyprland components including:

- **Hyprland** (window manager)
- **Waybar** (status bar)
- **Rofi** (application launcher)
- **SwayNC** (notification center)
- **Ghostty** (terminal emulator)
- **Starship** (shell prompt)

## Directory Structure

```
~/.config/themes/
├── current -> macos-dark/          # Symlink to active theme
├── macos-dark/                     # macOS dark theme
│   ├── colors.conf                 # Color definitions
│   ├── hyprland.conf               # Hyprland theme
│   ├── waybar.css                  # Waybar stylesheet
│   ├── rofi.rasi                   # Rofi theme
│   ├── swaync.css                  # SwayNC styles
│   ├── ghostty.conf                # Ghostty color palette
│   └── starship.toml               # Starship configuration
├── macos-light/                    # macOS light theme (future)
└── README.md                       # This file
```

## Quick Start

### List Available Themes

```bash
~/.config/scripts/theme-switch.sh list
```

### Switch Theme

```bash
~/.config/scripts/theme-switch.sh set macos-dark
```

### Check Current Theme

```bash
~/.config/scripts/theme-switch.sh current
```

### View System Status

```bash
~/.config/scripts/theme-switch.sh status
```

## Installation

The theme system is already installed! The following has been set up:

1. ✅ Theme directory structure created
2. ✅ macOS dark theme installed
3. ✅ Theme switcher script created and executable
4. ✅ Color definitions documented

## Using Themes

### Activate a Theme

To activate the macOS dark theme:

```bash
~/.config/scripts/theme-switch.sh set macos-dark
```

This will:
- Update the `current` symlink to point to the theme
- Apply the theme to all components
- Restart services that need reloading (Waybar, SwayNC)
- Save your preference for future sessions

### Components That Auto-Reload

- **Hyprland**: Automatically reloads via `hyprctl reload`
- **Waybar**: Restarts automatically
- **Rofi**: Picks up changes on next launch
- **SwayNC**: Reloads configuration and styles

### Components That Need Manual Restart

- **Ghostty**: Restart terminals to see new colors
- **Starship**: Reload shell (close and reopen or run `exec $SHELL`)

## Creating Custom Themes

### 1. Create Theme Directory

```bash
mkdir ~/.config/themes/my-theme
```

### 2. Create Color Definitions

Create `~/.config/themes/my-theme/colors.conf`:

```bash
#!/bin/bash
# My Custom Theme

export THEME_NAME="My Theme"
export THEME_TYPE="dark"  # or "light"
export THEME_VERSION="1.0"
export THEME_AUTHOR="your-name"

# Background colors
export THEME_BG_WINDOW="#1E1E1E"
export THEME_BG_PANEL="#282828"
# ... (see macos-dark/colors.conf for full template)
```

### 3. Create Component Theme Files

Create theme files for each component:

- `hyprland.conf` - Hyprland decorations
- `waybar.css` - Waybar stylesheet
- `rofi.rasi` - Rofi theme
- `swaync.css` - SwayNC styles
- `ghostty.conf` - Ghostty colors
- `starship.toml` - Starship palette

Refer to the `macos-dark/` theme as a template.

### 4. Activate Your Theme

```bash
~/.config/scripts/theme-switch.sh set my-theme
```

## Color System

### Color Tokens

The theme system uses semantic color tokens defined in `colors.conf`:

**Backgrounds:**
- `THEME_BG_WINDOW` - Main window background
- `THEME_BG_PANEL` - Panels and sidebars
- `THEME_BG_MENU` - Menus and dropdowns
- `THEME_BG_ELEVATED` - Elevated surfaces

**Foregrounds:**
- `THEME_FG_PRIMARY` - Primary text
- `THEME_FG_SECONDARY` - Secondary text
- `THEME_FG_TERTIARY` - Tertiary text

**Accents:**
- `THEME_ACCENT_BLUE` - Primary accent
- `THEME_ACCENT_GREEN` - Success states
- `THEME_ACCENT_RED` - Errors
- `THEME_ACCENT_YELLOW` - Warnings

**Semantic:**
- `THEME_ERROR` - Error states
- `THEME_WARNING` - Warning states
- `THEME_SUCCESS` - Success states
- `THEME_INFO` - Informational states

### Using Colors in Shell Scripts

```bash
# Source the current theme colors
source ~/.config/themes/current/colors.conf

# Use color variables
echo "Primary color: $THEME_ACCENT_BLUE"
```

## Integration with Config Files

### Hyprland

In `~/.config/hypr/hyprland.conf`, add:

```conf
# Source theme configuration
source = ~/.config/hypr/conf/theme.conf
```

The theme switcher will automatically update `theme.conf`.

### Waybar

In `~/.config/waybar/config`, ensure styles reference:

```json
{
  "layer": "top",
  "style": "/home/username/.config/waybar/style.css"
}
```

The theme switcher will automatically update `style.css`.

### Rofi

In `~/.config/rofi/config.rasi`, add:

```rasi
@theme "~/.config/rofi/theme.rasi"
```

The theme switcher will automatically update `theme.rasi`.

## Advanced Features

### Auto-Apply on Login

Add to your `~/.zshrc` or `~/.bashrc`:

```bash
# Auto-apply saved theme preference
if [ -f ~/.config/theme-preference ]; then
    SAVED_THEME=$(cat ~/.config/theme-preference)
    source ~/.config/themes/$SAVED_THEME/colors.conf
fi
```

### Theme Keybinding

Add to `~/.config/hypr/keybindings.conf`:

```conf
# Open theme selector (future feature)
bind = SUPER_SHIFT, T, exec, ~/.config/scripts/theme-switch.sh menu
```

### Shell Alias

Add to your shell rc file:

```bash
alias theme='~/.config/scripts/theme-switch.sh'
```

Usage:
```bash
theme list
theme set macos-dark
theme status
```

## Troubleshooting

### Theme Not Applying

1. Check theme exists:
   ```bash
   ls ~/.config/themes/
   ```

2. Verify theme is complete:
   ```bash
   ls ~/.config/themes/macos-dark/
   # Should show: colors.conf, hyprland.conf, waybar.css, etc.
   ```

3. Check logs:
   ```bash
   cat ~/.cache/theme-switch.log
   ```

### Components Not Updating

**Waybar not restarting:**
```bash
killall waybar
waybar &
```

**Hyprland not reloading:**
```bash
hyprctl reload
```

**Rofi not picking up theme:**
```bash
# Check if theme.rasi exists
ls -la ~/.config/rofi/theme.rasi
```

### Colors Look Wrong

1. Verify you're sourcing the right theme:
   ```bash
   ~/.config/scripts/theme-switch.sh current
   ```

2. Check the colors.conf file:
   ```bash
   cat ~/.config/themes/current/colors.conf
   ```

3. Test colors manually:
   ```bash
   source ~/.config/themes/current/colors.conf
   echo $THEME_ACCENT_BLUE
   ```

## Planned Features

- [ ] GUI theme selector (Rofi-based)
- [ ] Theme preview before applying
- [ ] Auto-theme switching (time-based)
- [ ] Light mode themes
- [ ] Theme export/import
- [ ] Per-app theme overrides
- [ ] Dynamic theme generation from wallpapers

## File Locations

| Component | Config Path | Theme Path |
|-----------|-------------|------------|
| Hyprland | `~/.config/hypr/conf/theme.conf` | Symlink |
| Waybar | `~/.config/waybar/style.css` | Symlink |
| Rofi | `~/.config/rofi/theme.rasi` | Symlink |
| SwayNC | `~/.config/swaync/style.css` | Symlink |
| Ghostty | `~/.config/ghostty/theme.conf` | Copy |
| Starship | `~/.config/starship.toml` | Symlink |

## Version History

### v1.0 (2025-11-09)
- Initial theme system implementation
- macOS dark theme created
- Theme switcher script with CLI interface
- Documentation completed

## Contributing

To contribute a new theme:

1. Create a theme directory in `~/.config/themes/`
2. Follow the structure of `macos-dark/`
3. Test with `theme-switch.sh set your-theme`
4. Submit your theme to the dotfiles repository

## License

MIT License - See main dotfiles repository for details

## Resources

- [macOS Design Spec](../../docs/macos-theme-spec.md) - Complete design specification
- [Hyprland Wiki](https://wiki.hyprland.org/) - Hyprland documentation
- [Waybar Wiki](https://github.com/Alexays/Waybar/wiki) - Waybar configuration guide
- [Rofi Themes](https://github.com/davatorium/rofi-themes) - Rofi theme examples

---

**Author:** qdrtech
**Version:** 1.0
**Last Updated:** 2025-11-09
