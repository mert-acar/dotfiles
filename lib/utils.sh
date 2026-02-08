#!/usr/bin/env bash
# shared utilities: logging, dry-run wrappers, idempotency helpers.

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
DIM='\033[2m'
NC='\033[0m'

log_info()    { echo -e "${BLUE}[INFO]${NC}    $*"; }
log_ok()      { echo -e "${GREEN}[OK]${NC}      $*"; }
log_skip()    { echo -e "${DIM}[SKIP]${NC}    $*"; }
log_warn()    { echo -e "${YELLOW}[WARN]${NC}    $*"; }
log_error()   { echo -e "${RED}[ERROR]${NC}   $*"; }
log_dry_run() { echo -e "${CYAN}[DRY-RUN]${NC} $*"; }
log_section() { echo -e "\n${BLUE}━━━ $* ━━━${NC}"; }

die() {
    log_error "$@"
    exit 1
}

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIGS_DIR="$DOTFILES_DIR/configs"
MODULES_DIR="$DOTFILES_DIR/modules"

# shellcheck source=config.sh
source "$DOTFILES_DIR/lib/config.sh"

DRY_RUN="${DRY_RUN:-false}"

# --- Dry-run wrappers ---
run() {
    if [[ "$DRY_RUN" == true ]]; then
        log_dry_run "$*"
    else
        "$@"
    fi
}

run_sudo() {
    if [[ "$DRY_RUN" == true ]]; then
        log_dry_run "sudo $*"
    else
        sudo "$@"
    fi
}

copy_file() {
    local src="$1" dest="$2" mode="${3:-0644}"
    if [[ -f "$dest" ]] && diff -q "$src" "$dest" &>/dev/null; then
        log_skip "Already up to date: $dest"
        return 0
    fi
    if [[ "$DRY_RUN" == true ]]; then
        if [[ -f "$dest" ]]; then
            log_dry_run "Update $dest (mode $mode)"
        else
            log_dry_run "Copy $src -> $dest (mode $mode)"
        fi
    else
        cp "$src" "$dest"
        chmod "$mode" "$dest"
        log_ok "Copied $src -> $dest"
    fi
}

copy_dir() {
    local src="$1" dest="$2"
    if [[ "$DRY_RUN" == true ]]; then
        log_dry_run "Copy directory $src/ -> $dest/"
    else
        cp -R "$src/" "$dest/"
        log_ok "Copied directory $src/ -> $dest/"
    fi
}

ensure_dir() {
    local dir="$1"
    if [[ -d "$dir" ]]; then
        return 0
    fi
    if [[ "$DRY_RUN" == true ]]; then
        log_dry_run "mkdir -p $dir"
    else
        mkdir -p "$dir"
        log_ok "Created directory: $dir"
    fi
}

clone_if_missing() {
    local repo="$1" dest="$2"
    if [[ -d "$dest" ]]; then
        log_skip "Already cloned: $dest"
        return 0
    fi
    if [[ "$DRY_RUN" == true ]]; then
        log_dry_run "git clone $repo -> $dest"
    else
        git clone --depth 1 "$repo" "$dest"
        log_ok "Cloned $repo -> $dest"
    fi
}

defaults_write() {
    local domain="$1" key="$2" type="$3" value="$4"
    if [[ "$DRY_RUN" == true ]]; then
        log_dry_run "defaults write $domain $key -$type $value"
    else
        defaults write "$domain" "$key" "-$type" "$value"
        log_ok "defaults write $domain $key = $value"
    fi
}

append_line() {
    local file="$1" line="$2"
    if [[ "$DRY_RUN" == true ]]; then
        log_dry_run "Append to $file: $line"
    else
        echo "$line" >> "$file"
        log_ok "Appended to $file"
    fi
}

# --- Idempotency helpers ---
command_exists() { command -v "$1" &>/dev/null; }

file_contains_line() {
    grep -qxF "$1" "$2" 2>/dev/null
}
