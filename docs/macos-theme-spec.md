# macOS-Inspired Hyprland Theme — Complete System Design Spec

> Comprehensive design specification for implementing a macOS-inspired visual theme across the entire Hyprland desktop environment. This document covers all themeable components, establishes a unified color palette based on macOS design language, and outlines a theme switcher architecture. **This is a planning document** — no code implementation yet.

---

## 1. Theme Identity & Design Philosophy

### **Name:** `macos-hyprland`

### **Design Goals:**
- **Visual Harmony:** Replicate macOS's refined, cohesive aesthetic across all UI components
- **Subtle Elegance:** Low-contrast, sophisticated color palette with tasteful transparency
- **Consistency:** Unified design language from window manager to terminal to notifications
- **Flexibility:** Support both light and dark modes with seamless switching
- **Authenticity:** Use genuine macOS system fonts (SF Pro, SF Mono) where possible

### **Core Design Principles:**
1. **Translucency & Blur:** Vibrancy effects on panels, menus, and notifications
2. **Refined Typography:** SF Pro family for UI, SF Mono for code
3. **Subtle Shadows:** Soft, realistic drop shadows (not harsh glows)
4. **Rounded Corners:** Consistent 10-12px radius across all UI elements
5. **Purposeful Color:** Accent colors (blue) used sparingly and meaningfully
6. **Spatial Hierarchy:** Clear distinction between chrome (UI) and content

---

## 2. macOS Color Palette

### **2.1 Dark Mode (Primary)**

Based on macOS Sequoia/Sonoma dark appearance:

| Token | Hex | RGB | Usage |
|-------|-----|-----|-------|
| **System Backgrounds** | | | |
| `bg.window` | `#1E1E1E` | (30,30,30) | Main window background |
| `bg.panel` | `#282828` | (40,40,40) | Panels, sidebars (with blur) |
| `bg.menu` | `#2D2D2D` | (45,45,45) | Dropdown menus, context menus |
| `bg.elevated` | `#323232` | (50,50,50) | Elevated surfaces (floating windows) |
| `bg.header` | `#242424` | (36,36,36) | Title bars, headers |
| **Text & Content** | | | |
| `fg.primary` | `#FFFFFF` | (255,255,255) | Primary text (87% opacity) |
| `fg.secondary` | `#A0A0A0` | (160,160,160) | Secondary text (55% opacity) |
| `fg.tertiary` | `#6E6E6E` | (110,110,110) | Disabled/tertiary text (25% opacity) |
| `fg.placeholder` | `#545454` | (84,84,84) | Placeholder text |
| **Accents** | | | |
| `accent.blue` | `#0A84FF` | (10,132,255) | Primary system accent |
| `accent.blue.hover` | `#0070E0` | (0,112,224) | Hover state |
| `accent.blue.pressed` | `#005CC8` | (0,92,200) | Pressed state |
| `accent.purple` | `#BF5AF2` | (191,90,242) | Alternative accent |
| `accent.pink` | `#FF375F` | (255,55,95) | Alerts, destructive |
| `accent.orange` | `#FF9F0A` | (255,159,10) | Warnings |
| `accent.yellow` | `#FFD60A` | (255,214,10) | Cautions |
| `accent.green` | `#32D74B` | (50,215,75) | Success, confirmations |
| `accent.teal` | `#64D2FF` | (100,210,255) | Info, links |
| **Semantic Colors** | | | |
| `semantic.error` | `#FF453A` | (255,69,58) | Errors, failures |
| `semantic.warning` | `#FFD60A` | (255,214,10) | Warnings |
| `semantic.success` | `#32D74B` | (50,215,75) | Success states |
| `semantic.info` | `#64D2FF` | (100,210,255) | Informational |
| **UI Chrome** | | | |
| `border.default` | `#3C3C3C` | (60,60,60) | Standard borders |
| `border.focus` | `#0A84FF` | (10,132,255) | Focused element borders |
| `separator` | `#414141` | (65,65,65) | Dividers, separators |
| `shadow` | `#000000` @ 30% | rgba(0,0,0,0.3) | Drop shadows |

