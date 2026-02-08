#!/usr/bin/env bash
# modules/raycast.sh — Import Raycast configuration
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../lib/utils.sh
source "$SCRIPT_DIR/../lib/utils.sh"

run_raycast() {
    log_section "Raycast"

    local config_file
    config_file="$(find "$CONFIGS_DIR/raycast" -name '*.rayconfig' 2>/dev/null | head -1)"
    log_info "Importing Raycast config: $(basename "$config_file")"
    run open "$config_file"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    for arg in "$@"; do [[ "$arg" == "--dry-run" ]] && DRY_RUN=true; done
    run_raycast
fi
