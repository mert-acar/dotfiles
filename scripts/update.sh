#!/usr/bin/env bash

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

cd "$DOTFILES_DIR"

echo ""
print_info "=========================================="
print_info "  Dotfiles Update Script"
print_info "=========================================="
echo ""

print_info "Pulling latest changes from git..."
if git pull; then
    print_success "Git pull completed"
else
    print_error "Git pull failed"
    exit 1
fi

print_info "Updating Ansible Galaxy requirements..."
if ansible-galaxy collection install -r requirements.yml --force; then
    print_success "Galaxy requirements updated"
else
    print_error "Failed to update Galaxy requirements"
    exit 1
fi

print_info "Running Ansible playbook..."
echo ""
if ansible-playbook playbooks/main.yml "$@"; then
    print_success "Playbook execution completed"
else
    print_error "Playbook execution failed"
    exit 1
fi

echo ""
print_success "=========================================="
print_success "  Update Complete!"
print_success "=========================================="
echo ""
print_info "If you updated shell configurations, restart your shell: exec \$SHELL"
echo ""
