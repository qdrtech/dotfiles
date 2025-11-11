# Configuration Split: Base vs Theme

This document defines what belongs in **base** configs vs **theme** configs for each component.

## Hyprland

### Base Configs (in `base/hyprland/`)
- `monitors.conf` - Monitor configuration
- `keybinding.conf` - All keybindings
- `layout.conf` - Layout algorithms (dwindle, master)
- `misc.conf` - Misc settings (vrr, dpms, etc.)
- `environment.conf` - Environment variables
- `autostart.conf` - Startup applications
- `cursor.conf` - Cursor configuration
- `keyboard.conf` - Keyboard layout/settings
- `window.conf` - Window behavior
- `windowrule.conf` - Window rules
- `workspace.conf` - Workspace configuration
- `layerrule.conf` - Layer rules
- `animation.conf` - Animation timing/curves (structure)

### Theme Configs (in `themes/*/`)
- `hyprland-style.conf` - Contains ONLY:
  ```conf
  decoration {
      rounding = X
      active_opacity = X
      inactive_opacity = X
      fullscreen_opacity = X

      blur {
          enabled = true/false
          size = X
          passes = X
          # ... blur settings
      }

      shadow {
          enabled = true/false
          range = X
          render_power = X
          color = XXXXXX
      }
  }

  general {
      gaps_in = X
      gaps_out = X
      border_size = X
      col.active_border = rgb(XXXXXX)
      col.inactive_border = rgb(XXXXXX)
      # ... border/gap styling
  }
  ```

---

## Waybar

### Base Config (in `base/waybar/`)
- `config` (JSON) - Contains ALL module definitions:
  - Module structure (`modules-left`, `modules-center`, `modules-right`)
  - Module configuration (format strings, icons, tooltips)
  - Module behavior (on-click actions, intervals)
  - Module groups and drawers

**Note:** Module configs can reference theme colors via CSS variables, but the structure stays in base.

### Theme Configs (in `themes/*/`)
- `waybar.css` - Contains ONLY:
  - Color definitions (CSS variables)
  - Font colors and styling
  - Background colors and opacity
  - Border colors and radius
  - Shadow and blur effects
  - Hover/active state colors

**Structure styling stays the same** (module layout, spacing), only colors/visual effects change.

**Example - what's in theme CSS:**
```css
/* Theme: default */
window#waybar {
    background: rgba(26, 27, 38, 0.9);  /* Theme-specific */
    color: #c0caf5;  /* Theme-specific */
}

#workspaces button.active {
    background: #7aa2f7;  /* Theme-specific */
}
```

**Example - what's in base config:**
```json
{
    "hyprland/workspaces": {
        "format": "{icon}",  /* Base structure */
        "format-icons": {    /* Base structure */
            "active": "",
            "default": ""
        }
    }
}
```

---

## Rofi

### Base Config (in `base/rofi/`)
- `config.rasi` - Contains:
  - Display settings (location, width, height)
  - Behavior (case-sensitivity, matching)
  - Module configuration
  - Font family (not color)
  - Icon settings

### Theme Configs (in `themes/*/`)
- `rofi.rasi` - Contains ONLY:
  - Color definitions
  - Background/foreground colors
  - Border colors
  - Selection colors
  - Font colors (not family)

---

## SwayNC

### Base Config (in `base/swaync/`)
- `config.json` - Contains:
  - Notification timeout
  - Control center position/size
  - Widget configuration
  - Script actions
  - Notification grouping

### Theme Configs (in `themes/*/`)
- `swaync.css` - Contains ONLY:
  - Color scheme
  - Background colors and opacity
  - Border colors
  - Font colors
  - Shadow and blur effects

---

## Ghostty

### Base Config (in main `ghostty/config`)
- Window behavior
- Shell integration
- Font family and size
- Keybindings
- Copy/paste behavior

