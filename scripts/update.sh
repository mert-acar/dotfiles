#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

cd "$DOTFILES_DIR"

echo ""
echo -e "\033[0;34m[INFO]\033[0m Pulling latest changes..."
git pull || { echo -e "\033[0;31m[ERROR]\033[0m Git pull failed"; exit 1; }

echo -e "\033[0;34m[INFO]\033[0m Running setup..."
exec "$DOTFILES_DIR/setup.sh" "$@"
