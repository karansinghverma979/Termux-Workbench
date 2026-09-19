# =========================================================
# 🪟 40-tmux.zsh : Persistent Session Control Suite
# =========================================================

Start-Session() {
    local sname="${1:-main}"
    if [[ -n "$TMUX" ]]; then
        echo -e "\033[33mAlready inside tmux session: $TMUX\033[0m"
        return
    fi
    if tmux has-session -t "$sname" 2>/dev/null; then
        echo -e "\033[36m⚡ Attaching to persistent session: $sname\033[0m"
        tmux attach-session -t "$sname"
    else
        echo -e "\033[32m🚀 Starting new persistent session: $sname\033[0m"
        tmux new-session -s "$sname"
    fi
}

Get-Session() {
    tmux list-sessions 2>/dev/null || echo -e "\033[33mNo persistent tmux sessions running.\033[0m"
}

Stop-Session() {
    local sname="${1:-main}"
    if [[ "$1" == "-a" || "$1" == "--all" ]]; then
        tmux kill-server 2>/dev/null && echo -e "\033[31m🗑️ Killed all tmux sessions.\033[0m"
    else
        tmux kill-session -t "$sname" 2>/dev/null && echo -e "\033[31m🗑️ Killed session '$sname'.\033[0m"
    fi
}

Set-SessionAuto() {
    if [[ "$1" == "on" ]]; then
        touch "$HOME/.tmux_auto_attach"
        echo -e "\033[32m✅ Tmux auto-attach ON (Termux will launch into tmux automatically).\033[0m"
    elif [[ "$1" == "off" ]]; then
        rm -f "$HOME/.tmux_auto_attach"
        echo -e "\033[33m⚡ Tmux auto-attach OFF (Termux will launch into instant Zsh).\033[0m"
    else
        if [[ -f "$HOME/.tmux_auto_attach" ]]; then
            echo "Tmux auto-attach is currently: ON"
        else
            echo "Tmux auto-attach is currently: OFF (Instant Zsh)"
        fi
    fi
}

alias session="Start-Session"
alias session-list="Get-Session"
alias session-kill="Stop-Session"
alias session-auto="Set-SessionAuto"

# Optional Auto-Attach if enabled by user
if [[ -o interactive && -f "$HOME/.tmux_auto_attach" && -z "$TMUX" && -z "$SSH_CONNECTION" ]]; then
    Start-Session main
fi
