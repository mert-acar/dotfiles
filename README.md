# Dotfiles & System Setup

Automated, version-controlled dotfiles and system configuration using Ansible. Sets up a complete development environment with a single command.

## Features

- 🚀 **One-command setup** - Bootstrap entire environment with `./bootstrap.sh`
- 🔄 **Cross-platform** - Supports macOS and Ubuntu/Debian Linux
- 📦 **Package management** - Unified package installation via Homebrew (both macOS and Linux)
- ⚙️ **System configuration** - Automated macOS settings (Dock, Finder, hot corners)
- 🎨 **Dotfiles management** - tmux, neovim, zsh, bash, ghostty, and more
- 🪟 **Window management** - AeroSpace configuration for macOS
- 🛠️ **CLI tools** - Modern replacements (eza, zoxide, fzf, fd, ripgrep, bat, lazygit)
- 🔁 **Idempotent** - Safe to run multiple times
- 🏷️ **Tagged roles** - Run specific components selectively

## Quick Start

### Initial Setup

```bash
# Clone this repository
git clone <your-repo-url> ~/dotfiles
cd ~/dotfiles

# Run bootstrap script
./bootstrap.sh
```

The bootstrap script will:
1. Detect your operating system
2. Install Homebrew (if not present)
3. Install Ansible
4. Install required Ansible collections
5. Run the main playbook to configure everything

### Update Existing Installation

```bash
# Pull latest changes and re-run configuration
./scripts/update.sh
```

## What Gets Configured

### Package Management
- **Homebrew** - Package manager for macOS and Linux
- **Applications** - Spotify, Ghostty, 1Password, LibreWolf, Obsidian, etc. (macOS)
- **CLI Tools** - tmux, neovim, zsh, git, eza, zoxide, fzf, fd, ripgrep, bat, lazygit, jq, htop

### Development Tools
- **tmux** - Terminal multiplexer with TPM plugin manager
- **Neovim** - Modern Vim with lazy.nvim plugin manager
- **Zsh** - Shell with oh-my-zsh framework
- **Bash** - Alternative shell configuration

### Terminal & UI
- **Ghostty** - Modern terminal emulator (cross-platform)
- **AeroSpace** - Tiling window manager (macOS only)
- **Fonts** - JetBrains Mono Nerd Font, Meslo LG, Fira Code

### CLI Enhancements
- **eza** - Modern ls replacement
- **zoxide** - Smarter cd command
- **fzf** - Fuzzy finder
- **fd** - Fast find alternative
- **ripgrep** - Fast grep alternative
- **bat** - Cat with syntax highlighting
- **lazygit** - Terminal UI for git

### macOS Settings (macOS only)
- **Hot Corners** - Configurable screen corner actions
- **Dock** - Size, position, auto-hide settings
- **Finder** - Show hidden files, extensions, path bar

## Project Structure

```
dotfiles/
├── ansible.cfg              # Ansible configuration
├── bootstrap.sh             # Initial setup script
├── requirements.yml         # Ansible Galaxy dependencies
├── inventory/
│   └── hosts.yml           # Localhost inventory
├── group_vars/
│   ├── all.yml             # Cross-platform variables
│   ├── darwin.yml          # macOS-specific variables
│   └── linux.yml           # Linux-specific variables
├── playbooks/
│   └── main.yml            # Main orchestration playbook
├── roles/
│   ├── homebrew/           # Package management
│   ├── tmux/               # tmux configuration
│   ├── neovim/             # Neovim configuration
│   ├── ghostty/            # Ghostty terminal
│   ├── zsh/                # Zsh + oh-my-zsh
│   ├── bash/               # Bash configuration
│   ├── aerospace/          # AeroSpace window manager (macOS)
│   ├── cli-tools/          # CLI tool configurations
│   └── macos-settings/     # macOS system settings
├── scripts/
│   └── update.sh           # Update script
└── README.md
```

## Usage

### Run Full Configuration

```bash
./bootstrap.sh
```

### Run Specific Components

Use tags to run only specific roles:

```bash
# Configure only tmux
ansible-playbook playbooks/main.yml --tags tmux

# Configure only neovim
ansible-playbook playbooks/main.yml --tags neovim

# Configure all shell configurations
ansible-playbook playbooks/main.yml --tags shell

# Configure macOS settings only
ansible-playbook playbooks/main.yml --tags macos

# Multiple tags
ansible-playbook playbooks/main.yml --tags "tmux,neovim,zsh"
```

