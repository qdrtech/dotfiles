#!/bin/bash
# ==============================================================================
# Theme Switcher for Hyprland macOS Setup
# Version: 1.0
# Author: qdrtech
# ==============================================================================

set -e

# ==============================================================================
# CONFIGURATION
# ==============================================================================

THEMES_DIR="$HOME/.config/themes"
CURRENT_LINK="$THEMES_DIR/current"
PREFERENCE_FILE="$HOME/.config/theme-preference"
LOG_FILE="$HOME/.cache/theme-switch.log"

# Component config paths
HYPRLAND_CONFIG="$HOME/.config/hypr/conf/theme.conf"
WAYBAR_STYLE="$HOME/.config/waybar/style.css"
ROFI_THEME="$HOME/.config/rofi/theme.rasi"
SWAYNC_STYLE="$HOME/.config/swaync/style.css"
GHOSTTY_THEME="$HOME/.config/ghostty/theme.conf"
STARSHIP_CONFIG="$HOME/.config/starship.toml"

# ==============================================================================
# UTILITY FUNCTIONS
# ==============================================================================

log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

error() {
    echo "[ERROR] $1" >&2
    log "ERROR: $1"
    exit 1
}

success() {
    echo "[SUCCESS] $1"
    log "SUCCESS: $1"
}

# ==============================================================================
# CORE FUNCTIONS
# ==============================================================================