### **2.2 Light Mode (Secondary)**

Based on macOS light appearance:

| Token | Hex | RGB | Usage |
|-------|-----|-----|-------|
| **System Backgrounds** | | | |
| `bg.window` | `#FFFFFF` | (255,255,255) | Main window background |
| `bg.panel` | `#F5F5F5` | (245,245,245) | Panels, sidebars (with blur) |
| `bg.menu` | `#FCFCFC` | (252,252,252) | Dropdown menus |
| `bg.elevated` | `#FAFAFA` | (250,250,250) | Elevated surfaces |
| `bg.header` | `#EBEBEB` | (235,235,235) | Title bars |
| **Text & Content** | | | |
| `fg.primary` | `#000000` | (0,0,0) | Primary text (87% opacity) |
| `fg.secondary` | `#3C3C43` | (60,60,67) | Secondary text (60% opacity) |
| `fg.tertiary` | `#8E8E93` | (142,142,147) | Tertiary text (30% opacity) |
| **Accents** | | | |
| `accent.blue` | `#007AFF` | (0,122,255) | Primary system accent |
| `accent.blue.hover` | `#0051D5` | (0,81,213) | Hover state |
| `accent.green` | `#34C759` | (52,199,89) | Success |
| `semantic.error` | `#FF3B30` | (255,59,48) | Errors |

### **2.3 Transparency & Blur Values**

| Surface | Opacity | Blur Radius | Usage |
|---------|---------|-------------|-------|
| Window backgrounds | 95% | 0px | Solid content areas |
| Panels (waybar, sidebar) | 70% | 20px | Toolbars, status bars |
| Menus (rofi, wofi) | 75% | 30px | Dropdowns, launchers |
| Notifications | 80% | 25px | SwayNC notifications |
| Tooltips | 90% | 15px | Hover tooltips |
| Inactive windows | 90% | 0px | Background windows |

---

## 3. Typography System

### **3.1 Font Families**

**Primary (UI):**
```
SF Pro Display (Headings, Titles)
SF Pro Text (Body Text, UI Labels)
SF Pro Rounded (Optional alternative for friendly UI)
```

**Monospace (Code/Terminal):**
```
.SF NS Mono (Primary — already configured)
SF Mono (Alternative naming)
Menlo (Fallback)
```

**Fallback Stack:**
```css
/* UI */
font-family: "SF Pro Text", -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;

/* Monospace */
font-family: ".SF NS Mono", "SF Mono", "Menlo", "Consolas", monospace;
```

### **3.2 Type Scale**

| Use Case | Font | Size | Weight | Line Height |
|----------|------|------|--------|-------------|
| **Waybar modules** | SF Pro Text | 13px | 500 (Medium) | 1.2 |
| **Rofi entries** | SF Pro Text | 14px | 400 (Regular) | 1.4 |
| **Rofi selected** | SF Pro Text | 14px | 600 (Semibold) | 1.4 |
| **Notifications title** | SF Pro Display | 15px | 600 (Semibold) | 1.3 |
| **Notifications body** | SF Pro Text | 13px | 400 (Regular) | 1.5 |
| **Terminal** | .SF NS Mono | 14px | 400 (Regular) | 1.4 |
| **Menu items** | SF Pro Text | 13px | 400 (Regular) | 1.4 |
| **Tooltips** | SF Pro Text | 12px | 400 (Regular) | 1.3 |

### **3.3 Font Features**

Enable OpenType features for enhanced rendering:

```css
font-feature-settings:
  "calt" 1,  /* Contextual alternates */
  "liga" 1,  /* Ligatures */
  "kern" 1,  /* Kerning */
  "tnum" 0;  /* Proportional numerals (not tabular) */
```

For monospace fonts (terminal):
```
font-feature-settings:
  "calt" 1,  /* Contextual alternates */
  "liga" 1,  /* Programming ligatures */
  "zero" 1;  /* Slashed zero */
```

---

## 4. Component Theming Specifications

### **4.1 Hyprland (Window Manager)**

**File:** `~/.config/hypr/conf/decoration.conf`

