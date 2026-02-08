#!/usr/bin/env bash
# modules/bash-scripts.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../lib/utils.sh
source "$SCRIPT_DIR/../lib/utils.sh"

run_bash_scripts() {
    log_section "Bash Scripts"

    ensure_dir "$HOME/.local/bin"
    ensure_dir "$HOME/.local/bin/scripts"

    copy_file "$CONFIGS_DIR/bash/scripts/tmux-sessionizer" "$HOME/.local/bin/scripts/tmux-sessionizer" "0755"
    copy_file "$CONFIGS_DIR/bash/scripts/hydrate" "$HOME/.local/bin/scripts/hydrate" "0755"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    for arg in "$@"; do [[ "$arg" == "--dry-run" ]] && DRY_RUN=true; done
    run_bash_scripts
fi
