# Base Configurations

This directory contains **theme-independent** core configurations. These define the **structure, behavior, and functionality** of your desktop environment.

## Philosophy

**Base configs should contain:**
- ✅ Module structure and layout
- ✅ Keybindings and shortcuts
- ✅ Behavior and functionality
- ✅ Window rules and workspace setup
- ✅ Monitor configuration
- ✅ Autostart applications

**Base configs should NOT contain:**
- ❌ Colors and color schemes
- ❌ Opacity and blur values
- ❌ Border styles and shadows
- ❌ Font styling (size/weight can be base, color is theme)
- ❌ Decorative elements

## Directory Structure

```
base/
├── hyprland/           # Hyprland core configs
│   ├── monitors.conf      # Monitor setup
│   ├── keybinding.conf    # Keyboard shortcuts
│   ├── layout.conf        # Window layout rules
│   ├── misc.conf          # Misc settings
│   ├── environment.conf   # Environment variables
│   ├── autostart.conf     # Startup applications
│   ├── cursor.conf        # Cursor settings
│   ├── keyboard.conf      # Keyboard config
│   ├── window.conf        # Window behavior
│   ├── windowrule.conf    # Window rules
│   ├── workspace.conf     # Workspace setup
│   └── layerrule.conf     # Layer rules
│
├── waybar/            # Waybar core config
│   └── config            # Module structure (JSON)
│
├── rofi/              # Rofi core config
│   └── config.rasi       # Base settings
│
└── swaync/            # SwayNC core config
    └── config.json       # Notification settings
```

## How It Works

### 1. Base Configs are Sourced First

Your main config files source from `base/`:

**Example - Hyprland:**
```conf
# hyprland/.config/hypr/hyprland.conf
source = ~/.config/base/hyprland/monitors.conf
source = ~/.config/base/hyprland/keybinding.conf
# ... other base configs
source = ~/.config/hypr/conf/theme.conf  # Theme applied last
```

**Example - Waybar:**
```json
// waybar/.config/waybar/config is a symlink to:
// ~/.config/base/waybar/config
```

### 2. Themes Override Styling Only

Theme files contain **only** the values that change between themes:

**themes/default/hyprland-style.conf:**
```conf
decoration {
    rounding = 10
    blur { size = 12; passes = 10 }
    shadow { color = 0x66000000 }
}
general {
    gaps_in = 5
    gaps_out = 20
    border_size = 1
    col.active_border = rgb(33ccff)
    col.inactive_border = rgb(595959)
}
```

**themes/macos-dark/hyprland-style.conf:**
```conf
decoration {
    rounding = 12  # Different!
    blur { size = 12; passes = 3 }  # Different passes
    shadow { color = rgba(000000aa) }  # Different shadow
}
general {
    gaps_in = 8  # Different!
    gaps_out = 16
    border_size = 2  # Different!
    col.active_border = rgb(0A84FF)  # macOS blue
    col.inactive_border = rgb(3C3C3C)
}
```

### 3. Theme Switcher Applies Deltas

```bash
theme-switch.sh set macos-dark
→ Base configs stay unchanged
→ Only theme-specific styles are applied
→ Components reload to pick up new styles
```

## Benefits of This Approach

✅ **Easy theme creation** - Only define what's different
✅ **Less duplication** - Base config written once
✅ **Easier maintenance** - Change keybindings once, affects all themes
✅ **Cleaner themes** - Only colors and styling, easy to understand
✅ **Portable** - Base + theme = complete config

## Editing Guidelines

### When to Edit Base Configs

Edit base configs when you want to change:
- Add/remove a waybar module
- Change a keybinding
- Modify window rules
- Add monitor configuration
- Change workspace behavior

**These changes affect ALL themes.**

### When to Edit Theme Configs

Edit theme configs when you want to change:
- Colors and color schemes
- Border radius or shadow intensity
- Opacity and blur values
- Font colors (not structure)
- Decorative styling

**These changes affect ONLY that theme.**

## Migration from Old System

Previously, each theme contained full config files. The new system:

**Old:**
```
themes/macos-dark/
├── hyprland.conf        # Full config (1000+ lines)
├── waybar.css           # Full stylesheet
└── ...
```

**New:**
```
themes/macos-dark/
├── colors.conf          # Color tokens
├── hyprland-style.conf  # Just decoration/borders (50 lines)
├── waybar.css           # Just colors/styling (100 lines)
└── ...
```

Base configs handle the other 900 lines of functionality.

## Example: Adding a New Waybar Module

**Wrong approach:**
Edit each theme's waybar config individually ❌

**Right approach:**
1. Edit `base/waybar/config` - add module ✅
2. Edit each theme's `waybar.css` - style the module ✅

Now all themes have the new module with appropriate styling!

---

**Version:** 1.0
**Last Updated:** 2025-11-09
