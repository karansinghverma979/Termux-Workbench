# =========================================================
# 🎨 30-prompts.zsh : Dual-Engine Prompt Switchboard
# =========================================================

PROMPT_ENGINE_FILE="$HOME/.prompt_engine"
STARSHIP_DISLIKED_FILE="$HOME/.config/starship_disliked.txt"
P10K_DISLIKED_FILE="$HOME/.p10k_disliked.txt"
STARSHIP_THEME_FILE="$HOME/.config/starship_current_theme.txt"
[[ ! -f "$PROMPT_ENGINE_FILE" ]] && echo "starship" > "$PROMPT_ENGINE_FILE"
ACTIVE_ENGINE=$(cat "$PROMPT_ENGINE_FILE" 2>/dev/null || echo "starship")

STARSHIP_ALL_PRESETS=(
    'tokyo-night'
    'catppuccin-powerline'
    'pastel-powerline'
    'gruvbox-rainbow'
    'bracketed-segments'
    'pure-preset'
    'jetpack'
    'nerd-font-symbols'
    'no-empty-icons'
    'no-nerd-font'
    'no-runtime-versions'
    'plain-text-symbols'
)

P10K_ALL_PRESETS=(
    'rainbow'
    'classic'
    'lean'
    'pure'
    'robbyrussell'
    'wizard'
)

