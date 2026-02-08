#!/usr/bin/env bash
# modules/ghostty.sh
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../lib/utils.sh
source "$SCRIPT_DIR/../lib/utils.sh"

run_ghostty() {
    log_section "Ghostty"

    ensure_dir "$HOME/.config/ghostty"
    copy_file "$CONFIGS_DIR/ghostty/config" "$HOME/.config/ghostty/config"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    for arg in "$@"; do [[ "$arg" == "--dry-run" ]] && DRY_RUN=true; done
    run_ghostty
fi