### Available Tags

- `homebrew`, `packages` - Package management
- `zsh`, `bash`, `shell` - Shell configurations
- `tmux` - tmux configuration
- `neovim`, `nvim`, `editor` - Neovim setup
- `ghostty`, `terminal` - Ghostty terminal
- `aerospace`, `wm` - Window manager (macOS)
- `cli-tools`, `tools` - CLI tool configurations
- `macos`, `macos-settings` - macOS system settings

### Dry Run (Check Mode)

Preview changes without applying them:

```bash
ansible-playbook playbooks/main.yml --check --diff
```

### Verbose Output

For debugging:

```bash
ansible-playbook playbooks/main.yml -vv
```

## Customization

### Modify Variables

Edit the files in `group_vars/` to customize:

- **`group_vars/all.yml`** - Cross-platform settings and feature flags
- **`group_vars/darwin.yml`** - macOS-specific settings (hot corners, dock, etc.)
- **`group_vars/linux.yml`** - Linux-specific settings

### Enable/Disable Components

Toggle features in `group_vars/all.yml` or `group_vars/darwin.yml`:

```yaml
configure_tmux: true
configure_neovim: true
configure_zsh: true
configure_ghostty: true
configure_aerospace: true  # macOS only
configure_macos_settings: true  # macOS only
```

### Add Custom Packages

Edit Brewfiles:
- **macOS**: `roles/homebrew/files/Brewfile.darwin`
- **Linux**: `roles/homebrew/files/Brewfile.linux`

### Customize Dotfiles

Modify configuration files in each role's `files/` directory:
- `roles/tmux/files/.tmux.conf`
- `roles/neovim/files/nvim/init.lua`
- `roles/zsh/files/.zshrc`
- `roles/ghostty/files/config`
- etc.

### Add Custom Bash Scripts

Place custom scripts in `roles/bash/files/scripts/` and they will be:
1. Copied to `~/.local/bin/`
2. Made executable
3. Automatically sourced in your shell

## Platform Support

### macOS
- ✅ Full support (primary platform)
- ✅ Homebrew package management
- ✅ GUI applications via casks
- ✅ System settings configuration
- ✅ AeroSpace window manager

### Linux (Ubuntu/Debian)
- ✅ Homebrew for CLI tools
- ✅ All CLI configurations
- ⚠️ GUI apps require manual installation (apt/snap/flatpak)
- ❌ No system settings automation
- ❌ No AeroSpace (macOS only)

## Requirements

### Prerequisites
- **macOS**: macOS 10.15+ or **Linux**: Ubuntu 20.04+ / Debian 10+
- Git
- Internet connection
- Sudo access (for package installation and shell changes)

### Installed by Bootstrap
- Homebrew
- Ansible
- All other dependencies

## Post-Installation

After running the bootstrap:

1. **Restart your shell**
   ```bash
   exec $SHELL
   ```

2. **tmux**: Press `prefix + I` (Ctrl-a + I) to install plugins

3. **Neovim**: Launch `nvim` - plugins will install automatically

4. **macOS**: Log out and back in to apply all system settings

5. **Ghostty (Linux)**: Install from [GitHub releases](https://github.com/ghostty-org/ghostty/releases)

## Troubleshooting

### Homebrew not in PATH
Source your shell profile:
```bash
exec $SHELL
# or
source ~/.zshrc  # or ~/.bashrc
```

### Ansible command not found
```bash
brew install ansible
```

### Permission errors
Some tasks require sudo. Run with:
```bash
ansible-playbook playbooks/main.yml --ask-become-pass
```

### oh-my-zsh plugins not loading
Install missing plugins:
```bash
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

## Contributing

1. Make changes to the appropriate role or configuration
2. Test with `--check` mode first
3. Run the full playbook to verify
4. Commit and push changes

## License

MIT

## Credits

Built with:
- [Ansible](https://www.ansible.com/)
- [Homebrew](https://brew.sh/)
- [oh-my-zsh](https://ohmyz.sh/)
- [TPM](https://github.com/tmux-plugins/tpm)
- [lazy.nvim](https://github.com/folke/lazy.nvim)
- And many other amazing open-source projects
