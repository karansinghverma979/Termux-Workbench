# =========================================================
# 🎨 30-prompts.zsh : Sovereign Starship Prompt Switchboard
# =========================================================

STARSHIP_DISLIKED_FILE="$HOME/.config/starship_disliked.txt"
STARSHIP_THEME_FILE="$HOME/.config/starship_current_theme.txt"

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

Change-StarshipTheme() {
    local chosen="$1"
    local available=($(get_available_starship))
    if [[ -z "$chosen" || "$chosen" == "-i" ]] && command -v fzf >/dev/null 2>&1; then
        chosen=$(printf '%s\n' "${available[@]}" | fzf --prompt="Select Starship Preset > " --height=40% --reverse)
    fi
    if [[ -n "$chosen" ]]; then
        mkdir -p "$HOME/.config"
        echo "$chosen" > "$STARSHIP_THEME_FILE"
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
    starship preset "$next_preset" -o "$HOME/.config/starship.toml" --force
    echo -e "\033[32m✨ Switched to alternative Starship preset: $next_preset\033[0m"
    exec zsh
}

alias chship="Change-StarshipTheme"
alias rmship="Remove-StarshipTheme"

# --- Termux Font Suite ---
Change-TermuxFont() {
    local chosen="$1"
    local fonts_dir="$HOME/.termux/fonts"
    if [[ ! -d "$fonts_dir" ]]; then
        echo -e "\033[31m❌ Fonts directory $fonts_dir not found.\033[0m"
        return 1
    fi
    local available=($(ls "$fonts_dir" 2>/dev/null | grep -E '\.(ttf|otf)$' | sed 's/\.[^.]*$//'))
    if [[ -z "$chosen" || "$chosen" == "-i" ]] && command -v fzf >/dev/null 2>&1; then
        chosen=$(printf '%s\n' "reset (stock font)" "${available[@]}" | fzf --prompt="Select Termux Font > " --height=40% --reverse)
        [[ "$chosen" == "reset (stock font)" ]] && chosen="reset"
    fi
    if [[ "$chosen" == "reset" || "$chosen" == "none" || "$chosen" == "stock" ]]; then
        rm -f "$HOME/.termux/font.ttf"
        echo "Stock System Font" > "$HOME/.termux_current_font.txt"
        if command -v starship >/dev/null 2>&1; then
            starship preset no-nerd-font -o "$HOME/.config/starship.toml" --force 2>/dev/null || true
            echo "no-nerd-font" > "$HOME/.config/starship_current_theme.txt"
        fi
        if command -v termux-reload-settings >/dev/null 2>&1; then
            termux-reload-settings
        fi
        echo -e "\033[32m✨ Reset to Stock System Font (Starship auto-switched to 'no-nerd-font').\033[0m"
        return 0
    fi
    if [[ -n "$chosen" ]]; then
        local font_file=""
        if [[ -f "$fonts_dir/${chosen}.ttf" ]]; then
            font_file="$fonts_dir/${chosen}.ttf"
        elif [[ -f "$fonts_dir/${chosen}.otf" ]]; then
            font_file="$fonts_dir/${chosen}.otf"
        elif [[ -f "$fonts_dir/${chosen}" ]]; then
            font_file="$fonts_dir/${chosen}"
        fi

        if [[ -n "$font_file" && -f "$font_file" ]]; then
            cp -f "$font_file" "$HOME/.termux/font.ttf"
            echo "$chosen" > "$HOME/.termux_current_font.txt"
            if command -v termux-reload-settings >/dev/null 2>&1; then
                termux-reload-settings
            fi
            echo -e "\033[32m✨ Termux font switched to: $chosen (Reloaded)\033[0m"
        else
            echo -e "\033[33m⚠️ Unknown font '$chosen'. Available: ${available[*]}\033[0m"
        fi
    fi
}
alias chfont="Change-TermuxFont"

# Starship Prompt Engine Initialization
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init zsh)"
fi