### Theme Configs (in `themes/*/`)
- `ghostty.conf` - Contains ONLY:
  - Background/foreground colors
  - Cursor colors
  - Selection colors
  - ANSI palette (16 colors)

**OR use built-in themes:**
```conf
# themes/tokyonight/ghostty.conf
theme = tokyonight_night  # Reference built-in theme
```

---

## GTK

### Base Config
- Font family
- Font size
- Icon size
- Toolbar style
- Antialiasing settings

### Theme Configs (in `themes/*/`)
- `gtk.conf` - Contains:
  ```ini
  gtk-theme-name=Tokyonight-Dark
  gtk-icon-theme-name=Tokyonight-Moon
  gtk-application-prefer-dark-theme=1
  ```

**Note:** GTK themes are typically system-installed, so we just reference them.

---

## Starship

### Base Config
- Prompt structure
- Module order
- Module formats
- Scan timeout
- Command timeout

### Theme Configs (in `themes/*/`)
- `starship.toml` - Contains ONLY:
  - Palette definition
  - Color assignments for modules

**Example:**
```toml
# themes/default/starship.toml
palette = "default"

[palettes.default]
blue = "#7aa2f7"
green = "#9ece6a"
yellow = "#e0af68"
# ...
```

---

## Summary Table

| Component | Base Location | Theme Location | Theme Contains |
|-----------|--------------|----------------|----------------|
| **Hyprland** | `base/hyprland/*.conf` | `themes/*/hyprland-style.conf` | decoration, borders, gaps, colors |
| **Waybar** | `base/waybar/config` | `themes/*/waybar.css` | Colors, fonts, opacity, blur |
| **Rofi** | `base/rofi/config.rasi` | `themes/*/rofi.rasi` | Color definitions |
| **SwayNC** | `base/swaync/config.json` | `themes/*/swaync.css` | Colors, styling |
| **Ghostty** | `ghostty/config` | `themes/*/ghostty.conf` | Color palette OR theme ref |
| **GTK** | `gtk-3.0/settings.ini` | `themes/*/gtk.conf` | Theme name overrides |
| **Starship** | `starship/config.toml` | `themes/*/starship.toml` | Palette only |

---

## How Main Configs Source Base + Theme

### Hyprland Main Config

```conf
# hyprland/.config/hypr/hyprland.conf

# Source all base configs (structure/behavior)
source = ~/.config/base/hyprland/monitors.conf
source = ~/.config/base/hyprland/keybinding.conf
source = ~/.config/base/hyprland/layout.conf
source = ~/.config/base/hyprland/misc.conf
source = ~/.config/base/hyprland/environment.conf
source = ~/.config/base/hyprland/autostart.conf
source = ~/.config/base/hyprland/cursor.conf
source = ~/.config/base/hyprland/keyboard.conf
source = ~/.config/base/hyprland/animation.conf
source = ~/.config/base/hyprland/window.conf
source = ~/.config/base/hyprland/windowrule.conf
source = ~/.config/base/hyprland/workspace.conf
source = ~/.config/base/hyprland/layerrule.conf

# Source theme config LAST (overrides styling)
source = ~/.config/hypr/conf/theme.conf  # Symlink to current theme
```

### Waybar

```bash
# waybar/.config/waybar/config is a SYMLINK to:
~/.config/base/waybar/config

# waybar/.config/waybar/style.css is a SYMLINK to:
~/.config/themes/current/waybar.css
```

### Rofi

```rasi
// rofi/.config/rofi/config.rasi
@import "~/.config/base/rofi/config.rasi"
@theme "~/.config/rofi/theme.rasi"  // Symlink to current theme
```

---

## Migration Checklist

When migrating an existing config to this system:

- [ ] Identify what's structure vs styling
- [ ] Move structure/behavior to `base/`
- [ ] Extract colors/styling to theme
- [ ] Test that base + theme = working config
- [ ] Update main config to source both
- [ ] Document any exceptions

---

**Version:** 1.0
**Last Updated:** 2025-11-09
