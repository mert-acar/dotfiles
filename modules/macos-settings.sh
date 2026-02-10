#!/usr/bin/env bash
# modules/macos-settings.sh
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../lib/utils.sh
source "$SCRIPT_DIR/../lib/utils.sh"

configure_hot_corners() {
    log_info "Configuring hot corners..."
    defaults_write com.apple.dock wvous-tl-corner int "$HOT_CORNER_TOP_LEFT"
    defaults_write com.apple.dock wvous-tr-corner int "$HOT_CORNER_TOP_RIGHT"
    defaults_write com.apple.dock wvous-bl-corner int "$HOT_CORNER_BOTTOM_LEFT"
    defaults_write com.apple.dock wvous-br-corner int "$HOT_CORNER_BOTTOM_RIGHT"
}

configure_dock() {
    log_info "Configuring dock..."
    defaults_write com.apple.dock tilesize int "$DOCK_ICON_SIZE"
    defaults_write com.apple.dock autohide bool "$DOCK_AUTOHIDE"
    defaults_write com.apple.dock orientation string "$DOCK_ORIENTATION"
    defaults_write com.apple.dock show-recents bool "$DOCK_SHOW_RECENTS"
    defaults_write com.apple.dock show-process-indicators bool true
    defaults_write com.apple.dock minimize-to-application bool true

    log_info "Resetting dock applications..."
    if [[ "$DRY_RUN" == true ]]; then
        log_dry_run "dockutil: remove all items except Finder"
    else
        dockutil --list | grep -v '^Finder' | awk -F'\t' '{print $1}' | while read -r app; do
            dockutil --remove "$app" --no-restart 2>/dev/null || true
        done
    fi

    for entry in "${DOCK_APPLICATIONS[@]}"; do
        local name="${entry%%|*}"
        local path="${entry##*|}"
        if [[ "$DRY_RUN" == true ]]; then
            log_dry_run "dockutil --add $path ($name)"
        else
            dockutil --add "$path" --no-restart 2>/dev/null || true
        fi
    done

    for entry in "${DOCK_FOLDERS[@]}"; do
        IFS='|' read -r path display view <<< "$entry"
        if [[ "$DRY_RUN" == true ]]; then
            log_dry_run "dockutil --add $path --view $view --display $display"
        else
            dockutil --add "$path" --view "$view" --display "$display" --no-restart 2>/dev/null || true
        fi
    done
}

configure_finder() {
    log_info "Configuring Finder..."
    defaults_write com.apple.finder AppleShowAllFiles bool "$FINDER_SHOW_HIDDEN"
    defaults_write NSGlobalDomain AppleShowAllExtensions bool "$FINDER_SHOW_EXTENSIONS"
    defaults_write com.apple.finder FXPreferredViewStyle string "$FINDER_DEFAULT_VIEW"
    defaults_write com.apple.finder ShowPathbar bool true
    defaults_write com.apple.finder ShowStatusBar bool true
    defaults_write com.apple.finder FXDefaultSearchScope string "SCcf"

    log_info "Unhiding ~/Library..."
    run chflags nohidden "$HOME/Library"
}

configure_accessibility() {
    log_info "Configuring accessibility..."
    # Enable dragging windows from anywhere with Ctrl+Cmd click
    defaults_write NSGlobalDomain NSWindowShouldDragOnGesture bool true
    # Disable "click wallpaper to reveal desktop"
    defaults_write com.apple.WindowManager EnableStandardClickToShowDesktop bool false
    # Disable Spotlight shortcut (Cmd+Space) so Raycast can use it
    # log_info "Disabling Spotlight shortcut (Cmd+Space)..."
    # run defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 64 \
    #     '{ enabled = 0; value = { parameters = (32, 49, 1048576); type = standard; }; }'
}

run_macos_settings() {
    log_section "macOS Settings"

    configure_hot_corners
    configure_dock
    configure_finder
    configure_accessibility


    log_info "Restarting Dock..."
    run killall Dock || true
    log_info "Restarting Finder..."
    run killall Finder || true
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    for arg in "$@"; do [[ "$arg" == "--dry-run" ]] && DRY_RUN=true; done
    run_macos_settings
fi
