# =========================================================
# ⚡ 60-aliases.zsh : Utility Aliases & Custom Handlers
# =========================================================

Restart-Shell() {
    exec zsh
}
alias reload="Restart-Shell"

alias ls="ls --color=auto"
alias ll="ls -la --color=auto"

if command -v bat >/dev/null 2>&1; then
    alias cat="bat --paging=never"
fi

if command -v eza >/dev/null 2>&1; then
    alias l="eza -lah --icons"
    alias tree="eza --tree --icons"
fi

# Quick navigation shortcuts
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias c="clear"
alias q="exit"

# Git quick aliases
alias gs="git status -sb"
alias ga="git add"
alias gc="git commit -m"
alias gp="git push"
alias gl="git log --oneline -n 10"
alias gd="git diff"
