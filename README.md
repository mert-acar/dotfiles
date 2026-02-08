# Dotfiles

Automated macOS development environment setup via bash scripts.

## Quick Start

```bash
git clone https://github.com/mert-acar/dotfiles.git ~/dotfiles
cd ~/dotfiles
./setup.sh
```

## Usage

```bash
./setup.sh                        # Run everything
./setup.sh --dry-run              # Preview changes without applying
./setup.sh --dry-run homebrew     # Preview a single module
./setup.sh tmux neovim            # Run specific modules
./setup.sh --list                 # List available modules
```

Modules can also run standalone: `./modules/ghostty.sh --dry-run`

## Modules

| Module | What it does |
|--------|-------------|
| `homebrew` | Install Homebrew + packages from `configs/Brewfile` |
| `zsh` | oh-my-zsh, plugins (syntax-highlighting, vi-mode, autosuggestions), `.zshrc` |
| `bash-scripts` | Custom scripts (`tmux-sessionizer`, `hydrate`) to `~/.local/bin` |
| `tmux` | tmux config + TPM plugin manager |
| `neovim` | Full nvim config (lazy.nvim, LSP, treesitter, etc.) |
| `ghostty` | Ghostty terminal config |
| `aerospace` | AeroSpace tiling window manager config |
| `macos-settings` | Dock, Finder, and hot corner preferences via `defaults write` |

## Structure

```
dotfiles/
├── setup.sh            # Main entry point
├── lib/
│   ├── utils.sh        # Shared logging, dry-run wrappers
│   └── config.sh       # All configuration values
├── modules/            # One script per concern
├── configs/            # All dotfiles and config files
└── scripts/update.sh   # git pull + re-run setup
```

## Customization

- **Packages**: Edit `configs/Brewfile`
- **Settings**: Edit `lib/config.sh` (dock apps, hot corners, finder prefs, etc.)
- **Dotfiles**: Edit files under `configs/` (zsh/.zshrc, tmux/tmux.conf, nvim/, etc.)

## Post-Install
1. Restart your shell: `exec $SHELL`
2. In tmux: `prefix + I` to install plugins
3. Launch `nvim` to auto-install plugins
4. Log out/in to apply macOS settings
