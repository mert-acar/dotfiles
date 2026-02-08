#!/usr/bin/env bash
# modules/aerospace.sh
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../lib/utils.sh
source "$SCRIPT_DIR/../lib/utils.sh"

run_aerospace() {
    log_section "AeroSpace"

    ensure_dir "$HOME/.config/aerospace"
    copy_file "$CONFIGS_DIR/aerospace/aerospace.toml" "$HOME/.config/aerospace/aerospace.toml"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    for arg in "$@"; do [[ "$arg" == "--dry-run" ]] && DRY_RUN=true; done
    run_aerospace
fi
