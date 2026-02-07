# Zsh Configuration with oh-my-zsh

export ZSH="$HOME/.oh-my-zsh"
export PATH="$PATH:$HOME/.local/bin/"
export PATH="$PATH:$HOME/go/bin/"
export TERM="xterm-ghostty"

ZSH_THEME="robbyrussell"
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    fzf
)

source $ZSH/oh-my-zsh.sh

export EDITOR='nvim'
export VISUAL='nvim'
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"

HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY

alias vi='nvim'
alias rr="rm -rf __pycache__"
alias ls="eza --color=always --long --git --icons=always --no-user --no-permissions"
alias ll="ls -la"
alias lt='eza --tree --icons'
alias cat='bat'
alias cd='z'
alias lg='lazygit'
alias gs='git status'
alias glog='git log --oneline --graph --decorate'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias grep='grep --color=auto'
alias mkdir='mkdir -pv'
alias a='source .venv/bin/activate'
alias dc='deactivate'

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

if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh)"
fi

