# Zsh Configuration with oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"
plugins=(
    git
    fzf
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

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
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias grep='grep --color=auto'
alias mkdir='mkdir -pv'
alias a='source .venv/bin/activate'
alias dc='deactivate'
alias c='agent'

if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh)"
fi
