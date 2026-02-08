#!/usr/bin/env bash
# modules/zsh.sh
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../lib/utils.sh
source "$SCRIPT_DIR/../lib/utils.sh"

run_zsh() {
    log_section "Zsh"

    if ! command_exists zsh; then
        die "zsh not found. Run the homebrew module first."
    fi

    local zsh_path
    zsh_path="$(which zsh)"

    if [[ "$SHELL" != "$zsh_path" ]]; then
        if ! grep -qxF "$zsh_path" /etc/shells 2>/dev/null; then
            log_info "Adding $zsh_path to /etc/shells"
            run_sudo sh -c "echo '$zsh_path' >> /etc/shells"
        fi
        log_info "Changing default shell to zsh"
        run chsh -s "$zsh_path"
    else
        log_skip "Default shell is already zsh"
    fi

    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        log_info "Installing oh-my-zsh..."
        if [[ "$DRY_RUN" == true ]]; then
            log_dry_run "Install oh-my-zsh (unattended, no chsh)"
        else
            RUNZSH=no CHSH=no sh -c "$(curl -fsSL "$OH_MY_ZSH_INSTALL_URL")" "" --unattended
        fi
    else
        log_skip "oh-my-zsh already installed"
    fi

    local ohmyzsh_custom="$HOME/.oh-my-zsh/custom/plugins"
    for entry in "${ZSH_PLUGINS[@]}"; do
        local repo="${entry%%|*}"
        local name="${entry##*|}"
        clone_if_missing "$repo" "$ohmyzsh_custom/$name"
    done

    copy_file "$CONFIGS_DIR/zsh/.zshrc" "$HOME/.zshrc"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    for arg in "$@"; do [[ "$arg" == "--dry-run" ]] && DRY_RUN=true; done
    run_zsh
fi
