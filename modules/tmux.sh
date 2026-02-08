#!/usr/bin/env bash
# modules/tmux.sh
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../lib/utils.sh
source "$SCRIPT_DIR/../lib/utils.sh"

run_tmux() {
    log_section "Tmux"

    if ! command_exists tmux; then
        log_warn "tmux not found. Run the homebrew module first."
        return 0
    fi

    ensure_dir "$HOME/.config/tmux"
    copy_file "$CONFIGS_DIR/tmux/tmux.conf" "$HOME/.config/tmux/tmux.conf"

    clone_if_missing "https://github.com/tmux-plugins/tpm" "$HOME/.tmux/plugins/tpm"

    if tmux list-sessions &>/dev/null; then
        log_info "Reloading tmux config..."
        run tmux source-file "$HOME/.config/tmux/tmux.conf"
    fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    for arg in "$@"; do [[ "$arg" == "--dry-run" ]] && DRY_RUN=true; done
    run_tmux
fi
