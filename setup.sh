#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/utils.sh"

ALL_MODULES=(homebrew zsh bash-scripts tmux neovim ghostty aerospace macos-settings)

module_function() {
    case "$1" in
        homebrew)       echo run_homebrew ;;
        zsh)            echo run_zsh ;;
        bash-scripts)   echo run_bash_scripts ;;
        tmux)           echo run_tmux ;;
        neovim)         echo run_neovim ;;
        ghostty)        echo run_ghostty ;;
        aerospace)      echo run_aerospace ;;
        macos-settings) echo run_macos_settings ;;
        *)              return 1 ;;
    esac
}

is_valid_module() {
    module_function "$1" &>/dev/null
}

usage() {
    cat <<'EOF'
Usage: ./setup.sh [OPTIONS] [MODULE ...]

Options:
  --dry-run     Preview what will be executed without making changes
  --list        List available modules
  -h, --help    Show this help message

Modules (run in order, all by default):
  homebrew        Install/update Homebrew and packages
  zsh             Configure zsh, oh-my-zsh, and plugins
  bash-scripts    Install custom bash scripts
  tmux            Configure tmux and install TPM
  neovim          Install neovim configuration
  ghostty         Install Ghostty terminal config
  aerospace       Install AeroSpace window manager config
  macos-settings  Configure macOS system preferences

Examples:
  ./setup.sh                        # Run all modules
  ./setup.sh --dry-run              # Preview all changes
  ./setup.sh tmux neovim            # Run only tmux and neovim
  ./setup.sh --dry-run homebrew     # Preview homebrew changes only
EOF
}

SELECTED_MODULES=()
for arg in "$@"; do
    case "$arg" in
        --dry-run) DRY_RUN=true ;;
        --list)    printf '%s\n' "${ALL_MODULES[@]}"; exit 0 ;;
        -h|--help) usage; exit 0 ;;
        *)
            if is_valid_module "$arg"; then
                SELECTED_MODULES+=("$arg")
            else
                die "Unknown module: $arg (use --list to see available modules)"
            fi
            ;;
    esac
done

if [[ ${#SELECTED_MODULES[@]} -eq 0 ]]; then
    SELECTED_MODULES=("${ALL_MODULES[@]}")
fi

for mod in "${SELECTED_MODULES[@]}"; do
    # shellcheck source=/dev/null
    source "$MODULES_DIR/$mod.sh"
done

echo ""
log_info "=========================================="
log_info "  Dotfiles Setup"
[[ "$DRY_RUN" == true ]] && log_info "  (DRY RUN — no changes will be made)"
log_info "=========================================="
echo ""
log_info "Modules: ${SELECTED_MODULES[*]}"

log_section "Common Directories"
for dir in "$HOME/.config" "$HOME/.local/bin" "$HOME/.local/share" "$HOME/.local/state"; do
    ensure_dir "$dir"
done

for mod in "${SELECTED_MODULES[@]}"; do
    "$(module_function "$mod")"
done

echo ""
log_ok "=========================================="
log_ok "  Setup Complete!"
log_ok "=========================================="
echo ""
log_info "Next steps:"
log_info "  1. Restart your shell or run: exec \$SHELL"
log_info "  2. In tmux, press prefix + I to install plugins"
log_info "  3. Launch nvim to install plugins automatically"
if [[ " ${SELECTED_MODULES[*]} " == *" macos-settings "* ]]; then
    log_info "  4. Log out and back in to apply all macOS settings"
fi
echo ""
