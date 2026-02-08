#!/usr/bin/env bash

HOMEBREW_INSTALL_URL="https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"
OH_MY_ZSH_INSTALL_URL="https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"

if [[ "$(uname -m)" == "arm64" ]]; then
    HOMEBREW_PREFIX="/opt/homebrew"
else
    HOMEBREW_PREFIX="/usr/local"
fi

# Hot corners
# 0: none, 2: mission control, 3: app windows, 4: desktop,
# 5: start screen saver, 6: disable screen saver, 10: display sleep,
# 11: launchpad, 12: notification center, 13: lock screen
HOT_CORNER_TOP_LEFT=10
HOT_CORNER_TOP_RIGHT=5
HOT_CORNER_BOTTOM_LEFT=0
HOT_CORNER_BOTTOM_RIGHT=0

# Dock
DOCK_ICON_SIZE=48
DOCK_AUTOHIDE=true
DOCK_ORIENTATION="bottom"
DOCK_SHOW_RECENTS=false
DOCK_APPLICATIONS=(
    "LibreWolf|/Applications/LibreWolf.app"
    "Mail|/System/Applications/Mail.app"
    "Calendar|/System/Applications/Calendar.app"
    "iPhone Mirroring|/System/Applications/iPhone Mirroring.app"
)
DOCK_FOLDERS=(
    "$HOME/Downloads|folder|fan"
)

# Finder
FINDER_SHOW_HIDDEN=true
FINDER_SHOW_EXTENSIONS=true
FINDER_DEFAULT_VIEW="Nlsv"

# ZSH plugins
ZSH_PLUGINS=(
    "https://github.com/zsh-users/zsh-syntax-highlighting.git|zsh-syntax-highlighting"
    "https://github.com/jeffreytse/zsh-vi-mode.git|zsh-vi-mode"
    "https://github.com/zsh-users/zsh-autosuggestions.git|zsh-autosuggestions"
)