**Visual Properties:**
- **Border radius:** 12px (macOS window corners)
- **Border width:** 2px
- **Border colors:**
  - Active: `accent.blue` (#0A84FF) with subtle glow
  - Inactive: `border.default` (#3C3C3C)
- **Gaps:**
  - Inner: 8px
  - Outer: 16px
- **Shadows:**
  - Enabled: true
  - Range: 20
  - Render power: 3
  - Color: rgba(0,0,0,0.4)
  - Offset: [0, 4]
- **Blur:**
  - Size: 12
  - Passes: 3
  - New optimizations: true
  - Xray: false
  - Noise: 0.02
  - Contrast: 0.95
  - Brightness: 0.98
- **Opacity:**
  - Active windows: 1.0
  - Inactive windows: 0.95
  - Fullscreen: 1.0

**Animations:**
- Bezier curves: `easeOutExpo` (0.16, 1, 0.3, 1) — macOS-style smooth easing
- Window open/close: slide + fade
- Workspace transitions: slide with slight scale
- Duration: 250-300ms

---

### **4.2 Waybar (Status Bar)**

**Files:**
- `~/.config/waybar/config` (modules configuration)
- `~/.config/waybar/style-macos.css` (new theme file)

**Layout Philosophy:**
- **Top bar only** (classic macOS menu bar position)
- **Translucent background** with blur
- **Grouped modules** with subtle dividers
- **Icon + text hybrid** (not icon-only)

**Visual Design:**
```css
/* Global */
background: bg.panel @ 70% opacity + 20px blur
height: 32px
padding: 0 12px
border-bottom: 1px solid separator
font: SF Pro Text 13px Medium

/* Modules */
module-padding: 6px 12px
module-margin: 0 4px
module-border-radius: 6px
module-background: transparent
module-background-hover: rgba(255,255,255,0.05)
module-background-active: rgba(255,255,255,0.08)

/* Workspaces */
workspace-default: fg.secondary
workspace-active: accent.blue with bg fill
workspace-urgent: accent.orange
workspace-size: 24px × 24px circles
workspace-gap: 4px

/* Tray */
tray-spacing: 8px
tray-icon-size: 16px

/* Clock */
clock-format: "%a %b %d  %I:%M %p"
clock-color: fg.primary
```

**Module Priority (Left to Right):**
```
[Left]
- Workspaces (5-10 circles)
- Window title (fade out with ellipsis)

[Center]
- (Empty — clean look)

[Right]
- Media player (if active)
- System tray
- Network
- Bluetooth
- Volume
- Battery
- Clock
```

---

### **4.3 Rofi (Application Launcher)**

**Files:**
- `~/.config/rofi/config-macos.rasi`
- `~/.config/rofi/theme-macos.rasi`

**Layout:**
- **Window:** Centered, 600×450px
- **Orientation:** Vertical list
- **Prompt:** Top-aligned with search icon
- **Transparency:** 75% with 30px blur

**Visual Design:**
```rasi
window {
  background-color: bg.menu @ 75% opacity;
  border: 1px solid border.default;
  border-radius: 12px;
  padding: 16px;
  width: 600px;
}

inputbar {
  background-color: bg.elevated;
  border-radius: 8px;
  padding: 12px 16px;
  margin: 0 0 12px 0;
  text-color: fg.primary;
  font: "SF Pro Text 14px";
}

listview {
  lines: 8;
  spacing: 2px;
  scrollbar: false;
}

element {
  padding: 10px 12px;
  border-radius: 6px;
  text-color: fg.primary;
}

element selected {
  background-color: accent.blue;
  text-color: #FFFFFF;
}

element-icon {
  size: 24px;
  margin: 0 12px 0 0;
}
```

**Behavior:**
- **Fuzzy matching:** Enabled
- **Show icons:** Yes (24×24px)
- **Case sensitivity:** Smart
- **Sorting:** Frecency-based

---

### **4.4 SwayNC (Notification Center)**

**Files:**
- `~/.config/swaync/config.json`
- `~/.config/swaync/style-macos.css`

**Notification Design:**
```css
/* Individual Notification */
notification {
  background: bg.panel @ 80% opacity + 25px blur;
  border: 1px solid border.default;
  border-radius: 10px;
  padding: 12px 16px;
  margin: 8px;
  box-shadow: 0 4px 16px shadow;
  max-width: 400px;
}

notification-title {
  font: SF Pro Display 15px Semibold;
  color: fg.primary;
  margin-bottom: 4px;
}

notification-body {
  font: SF Pro Text 13px Regular;
  color: fg.secondary;
  line-height: 1.5;
}

notification-icon {
  size: 48px;
  border-radius: 8px;
  margin-right: 12px;
}

/* Notification Center Panel */
control-center {
  background: bg.panel @ 75% opacity + 30px blur;
  border: 1px solid border.default;
  border-radius: 12px;
  padding: 16px;
  width: 420px;
}

/* Urgency Levels */
notification.low { border-left: 3px solid fg.tertiary; }
notification.normal { border-left: 3px solid accent.blue; }
notification.critical {
  border-left: 3px solid semantic.error;
  animation: pulse 2s infinite;
}
```

**Behavior:**
- **Position:** Top-right, 16px margin
- **Timeout:** 5s (normal), 0s (critical)
- **Max notifications:** 5 visible
- **Close button:** macOS-style ✕ in top-right corner
- **Actions:** Inline buttons with accent.blue background

---

### **4.5 Ghostty (Terminal)**

**File:** `~/.config/ghostty/config`

**Already Configured:**
```ini
theme = tokyonight_night  # Replace with macos-dark
font-family = .SF NS Mono
font-size = 14
font-feature = +calt
font-feature = +liga
background-blur-radius = 20
background-opacity = 0.95
```

**New macOS Theme Values:**
```ini
# Background
background = #1E1E1E
foreground = #FFFFFF @ 87%

# Cursor
cursor-color = #0A84FF
cursor-text = #FFFFFF

# Selection
selection-background = #0A84FF @ 30%
selection-foreground = #FFFFFF

# ANSI Colors (macOS Terminal.app palette)
palette = 0=#000000
palette = 1=#C91B00
palette = 2=#00C200
palette = 3=#C7C400
palette = 4=#0225C7
palette = 5=#CA30C7
palette = 6=#00C5C7
palette = 7=#C7C7C7
palette = 8=#676767
palette = 9=#FF6D67
palette = 10=#5FF967
palette = 11=#FEFB67
palette = 12=#6871FF
palette = 13=#FF76FF
palette = 14=#5FFDFF
palette = 15=#FEFFFF
```

---

### **4.6 Wofi (Alternative Launcher)**

**File:** `~/.config/wofi/style-macos.css`

Similar to Rofi but adapted for Wofi's CSS format:

```css
window {
  background-color: rgba(45, 45, 45, 0.75);
  backdrop-filter: blur(30px);
  border: 1px solid #3C3C3C;
  border-radius: 12px;
  font-family: "SF Pro Text";
  font-size: 14px;
}

#input {
  background-color: #323232;
  border-radius: 8px;
  padding: 12px 16px;
  margin: 16px;
  color: #FFFFFF;
  border: none;
}

#entry:selected {
  background-color: #0A84FF;
  color: #FFFFFF;
  border-radius: 6px;
}

#entry:hover {
  background-color: rgba(10, 132, 255, 0.2);
}
```

---

### **4.7 GTK 3.0/4.0**

**File:** `~/.config/gtk-3.0/settings.ini`

```ini
[Settings]
gtk-theme-name = WhiteSur-Dark  # macOS-like GTK theme
gtk-icon-theme-name = WhiteSur  # macOS-style icons
gtk-font-name = SF Pro Text 10
gtk-cursor-theme-name = macOS-cursors
gtk-cursor-theme-size = 24
gtk-application-prefer-dark-theme = 1
gtk-enable-animations = true
gtk-primary-button-warps-slider = false
gtk-decoration-layout = close,minimize,maximize:
```

**GTK CSS Overrides:**
`~/.config/gtk-3.0/gtk.css`
```css
/* Force macOS-style window controls */
headerbar button.titlebutton {
  min-width: 12px;
  min-height: 12px;
  border-radius: 50%;
  padding: 0;
}

headerbar button.titlebutton.close { background-color: #FF5F57; }
headerbar button.titlebutton.minimize { background-color: #FFBD2E; }
headerbar button.titlebutton.maximize { background-color: #28CA42; }
```

---

### **4.8 Hyprlock (Lock Screen)**

**File:** `~/.config/hypr/hyprlock.conf`

**Design:**
- **Background:** Blurred wallpaper (40px blur) with dark overlay (40% black)
- **Clock:** Large SF Pro Display, centered
- **Input field:** Rounded, translucent, with subtle border
- **Avatar:** Circular, 128px, top-center

```conf
general {
  grace = 0
  hide_cursor = true
  ignore_empty_input = true
}

background {
  path = ~/wallpapers/current
  blur_passes = 3
  blur_size = 8
  brightness = 0.6
}

label {
  text = cmd[update:1000] echo "$(date +'%A, %B %d')"
  color = rgba(255, 255, 255, 0.87)
  font_size = 64
  font_family = SF Pro Display Medium
  position = 0, 240
  halign = center
  valign = center
}

input-field {
  size = 300, 50
  outline_thickness = 2
  dots_size = 0.2
  dots_spacing = 0.4
  outer_color = rgba(10, 132, 255, 0.8)
  inner_color = rgba(40, 40, 40, 0.9)
  font_color = rgba(255, 255, 255, 0.87)
  fade_on_empty = false
  placeholder_text = <i>Enter Password...</i>
  hide_input = false
  position = 0, 80
  halign = center
  valign = center
}
```

---

### **4.9 Starship (Shell Prompt)**

**File:** `~/.config/starship.toml`

**Palette:** Custom macOS-inspired

```toml
palette = "macos"

[palettes.macos]
blue = "#0A84FF"
green = "#32D74B"
yellow = "#FFD60A"
red = "#FF453A"
purple = "#BF5AF2"
cyan = "#64D2FF"
white = "#FFFFFF"
gray = "#A0A0A0"

[character]
success_symbol = "[❯](bold blue)"
error_symbol = "[❯](bold red)"

[directory]
style = "bold cyan"
truncation_length = 3
format = "[$path]($style)[$read_only]($read_only_style) "

[git_branch]
style = "bold purple"
format = "on [$symbol$branch]($style) "

[git_status]
style = "bold yellow"
```

---

## 5. Theme Switcher Architecture

### **5.1 Requirements**

- **Multi-theme support:** Dark, Light, Auto (follows time/location)
- **Instant switching:** All components update simultaneously
- **Persistent:** Theme choice saved across reboots
- **Scriptable:** CLI tool for theme changes
- **GUI option:** Rofi/Wofi menu for visual selection

### **5.2 Directory Structure**

```
~/.config/
├── themes/
│   ├── current -> macos-dark/  # Symlink to active theme
│   ├── macos-dark/
│   │   ├── colors.conf         # Central color definitions
│   │   ├── hyprland.conf       # Hyprland-specific colors
│   │   ├── waybar.css          # Waybar stylesheet
│   │   ├── rofi.rasi           # Rofi theme
│   │   ├── swaync.css          # SwayNC styles
│   │   ├── wofi.css            # Wofi styles
│   │   ├── ghostty.conf        # Ghostty theme
│   │   ├── gtk.css             # GTK overrides
│   │   └── starship.toml       # Starship palette
│   ├── macos-light/
│   │   └── (same structure)
│   └── catppuccin-mocha/       # Existing theme (for comparison)
│       └── (same structure)
├── scripts/
│   ├── theme-switch.sh         # Main theme switcher
│   ├── theme-apply.sh          # Apply theme to all components
│   └── theme-preview.sh        # Preview theme before applying
```

### **5.3 Central Color Definition Format**

**File:** `~/.config/themes/macos-dark/colors.conf`

```bash
#!/bin/bash
# macOS Dark Theme Color Definitions
# Source this file to get theme variables

# Background colors
export THEME_BG_WINDOW="#1E1E1E"
export THEME_BG_PANEL="#282828"
export THEME_BG_MENU="#2D2D2D"
export THEME_BG_ELEVATED="#323232"

# Foreground colors
export THEME_FG_PRIMARY="#FFFFFF"
export THEME_FG_SECONDARY="#A0A0A0"
export THEME_FG_TERTIARY="#6E6E6E"

# Accent colors
export THEME_ACCENT_BLUE="#0A84FF"
export THEME_ACCENT_GREEN="#32D74B"
export THEME_ACCENT_RED="#FF453A"
export THEME_ACCENT_YELLOW="#FFD60A"
export THEME_ACCENT_PURPLE="#BF5AF2"
export THEME_ACCENT_CYAN="#64D2FF"

# Semantic colors
export THEME_ERROR="#FF453A"
export THEME_WARNING="#FFD60A"
export THEME_SUCCESS="#32D74B"
export THEME_INFO="#64D2FF"

# UI chrome
export THEME_BORDER="#3C3C3C"
export THEME_SEPARATOR="#414141"
export THEME_SHADOW="rgba(0,0,0,0.3)"

# Opacity values
export THEME_OPACITY_WINDOW="0.95"
export THEME_OPACITY_PANEL="0.70"
export THEME_OPACITY_MENU="0.75"

# Blur values
export THEME_BLUR_PANEL="20"
export THEME_BLUR_MENU="30"

# Fonts
export THEME_FONT_UI="SF Pro Text"
export THEME_FONT_MONO=".SF NS Mono"
export THEME_FONT_DISPLAY="SF Pro Display"
```

### **5.4 Theme Switcher Script**

**File:** `~/.config/scripts/theme-switch.sh`

**Pseudocode:**
```bash
#!/bin/bash
# Theme switcher for Hyprland macOS setup

THEMES_DIR="$HOME/.config/themes"
CURRENT_LINK="$THEMES_DIR/current"

function list_themes() {
  # List available themes from themes directory
  ls -1 "$THEMES_DIR" | grep -v current
}

function get_current_theme() {
  # Return name of currently active theme
  basename "$(readlink -f "$CURRENT_LINK")"
}

function set_theme() {
  THEME_NAME="$1"
  THEME_PATH="$THEMES_DIR/$THEME_NAME"

  # Validate theme exists
  if [ ! -d "$THEME_PATH" ]; then
    echo "Theme '$THEME_NAME' not found"
    exit 1
  fi

  # Update symlink
  ln -sfn "$THEME_PATH" "$CURRENT_LINK"

  # Apply theme to all components
  apply_hyprland
  apply_waybar
  apply_rofi
  apply_swaync
  apply_ghostty
  apply_gtk

  # Save preference
  echo "$THEME_NAME" > "$HOME/.config/theme-preference"

  echo "Theme switched to: $THEME_NAME"
}

function apply_hyprland() {
  # Copy theme-specific Hyprland config
  cp "$CURRENT_LINK/hyprland.conf" "$HOME/.config/hypr/conf/theme.conf"
  hyprctl reload
}

function apply_waybar() {
  # Link waybar stylesheet
  ln -sf "$CURRENT_LINK/waybar.css" "$HOME/.config/waybar/style.css"
  killall waybar
  waybar &
}

function apply_rofi() {
  # Link rofi theme
  ln -sf "$CURRENT_LINK/rofi.rasi" "$HOME/.config/rofi/theme.rasi"
}

function apply_swaync() {
  # Link swaync styles
  ln -sf "$CURRENT_LINK/swaync.css" "$HOME/.config/swaync/style.css"
  swaync-client --reload-config
  swaync-client --reload-css
}

function apply_ghostty() {
  # Append theme to ghostty config (or source it)
  # Note: Ghostty may need restart
  cat "$CURRENT_LINK/ghostty.conf" > "$HOME/.config/ghostty/theme.conf"
}

function apply_gtk() {
  # Update GTK settings via gsettings
  source "$CURRENT_LINK/colors.conf"
  # Set GTK theme based on variables
  gsettings set org.gnome.desktop.interface gtk-theme "WhiteSur-Dark"
}

# CLI Interface
case "$1" in
  list)
    list_themes
    ;;
  current)
    get_current_theme
    ;;
  set)
    set_theme "$2"
    ;;
  menu)
    # Launch rofi menu for theme selection
    SELECTED=$(list_themes | rofi -dmenu -p "Select Theme")
    if [ -n "$SELECTED" ]; then
      set_theme "$SELECTED"
    fi
    ;;
  *)
    echo "Usage: theme-switch.sh {list|current|set THEME|menu}"
    ;;
esac
```

### **5.5 Integration Points**

**Hyprland Config:**
```conf
# ~/.config/hypr/hyprland.conf
source = ~/.config/themes/current/hyprland.conf
```

**Waybar Config:**
```css
/* ~/.config/waybar/style.css */
@import url("../themes/current/waybar.css");
```

**Shell RC:**
```bash
# ~/.zshrc
source ~/.config/themes/current/colors.conf

# Auto-apply theme on shell start
if [ -f ~/.config/scripts/theme-apply.sh ]; then
  ~/.config/scripts/theme-apply.sh --silent
fi
```

**Keybinding:**
```conf
# ~/.config/hypr/keybindings.conf
bind = SUPER_SHIFT, T, exec, ~/.config/scripts/theme-switch.sh menu
```

---

## 6. Implementation Phases

### **Phase 1: Foundation (Week 1)**
- [ ] Create theme directory structure
- [ ] Define color tokens for dark mode in `colors.conf`
- [ ] Implement basic theme switcher script (no GUI)
- [ ] Document color palette usage guidelines

### **Phase 2: Core UI Components (Week 2)**
- [ ] Theme Hyprland (borders, shadows, blur, animations)
- [ ] Theme Waybar (create `style-macos.css`)
- [ ] Theme Rofi/Wofi (macOS launcher aesthetic)
- [ ] Test theme switching between macOS-dark and existing themes

### **Phase 3: Notifications & Panels (Week 3)**
- [ ] Theme SwayNC (notification design)
- [ ] Theme Hyprlock (lock screen)
- [ ] Integrate GTK theme (WhiteSur or similar)
- [ ] Configure cursor theme

### **Phase 4: Terminal & Shell (Week 4)**
- [ ] Create Ghostty macOS theme (ANSI palette)
- [ ] Theme Starship prompt with macOS palette
- [ ] Theme Tmux (if applicable)
- [ ] Ensure terminal transparency + blur

### **Phase 5: Light Mode (Week 5)**
- [ ] Define light mode color tokens
- [ ] Create `macos-light` theme directory
- [ ] Adapt all component themes for light mode
- [ ] Test light/dark switching

### **Phase 6: Polish & Automation (Week 6)**
- [ ] Implement theme preview functionality
- [ ] Create Rofi-based theme selector UI
- [ ] Add auto-theme switching (time-based)
- [ ] Write comprehensive README with screenshots
- [ ] Create demo video

### **Phase 7: Extras (Optional)**
- [ ] Theme Firefox (macOS chrome)
- [ ] Theme VSCode/Neovim status bars
- [ ] Create wallpaper pack with complementary colors
- [ ] Build theme export tool (share with others)

---

## 7. Design References & Assets

### **7.1 Color Extraction Sources**
- macOS Sequoia/Sonoma system apps (Finder, Safari, System Settings)
- Apple Human Interface Guidelines (HIG)
- SF Symbols color palette
- WebKit CSS system colors (`-apple-system-blue`, etc.)

### **7.2 Required Assets**
- **Window Control Icons:** Red/yellow/green dots (12×12px SVG)
- **App Icons:** macOS-style rounded square icons (512×512px)
- **Wallpapers:** Dynamic wallpapers or macOS stock imagery
- **Cursor Theme:** macOS Monterey cursor pack

### **7.3 Typography Assets**
- **SF Pro family:** Download from Apple Developer
- **SF Mono:** System font (already installed at `~/.local/share/fonts/mac-fonts/`)
- **SF Symbols:** Optional icon font

---

## 8. Testing & Validation

### **8.1 Visual Consistency Checklist**
- [ ] All UI elements use the same border radius (10-12px)
- [ ] Blur effects are consistent across panels
- [ ] Typography is uniform (same font families)
- [ ] Accent blue appears only on interactive/focused elements
- [ ] Shadows have the same depth and color
- [ ] Opacity levels match specification

### **8.2 Functional Testing**
- [ ] Theme switching updates all components immediately
- [ ] No visual glitches during transitions
- [ ] Theme persists after reboot
- [ ] Light mode is readable and comfortable
- [ ] Dark mode has sufficient contrast (WCAG AA)

### **8.3 Performance Testing**
- [ ] Blur effects don't cause lag (monitor FPS with `hyprctl monitors`)
- [ ] Transparency doesn't impact battery significantly
- [ ] Theme switching completes in < 2 seconds

---

## 9. Accessibility Considerations

### **9.1 High Contrast Mode**
- Increase foreground/background contrast by 20%
- Use solid backgrounds (remove transparency)
- Thicken borders to 3px
- Disable blur effects

### **9.2 Reduced Motion**
- Respect `prefers-reduced-motion` (if possible)
- Disable window animations
- Instant workspace transitions
- No fade effects

### **9.3 Color Blind Modes**
- Protanopia preset: Replace red/green with blue/yellow
- Deuteranopia preset: Adjust accent colors
- Test with color blind simulation tools

---

## 10. Documentation Deliverables

### **10.1 User Documentation**
- **README.md:** Overview, installation, usage
- **THEMES.md:** How to create custom themes
- **FAQ.md:** Common issues and solutions
- **SCREENSHOTS.md:** Before/after gallery

### **10.2 Developer Documentation**
- **ARCHITECTURE.md:** Theme system design
- **COLOR-TOKENS.md:** Complete color variable reference
- **CONTRIBUTING.md:** Guidelines for theme contributions
- **CHANGELOG.md:** Version history

---

## 11. Future Enhancements

- **Dynamic theming:** Extract colors from wallpaper (pywal integration)
- **Cloud sync:** Sync theme preferences across machines
- **Theme marketplace:** Share/download community themes
- **Per-app themes:** Different themes for different applications
- **Seasonal themes:** Auto-switch based on time of year
- **Accessibility presets:** One-click high contrast, large text, etc.

---

## 12. License & Credits

- **Theme design:** Original work, inspired by Apple's macOS design language
- **Fonts:** SF Pro and SF Mono (Apple, used under license)
- **Icons:** WhiteSur icon theme (GPL 3.0)
- **GTK theme:** WhiteSur GTK theme (GPL 3.0)
- **Implementation:** MIT License (unless otherwise specified)

---

## Appendix A: Quick Start (After Implementation)

```bash
# Install theme
git clone https://github.com/yourusername/macos-hyprland-theme ~/.config/themes/macos-dark

# Switch to macOS dark theme
~/.config/scripts/theme-switch.sh set macos-dark

# Open theme selector
~/.config/scripts/theme-switch.sh menu

# Or use keybinding: Super+Shift+T
```

---

## Appendix B: Color Variable Naming Convention

**Format:** `THEME_<CATEGORY>_<ELEMENT>_<VARIANT>`

**Examples:**
- `THEME_BG_WINDOW` - Window background
- `THEME_ACCENT_BLUE_HOVER` - Blue accent hover state
- `THEME_FG_PRIMARY` - Primary text color
- `THEME_BORDER_FOCUS` - Focused element border

**Categories:**
- `BG` - Backgrounds
- `FG` - Foreground/text
- `ACCENT` - Accent colors
- `SEMANTIC` - Semantic colors (error, warning, etc.)
- `BORDER` - Border colors
- `SHADOW` - Shadow colors

---

**End of Specification**

*This document will be updated as the implementation progresses. Version: 1.0 (2025-11-09)*