get_available_p10k() {
    local disliked=()
    if [[ -f "$P10K_DISLIKED_FILE" ]]; then
        disliked=(${(f)"$(tr -d '\r' < "$P10K_DISLIKED_FILE")"})
    fi
    local avail=()
    for p in "${P10K_ALL_PRESETS[@]}"; do
        if (( ${disliked[(I)$p]} == 0 )); then
            avail+=("$p")
        fi
    done
    if (( ${#avail[@]} == 0 )); then
        rm -f "$P10K_DISLIKED_FILE"
        avail=("${P10K_ALL_PRESETS[@]}")
    fi
    echo "${avail[@]}"
}

get_available_starship() {
    local disliked=()
    if [[ -f "$STARSHIP_DISLIKED_FILE" ]]; then
        disliked=(${(f)"$(tr -d '\r' < "$STARSHIP_DISLIKED_FILE")"})
    fi
    local avail=()
    for p in "${STARSHIP_ALL_PRESETS[@]}"; do
        if (( ${disliked[(I)$p]} == 0 )); then
            avail+=("$p")
        fi
    done
    if (( ${#avail[@]} == 0 )); then
        rm -f "$STARSHIP_DISLIKED_FILE"
        avail=("${STARSHIP_ALL_PRESETS[@]}")
    fi
    echo "${avail[@]}"
}

Change-P10kTheme() {
    local chosen="$1"
    local available=($(get_available_p10k))
    if [[ -z "$chosen" || "$chosen" == "-i" ]] && command -v fzf >/dev/null 2>&1; then
        chosen=$(printf '%s\n' "${available[@]}" | fzf --prompt="Select Powerlevel10k Theme > " --height=40% --reverse)
    fi
    if [[ "$chosen" == *"wizard"* || "$chosen" == "config" || "$chosen" == "configure" ]]; then
        echo -e "\033[35m🎨 Launching Powerlevel10k Configuration Wizard...\033[0m"
        [[ -f "$HOME/.powerlevel10k/powerlevel10k.zsh-theme" ]] && source "$HOME/.powerlevel10k/powerlevel10k.zsh-theme"
        p10k configure
        exec zsh
        return
    fi
    if [[ -n "$chosen" ]]; then
        local preset_file="$HOME/.powerlevel10k/config/p10k-${chosen}.zsh"
        if [[ -f "$preset_file" ]]; then
            cp "$preset_file" "$HOME/.p10k.zsh"
            echo "$chosen" > "$HOME/.p10k_current_theme.txt"
            echo "p10k" > "$PROMPT_ENGINE_FILE"
            echo -e "\033[32m🎨 Powerlevel10k theme switched to: $chosen (Reloading...)\033[0m"
            exec zsh
        else
            echo -e "\033[33m⚠️ Unknown preset '$chosen'. Available: ${available[*]}\033[0m"
        fi
    fi
}

Remove-P10kTheme() {
    local cur=$(cat "$HOME/.p10k_current_theme.txt" 2>/dev/null)
    if [[ -z "$cur" ]]; then
        cur=$(grep -oE "p10k-[a-z0-9-]+" "$HOME/.p10k.zsh" 2>/dev/null | head -n1 | sed 's/p10k-//')
    fi
    [[ -z "$cur" ]] && cur="classic"

    echo -e "\033[31m🗑️ Permanently blacklisting Powerlevel10k theme: '$cur'...\033[0m"
    echo "$cur" >> "$P10K_DISLIKED_FILE"

    local available=($(get_available_p10k))
    local next_preset="${available[1]}"
    [[ -z "$next_preset" || "$next_preset" == "wizard" ]] && next_preset="classic"

    local preset_file="$HOME/.powerlevel10k/config/p10k-${next_preset}.zsh"
    if [[ -f "$preset_file" ]]; then
        cp "$preset_file" "$HOME/.p10k.zsh"
    fi
    echo "$next_preset" > "$HOME/.p10k_current_theme.txt"
    echo "p10k" > "$PROMPT_ENGINE_FILE"
    echo -e "\033[32m✨ Switched to alternative Powerlevel10k theme: $next_preset\033[0m"
    exec zsh
}

Change-StarshipTheme() {
    local chosen="$1"
    local available=($(get_available_starship))
    if [[ -z "$chosen" || "$chosen" == "-i" ]] && command -v fzf >/dev/null 2>&1; then
        chosen=$(printf '%s\n' "${available[@]}" | fzf --prompt="Select Starship Preset > " --height=40% --reverse)
    fi
    if [[ -n "$chosen" ]]; then
        mkdir -p "$HOME/.config"
        echo "$chosen" > "$STARSHIP_THEME_FILE"
        echo "starship" > "$PROMPT_ENGINE_FILE"
        starship preset "$chosen" -o "$HOME/.config/starship.toml" --force
        echo -e "\033[32m🚀 Starship preset switched to: $chosen (Reloading...)\033[0m"
        exec zsh
    fi
}

Remove-StarshipTheme() {
    local cur=$(cat "$STARSHIP_THEME_FILE" 2>/dev/null)
    [[ -z "$cur" ]] && cur="nerd-font-symbols"

    echo -e "\033[31m🗑️ Permanently blacklisting Starship theme: '$cur'...\033[0m"
    mkdir -p "$HOME/.config"
    echo "$cur" >> "$STARSHIP_DISLIKED_FILE"

    local available=($(get_available_starship))
    local next_preset="${available[$((RANDOM % ${#available[@]} + 1))]}"
    [[ -z "$next_preset" ]] && next_preset="nerd-font-symbols"

    echo "$next_preset" > "$STARSHIP_THEME_FILE"
    echo "starship" > "$PROMPT_ENGINE_FILE"
    starship preset "$next_preset" -o "$HOME/.config/starship.toml" --force
    echo -e "\033[32m✨ Switched to alternative Starship preset: $next_preset\033[0m"
    exec zsh
}

Use-StarshipPrompt() {
    echo "starship" > "$PROMPT_ENGINE_FILE"
    echo -e "\033[36m🚀 Switched active prompt engine to Starship. Reloading...\033[0m"
    exec zsh
}

Use-P10kPrompt() {
    echo "p10k" > "$PROMPT_ENGINE_FILE"
    echo -e "\033[35m🎨 Switched active prompt engine to Powerlevel10k. Reloading...\033[0m"
    exec zsh
}

alias chp10k="Change-P10kTheme"
alias rmp10k="Remove-P10kTheme"
alias chship="Change-StarshipTheme"
alias rmship="Remove-StarshipTheme"
alias use-starship="Use-StarshipPrompt"
alias use-p10k="Use-P10kPrompt"

# Engine Boot Loader
if [[ "$ACTIVE_ENGINE" == "p10k" ]]; then
    if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
        source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
    fi
    [[ -f "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"
    [[ -f "$HOME/.powerlevel10k/powerlevel10k.zsh-theme" ]] && source "$HOME/.powerlevel10k/powerlevel10k.zsh-theme"
else
    if command -v starship >/dev/null 2>&1; then
        eval "$(starship init zsh)"
    fi
fi
