eval "$(/opt/homebrew/bin/brew shellenv)"

export PATH="$PATH:$HOME/.local/bin/:$HOME/.local/bin/scripts/:$HOME/go/bin/"
export TERM="xterm-ghostty"
export EDITOR='nvim'
export VISUAL='nvim'
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"

if command -v fzf &> /dev/null; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
    export FZF_DEFAULT_OPTS='
        --height 40%
        --layout=reverse
        --border
        --preview "bat --style=numbers --color=always --line-range :500 {}"
    '
fi
