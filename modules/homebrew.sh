#!/usr/bin/env bash
# modules/homebrew.sh
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../lib/utils.sh
source "$SCRIPT_DIR/../lib/utils.sh"

run_homebrew() {
    log_section "Homebrew"

    if ! command_exists brew; then
        log_info "Installing Homebrew..."
        if [[ "$DRY_RUN" == true ]]; then
            log_dry_run "Install Homebrew from $HOMEBREW_INSTALL_URL"
        else
            NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL "$HOMEBREW_INSTALL_URL")"
            eval "$("$HOMEBREW_PREFIX/bin/brew" shellenv)"
        fi
    else
        log_skip "Homebrew already installed"
    fi

    local shellenv_line="eval \"\$($HOMEBREW_PREFIX/bin/brew shellenv)\""
    if ! file_contains_line "$shellenv_line" "$HOME/.zprofile"; then
        append_line "$HOME/.zprofile" "$shellenv_line"
    else
        log_skip "Homebrew PATH already in .zprofile"
    fi

    log_info "Updating Homebrew..."
    run brew update

    log_info "Installing packages from Brewfile..."
    copy_file "$CONFIGS_DIR/Brewfile" "$HOME/Brewfile"
    run brew bundle --file="$HOME/Brewfile"
    # remove quarantine attribute to avoid "App is damaged and can't be opened" error on macOS
    xattr -d com.apple.quarantine /Applications/LibreWolf
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    for arg in "$@"; do [[ "$arg" == "--dry-run" ]] && DRY_RUN=true; done
    run_homebrew
fi
