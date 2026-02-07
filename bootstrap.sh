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

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
        print_info "Detected macOS"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        OS="linux"
        print_info "Detected Linux"
    else
        print_error "Unsupported operating system: $OSTYPE"
        exit 1
    fi
}

check_homebrew() {
    if command -v brew &> /dev/null; then
        print_success "Homebrew is already installed"
        return 0
    else
        print_warning "Homebrew is not installed"
        return 1
    fi
}

install_homebrew() {
    print_info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for this session
    if [[ "$OS" == "macos" ]]; then
        if [[ $(uname -m) == "arm64" ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        else
            eval "$(/usr/local/bin/brew shellenv)"
        fi
    else
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi

    print_success "Homebrew installed successfully"
}

install_ansible() {
    print_info "Installing Ansible..."
    brew install ansible
    print_success "Ansible installed successfully"
}

install_galaxy_requirements() {
    print_info "Installing Ansible Galaxy requirements..."
    ansible-galaxy collection install -r requirements.yml
    print_success "Ansible Galaxy requirements installed"
}

run_playbook() {
    print_info "Running Ansible playbook..."
    ansible-playbook playbooks/main.yml -K "$@"
    print_success "Playbook execution completed"
}

main() {
    echo ""
    print_info "=========================================="
    print_info "  Dotfiles Bootstrap Script"
    print_info "=========================================="
    echo ""

    detect_os

    if ! check_homebrew; then
        install_homebrew
    fi

    if ! command -v ansible &> /dev/null; then
        install_ansible
    else
        print_success "Ansible is already installed"
    fi

    install_galaxy_requirements

    print_info "Starting dotfiles configuration..."
    echo ""
    run_playbook "$@"

    echo ""
    print_success "=========================================="
    print_success "  Bootstrap Complete!"
    print_success "=========================================="
    echo ""
    print_info "Please restart your shell or run: exec \$SHELL"
    echo ""
}

main "$@"
