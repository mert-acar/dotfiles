#!/usr/bin/env bash
# modules/neovim.sh
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../lib/utils.sh
source "$SCRIPT_DIR/../lib/utils.sh"

run_neovim() {
    log_section "Neovim"

    if ! command_exists nvim; then
        log_warn "neovim not found. Run the homebrew module first."
        return 0
    fi

    ensure_dir "$HOME/.config/nvim"
    ensure_dir "$HOME/.local/share/nvim"
    ensure_dir "$HOME/.local/state/nvim"

    copy_dir "$CONFIGS_DIR/nvim" "$HOME/.config/nvim"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    for arg in "$@"; do [[ "$arg" == "--dry-run" ]] && DRY_RUN=true; done
    run_neovim
fi