list_themes() {
    if [ ! -d "$THEMES_DIR" ]; then
        error "Themes directory not found: $THEMES_DIR"
    fi

    echo "Available themes:"
    for theme_dir in "$THEMES_DIR"/*; do
        if [ -d "$theme_dir" ] && [ "$(basename "$theme_dir")" != "current" ]; then
            theme_name=$(basename "$theme_dir")
            if [ -f "$theme_dir/colors.conf" ]; then
                # Extract theme metadata if available
                if grep -q "THEME_NAME=" "$theme_dir/colors.conf"; then
                    theme_display=$(grep "THEME_NAME=" "$theme_dir/colors.conf" | cut -d'"' -f2)
                    echo "  • $theme_name ($theme_display)"
                else
                    echo "  • $theme_name"
                fi
            else
                echo "  • $theme_name [incomplete]"
            fi
        fi
    done
}

get_current_theme() {
    if [ -L "$CURRENT_LINK" ]; then
        basename "$(readlink -f "$CURRENT_LINK")"
    else
        echo "none"
    fi
}

validate_theme() {
    local theme_name="$1"
    local theme_path="$THEMES_DIR/$theme_name"

    if [ ! -d "$theme_path" ]; then
        error "Theme '$theme_name' not found in $THEMES_DIR"
    fi

    if [ ! -f "$theme_path/colors.conf" ]; then
        error "Theme '$theme_name' is incomplete (missing colors.conf)"
    fi

    return 0
}

set_theme() {
    local theme_name="$1"
    local theme_path="$THEMES_DIR/$theme_name"

    log "Setting theme to: $theme_name"

    # Validate theme
    validate_theme "$theme_name"

    # Setup base configurations (if not already done)
    setup_base_configs

    # Update symlink
    ln -sfn "$theme_path" "$CURRENT_LINK"
    success "Updated theme symlink"

    # Apply theme to all components
    apply_hyprland "$theme_path"
    apply_waybar "$theme_path"
    apply_rofi "$theme_path"
    apply_swaync "$theme_path"
    apply_ghostty "$theme_path"
    apply_starship "$theme_path"

    # Save preference
    echo "$theme_name" > "$PREFERENCE_FILE"
    success "Theme switched to: $theme_name"

    # Show what was applied
    echo ""
    echo "Theme applied to:"
    echo "  ✓ Hyprland (window manager)"
    echo "  ✓ Waybar (status bar)"
    echo "  ✓ Rofi (launcher)"
    echo "  ✓ SwayNC (notifications)"
    echo "  ✓ Ghostty (terminal)"
    echo "  ✓ Starship (prompt)"
}

# ==============================================================================
# BASE CONFIGURATION FUNCTIONS
# ==============================================================================

setup_base_configs() {
    log "Setting up base configurations..."

    # Link waybar config to base
    local waybar_config="$HOME/.config/waybar/config"
    local base_waybar_config="$HOME/.config/base/waybar/config"

    if [ -f "$base_waybar_config" ]; then
        mkdir -p "$(dirname "$waybar_config")"
        if [ ! -L "$waybar_config" ]; then
            # Backup existing config
            if [ -f "$waybar_config" ]; then
                mv "$waybar_config" "$waybar_config.backup-$(date +%Y%m%d-%H%M%S)"
            fi
            ln -sf "$base_waybar_config" "$waybar_config"
            log "Linked waybar config to base"
        fi
    fi

    log "Base configurations ready"
}

# ==============================================================================
# COMPONENT APPLICATION FUNCTIONS
# ==============================================================================

apply_hyprland() {
    local theme_path="$1"
    local theme_file="$theme_path/hyprland-style.conf"

    # Try new layered system first (hyprland-style.conf)
    if [ ! -f "$theme_file" ]; then
        # Fall back to old system (hyprland.conf) for backward compatibility
        theme_file="$theme_path/hyprland.conf"
        if [ ! -f "$theme_file" ]; then
            log "Warning: Hyprland theme file not found (tried hyprland-style.conf and hyprland.conf), skipping"
            return
        fi
    fi

    # Ensure config directory exists
    mkdir -p "$(dirname "$HYPRLAND_CONFIG")"

    # Copy theme style file
    cp "$theme_file" "$HYPRLAND_CONFIG"

    # Reload Hyprland
    if command -v hyprctl &> /dev/null; then
        hyprctl reload &> /dev/null || log "Warning: Could not reload Hyprland"
    fi

    log "Applied Hyprland theme (layered system)"
}

apply_waybar() {
    local theme_path="$1"
    local theme_file="$theme_path/waybar.css"

    if [ ! -f "$theme_file" ]; then
        log "Warning: Waybar theme file not found, skipping"
        return
    fi

    # Ensure config directory exists
    mkdir -p "$(dirname "$WAYBAR_STYLE")"

    # Link theme file
    ln -sf "$theme_file" "$WAYBAR_STYLE"

    # Restart Waybar
    if pgrep -x waybar &> /dev/null; then
        killall waybar &> /dev/null || true
        sleep 0.5
        waybar &> /dev/null &
        disown
    fi

    log "Applied Waybar theme"
}

apply_rofi() {
    local theme_path="$1"
    local theme_file="$theme_path/rofi.rasi"

    if [ ! -f "$theme_file" ]; then
        log "Warning: Rofi theme file not found, skipping"
        return
    fi

    # Ensure config directory exists
    mkdir -p "$(dirname "$ROFI_THEME")"

    # Link theme file
    ln -sf "$theme_file" "$ROFI_THEME"

    log "Applied Rofi theme"
}

apply_swaync() {
    local theme_path="$1"
    local theme_file="$theme_path/swaync.css"

    if [ ! -f "$theme_file" ]; then
        log "Warning: SwayNC theme file not found, skipping"
        return
    fi

    # Ensure config directory exists
    mkdir -p "$(dirname "$SWAYNC_STYLE")"

    # Link theme file
    ln -sf "$theme_file" "$SWAYNC_STYLE"

    # Reload SwayNC
    if command -v swaync-client &> /dev/null; then
        swaync-client --reload-config &> /dev/null || true
        swaync-client --reload-css &> /dev/null || true
    fi

    log "Applied SwayNC theme"
}

apply_ghostty() {
    local theme_path="$1"
    local theme_file="$theme_path/ghostty.conf"

    if [ ! -f "$theme_file" ]; then
        log "Warning: Ghostty theme file not found, skipping"
        return
    fi

    # Ensure config directory exists
    mkdir -p "$(dirname "$GHOSTTY_THEME")"

    # Copy theme file
    cp "$theme_file" "$GHOSTTY_THEME"

    log "Applied Ghostty theme (restart Ghostty to see changes)"
}

apply_starship() {
    local theme_path="$1"
    local theme_file="$theme_path/starship.toml"

    if [ ! -f "$theme_file" ]; then
        log "Warning: Starship theme file not found, skipping"
        return
    fi

    # Backup existing config if it exists and isn't a symlink
    if [ -f "$STARSHIP_CONFIG" ] && [ ! -L "$STARSHIP_CONFIG" ]; then
        cp "$STARSHIP_CONFIG" "$STARSHIP_CONFIG.backup-$(date +%Y%m%d-%H%M%S)"
    fi

    # Link theme file
    ln -sf "$theme_file" "$STARSHIP_CONFIG"

    log "Applied Starship theme (reload shell to see changes)"
}

# ==============================================================================
# INFO FUNCTIONS
# ==============================================================================

show_status() {
    local current_theme=$(get_current_theme)

    echo "Theme System Status"
    echo "==================="
    echo ""
    echo "Current theme: $current_theme"
    echo "Themes directory: $THEMES_DIR"
    echo ""

    if [ "$current_theme" != "none" ]; then
        local theme_path="$THEMES_DIR/$current_theme"
        if [ -f "$theme_path/colors.conf" ]; then
            source "$theme_path/colors.conf"
            echo "Theme details:"
            echo "  Name: ${THEME_NAME:-N/A}"
            echo "  Type: ${THEME_TYPE:-N/A}"
            echo "  Version: ${THEME_VERSION:-N/A}"
            echo "  Author: ${THEME_AUTHOR:-N/A}"
        fi
    fi

    echo ""
    echo "Applied to:"
    [ -f "$HYPRLAND_CONFIG" ] && echo "  ✓ Hyprland" || echo "  ✗ Hyprland"
    [ -f "$WAYBAR_STYLE" ] && echo "  ✓ Waybar" || echo "  ✗ Waybar"
    [ -f "$ROFI_THEME" ] && echo "  ✓ Rofi" || echo "  ✗ Rofi"
    [ -f "$SWAYNC_STYLE" ] && echo "  ✓ SwayNC" || echo "  ✗ SwayNC"
    [ -f "$GHOSTTY_THEME" ] && echo "  ✓ Ghostty" || echo "  ✗ Ghostty"
    [ -f "$STARSHIP_CONFIG" ] && echo "  ✓ Starship" || echo "  ✗ Starship"
}

show_help() {
    cat << EOF
Theme Switcher for Hyprland macOS Setup

USAGE:
    theme-switch.sh COMMAND [OPTIONS]

COMMANDS:
    list                List all available themes
    current             Show currently active theme
    set THEME           Switch to specified theme
    status              Show theme system status
    help                Show this help message

EXAMPLES:
    # List available themes
    theme-switch.sh list

    # Switch to macOS dark theme
    theme-switch.sh set macos-dark

    # Check current theme
    theme-switch.sh current

    # Show detailed status
    theme-switch.sh status

FILES:
    Themes:         $THEMES_DIR/
    Current:        $CURRENT_LINK
    Preference:     $PREFERENCE_FILE
    Log:            $LOG_FILE

VERSION: 1.0
AUTHOR: qdrtech
EOF
}

# ==============================================================================
# MAIN
# ==============================================================================

main() {
    # Ensure themes directory exists
    mkdir -p "$THEMES_DIR"
    mkdir -p "$(dirname "$LOG_FILE")"

    # Parse command
    case "${1:-help}" in
        list)
            list_themes
            ;;
        current)
            echo "$(get_current_theme)"
            ;;
        set)
            if [ -z "$2" ]; then
                error "Theme name required. Usage: theme-switch.sh set THEME"
            fi
            set_theme "$2"
            ;;
        status)
            show_status
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            echo "Unknown command: $1"
            echo "Run 'theme-switch.sh help' for usage information"
            exit 1
            ;;
    esac
}

main "$@"
