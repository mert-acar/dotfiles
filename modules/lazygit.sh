#!/usr/bin/env bash
# modules/lazygit.sh
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../lib/utils.sh
source "$SCRIPT_DIR/../lib/utils.sh"

run_lazygit() {
    log_section "LazyGit"

    if ! command_exists lazygit; then
        log_warn "lazygit not found. Run the homebrew module first."
        return 0
    fi

    ensure_dir "$HOME/.config/lazygit"

    copy_dir "$CONFIGS_DIR/lazygit" "$HOME/.config/lazygit"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    for arg in "$@"; do [[ "$arg" == "--dry-run" ]] && DRY_RUN=true; done
    run_lazygit
fi
