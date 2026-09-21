# =========================================================
# 📱 Blaze High-Speed Zsh Configuration
# =========================================================

# Environment & PATH
export PATH="$HOME/.local/bin:$PREFIX/bin:$PATH"
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# History Settings
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE

# Smart Directory Navigation
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS

# Colorized Help & Man Pages
export LESS_TERMCAP_mb=$'\e[1;31m'
export LESS_TERMCAP_md=$'\e[1;36m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;44;33m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;32m'
export LESS_TERMCAP_ue=$'\e[0m'

# Prompt Engine State Variable
PROMPT_ENGINE_FILE="$HOME/.prompt_engine"
STARSHIP_DISLIKED_FILE="$HOME/.config/starship_disliked.txt"
P10K_DISLIKED_FILE="$HOME/.p10k_disliked.txt"
STARSHIP_THEME_FILE="$HOME/.config/starship_current_theme.txt"
[[ ! -f "$PROMPT_ENGINE_FILE" ]] && echo "starship" > "$PROMPT_ENGINE_FILE"
ACTIVE_ENGINE=$(cat "$PROMPT_ENGINE_FILE" 2>/dev/null || echo "starship")

# =========================================================
# 🔒 Peer PC Bridge & Auto-Discovery Configuration
# =========================================================
# Optional: Load workstation overrides from ~/.peer_pc.env if present
[[ -f "$HOME/.peer_pc.env" ]] && source "$HOME/.peer_pc.env"

DEVICE_NAME="${DEVICE_NAME:-"Termux Node"}"
PEER_PC_NAME="${PEER_PC_NAME:-"Workstation"}"
PEER_PC_USER="${PEER_PC_USER:-"user"}"
PEER_PC_PORT="${PEER_PC_PORT:-22}"
PEER_PC_IP_OVERRIDE="${PEER_PC_IP_OVERRIDE:-""}"
PEER_PC_PUBKEY="${PEER_PC_PUBKEY:-""}"

find_peer_ip() {
    local candidate=$(cat "$HOME/.ssh_last_client" 2>/dev/null)
    if [[ -n "$candidate" ]] && nc -z -w 1 "$candidate" "${PEER_PC_PORT}" 2>/dev/null; then
        echo "$candidate"
        return
    fi
    local gw=$(ip route 2>/dev/null | awk '/default/ {print $3}')
    if [[ -n "$gw" ]] && nc -z -w 1 "$gw" "${PEER_PC_PORT}" 2>/dev/null; then
        echo "$gw"
        return
    fi
    if [[ -n "$PEER_PC_IP_OVERRIDE" ]] && nc -z -w 1 "$PEER_PC_IP_OVERRIDE" "${PEER_PC_PORT}" 2>/dev/null; then
        echo "$PEER_PC_IP_OVERRIDE"
        return
    fi
    echo ""
}

show_boot_telemetry() {
    # 0. Trust Peer PC's public key if defined
    if [[ -n "$PEER_PC_PUBKEY" ]]; then
        mkdir -p "$HOME/.ssh"
        if [[ ! -f "$HOME/.ssh/authorized_keys" ]] || ! grep -qF "$PEER_PC_PUBKEY" "$HOME/.ssh/authorized_keys" 2>/dev/null; then
            echo "$PEER_PC_PUBKEY" >> "$HOME/.ssh/authorized_keys"
            chmod 700 "$HOME/.ssh"
            chmod 600 "$HOME/.ssh/authorized_keys"
        fi
    fi

    # 1. Ensure Background Wake-Lock & SSH Daemon are active
    if command -v termux-wake-lock >/dev/null 2>&1; then termux-wake-lock 2>/dev/null; fi
    if ! pgrep -x sshd >/dev/null 2>&1; then
        sshd >/dev/null 2>&1
    fi

    # 2. Track incoming SSH client info
    if [[ -n "$SSH_CONNECTION" ]]; then
        local client_ip=$(echo "$SSH_CONNECTION" | awk '{print $1}')
        echo "$client_ip" > "$HOME/.ssh_last_client"
    fi

    # 3. Detect local Phone IP
    local phone_ip=$(ifconfig 2>/dev/null | grep -oE "inet [0-9.]+" | grep -v "127.0.0.1" | awk '{print $2}' | head -n1)
    [[ -z "$phone_ip" ]] && phone_ip="127.0.0.1"

    # 4. Probe Peer PC status
    local pc_ip=$(find_peer_ip)
    local active_sessions=$(pgrep -f sshd-session 2>/dev/null | wc -l)
    local peer_status="None (Listening)"
    if [[ "$active_sessions" -gt 0 || -n "$SSH_CONNECTION" ]]; then
        peer_status="${PEER_PC_NAME} (Active)"
    fi

    # 5. Dynamic Horizontal Centering
    local cols=${COLUMNS:-$(tput cols 2>/dev/null || echo 40)}
    local block_w=28
    local pad_len=$(( (cols - block_w) / 2 ))
    [[ $pad_len -lt 0 ]] && pad_len=0
    local pad=$(printf '%*s' "$pad_len" "")

    # Palette
    local c1="\033[1;36m" # Cyan
    local c2="\033[1;35m" # Magenta
    local cg="\033[1;32m" # Green
    local cy="\033[1;33m" # Yellow
    local cr="\033[1;31m" # Red
    local rst="\033[0m"

    # ── SECTION 1: THIS LOCAL DEVICE ──
    echo -e "${pad}${c1}📱 THIS DEVICE (${DEVICE_NAME})${rst}"
    echo -e "${pad}• IP:   ${cy}${phone_ip}${rst}"
    echo -e "${pad}• SSH:  ${cg}Port 8022 (Ready)${rst}"
    if [[ "$peer_status" == *"Active"* ]]; then
        echo -e "${pad}• Peer: ${cg}${PEER_PC_NAME} (Active)${rst}"
    else
        echo -e "${pad}• Peer: ${cy}None (Listening)${rst}"
    fi

    # ── SECTION 2: REMOTE PEER PC ──
    echo ""
    echo -e "${pad}${c2}💻 REMOTE PC (${PEER_PC_NAME})${rst}"
    if [[ -n "$pc_ip" ]]; then
        echo -e "${pad}• Status: ${cg}🟢 Online (${pc_ip})${rst}"
        echo -e "${pad}• Action: ${cg}Type 'peer' to connect${rst}"
    else
        echo -e "${pad}• Status: ${cr}🔴 Offline / Standby${rst}"
        echo -e "${pad}• Action: ${cy}Verify SSH service on PC${rst}"
    fi
}

# Run Telemetry on Interactive Startup (Before Prompt Init)
if [[ -o interactive && -z "$TMUX" && -z "$SSH_CONNECTION" ]]; then
    show_boot_telemetry
fi

# =========================================================
# 💻 1. Connect-Peer (1:1 Verb-Noun & Semantic Alias)
# =========================================================
Connect-Peer() {
    local target_ip=$(find_peer_ip)
    if [[ -z "$target_ip" ]]; then
        target_ip=$(cat "$HOME/.ssh_last_client" 2>/dev/null)
    fi
    if [[ -z "$target_ip" ]]; then
        target_ip=$(ip route 2>/dev/null | awk '/default/ {print $3}')
    fi
    [[ -z "$target_ip" && -n "$PEER_PC_IP_OVERRIDE" ]] && target_ip="$PEER_PC_IP_OVERRIDE"

    if [[ -z "$target_ip" ]]; then
        echo -e "\033[31m⚠️ No peer workstation discovered.\033[0m"
        echo -e "\033[33m💡 Set PEER_PC_IP_OVERRIDE in ~/.peer_pc.env or start hotspot.\033[0m"
        return 1
    fi

    mkdir -p "$HOME/.ssh"
    cat << SSHEOF > "$HOME/.ssh/config"
Host peer
    HostName $target_ip
    Port $PEER_PC_PORT
    User $PEER_PC_USER
    IdentityFile ~/.ssh/id_ed25519
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null
    ServerAliveInterval 3
    ServerAliveCountMax 2
    ConnectTimeout 3
    LogLevel ERROR
SSHEOF

    echo -e "\033[36m💻 Connecting to ${PEER_PC_NAME} (${PEER_PC_USER}@${target_ip}:${PEER_PC_PORT})...\033[0m"
    ssh peer "$@"
    local exit_code=$?
    if [[ $exit_code -eq 255 ]]; then
        echo ""
        echo -e "\033[1;33m⚠️ [Connection Dropped] ${PEER_PC_NAME} disconnected or network switched.\033[0m"
        echo -e "\033[0;36m💡 Type 'motobook' to reconnect once PC is back online.\033[0m\n"
    fi
}
# Primary connection alias — the only command you need
alias motobook="Connect-Peer"

# =========================================================
# 🏷️ 2. Sticky Tab Title Engine & Presets
# =========================================================
TITLE_CONFIG_FILE="$HOME/.config/terminal_titles.json"
typeset -g STICKY_TAB_TITLE=""

get_title_presets() {
    mkdir -p "$HOME/.config"
    if [[ ! -f "$TITLE_CONFIG_FILE" ]]; then
        cat << 'EOF' > "$TITLE_CONFIG_FILE"
{
  "dev": "🛠️ Dev",
  "termux": "📲 Termux"
}
EOF
    fi
}

title() {
    get_title_presets
    local target="$1"

    # Help manual
    if [[ "$target" == "-h" || "$target" == "--help" || "$target" == "help" || "$target" == "?" ]]; then
        echo -e "\033[36m🏷️ WORKSPACE TAB TITLE ENGINE (title)\033[0m"
        echo -e "\033[33mUsage:\033[0m"
        echo -e "   title                        # Open interactive visual FZF title picker"
        echo -e "   title <name>                 # Switch active tab title directly to preset or string"
        echo -e "   title -Name <k> -Value <v>   # Add or update a preset with distinct value"
        echo -e "   title -Name <k>              # Add or update a preset where key = value"
        echo -e "   title -Name <k> -Delete      # Delete a preset permanently"
        echo -e "   title -h                     # Show this help manual"
        return 0
    fi

    # Manage Preset (-Name)
    if [[ "$1" == "-Name" || "$1" == "-name" ]]; then
        local key="$2"
        if [[ -z "$key" ]]; then
            echo -e "\033[31m⚠️ Error: Key name required.\033[0m"
            return 1
        fi
        if [[ "$3" == "-Delete" || "$3" == "-delete" ]]; then
            jq "del(.\"$key\")" "$TITLE_CONFIG_FILE" > "$TITLE_CONFIG_FILE.tmp" && mv "$TITLE_CONFIG_FILE.tmp" "$TITLE_CONFIG_FILE"
            echo -e "\033[33m🗑️ Deleted title preset: '$key'\033[0m"
            return 0
        fi
        local val="$key"
        if [[ "$3" == "-Value" || "$3" == "-value" ]]; then
            val="$4"
            [[ -z "$val" ]] && val="$key"
        fi
        jq ".\"$key\" = \"$val\"" "$TITLE_CONFIG_FILE" > "$TITLE_CONFIG_FILE.tmp" && mv "$TITLE_CONFIG_FILE.tmp" "$TITLE_CONFIG_FILE"
        echo -e "\033[32m✨ Saved preset '$key' ──► '$val'\033[0m"
        return 0
    fi

    # Direct Title Setting
    if [[ -n "$target" ]]; then
        if [[ "$target" =~ ^(reset|--reset|-reset|default|--default)$ ]]; then
            STICKY_TAB_TITLE=""
            precmd_title
            echo -e "\033[90m🏷️ Tab title reset to dynamic Termux default.\033[0m"
            return 0
        fi

        local preset_val=$(jq -r ".\"$target\" // empty" "$TITLE_CONFIG_FILE" 2>/dev/null)
        if [[ -n "$preset_val" ]]; then
            STICKY_TAB_TITLE="$preset_val"
        else
            STICKY_TAB_TITLE="$target"
        fi
        set_term_title "$STICKY_TAB_TITLE"
        echo -e "\033[36m🏷️ Tab title set to: $STICKY_TAB_TITLE (Sticky for this session)\033[0m"
        return 0
    fi

    # Interactive FZF Picker
    if command -v fzf >/dev/null 2>&1; then
        local menu_lines=()
        while IFS="=" read -r k v; do
            [[ -n "$k" ]] && menu_lines+=("$(printf '%-10s' "$k") ──► $v")
        done < <(jq -r 'to_entries[] | "\(.key)=\(.value)"' "$TITLE_CONFIG_FILE" 2>/dev/null)
        menu_lines+=("reset      ──► 🔄 [Dynamic Termux Default]")

        local choice=$(printf '%s\n' "${menu_lines[@]}" | fzf --prompt="Select Workspace Title > " --height=40% --reverse --header="[Enter to Select | Esc to Cancel]")
        if [[ -n "$choice" ]]; then
            local chosen_key=$(echo "$choice" | awk '{print $1}')
            if [[ "$chosen_key" == "reset" ]]; then
                STICKY_TAB_TITLE=""
                precmd_title
                echo -e "\033[90m🏷️ Tab title reset to dynamic Termux default.\033[0m"
            else
                local target_title=$(jq -r ".\"$chosen_key\"" "$TITLE_CONFIG_FILE" 2>/dev/null)
                STICKY_TAB_TITLE="$target_title"
                set_term_title "$STICKY_TAB_TITLE"
                echo -e "\033[36m🏷️ Tab title set to: $STICKY_TAB_TITLE (Sticky for this session)\033[0m"
            fi
        fi
    fi
}

set_term_title() {
    printf '\033]0;%s\007' "$1"
}

precmd_title() {
    local last_status=$?

    # 1. Sticky Title Immunity: 100% frozen & clean (no failure cross, no flicker)
    if [[ -n "$STICKY_TAB_TITLE" ]]; then
        set_term_title "${STICKY_TAB_TITLE}"
        return
    fi

    # 2. Dynamic Default Mode
    local current_dir
    if [[ "$PWD" == "$HOME" ]]; then
        current_dir="~"
    else
        current_dir="${PWD:t}"
    fi

    if (( last_status != 0 )); then
        set_term_title "❌ ${current_dir} [${ACTIVE_ENGINE}]"
    else
        set_term_title "📲 ${current_dir} [${ACTIVE_ENGINE}]"
    fi
}

preexec_title() {
    # 1. Sticky Title Immunity: never alter title if user set a sticky title
    if [[ -n "$STICKY_TAB_TITLE" ]]; then
        return
    fi

    local cmd="$1"
    local first_cmd="${cmd%%[;|&]*}"
    local -a words; words=(${(z)first_cmd})
    local main_tool=""
    for w in "${words[@]}"; do
        if [[ "$w" == *"="* || "$w" == "sudo" || "$w" == "doas" || "$w" == "nohup" || "$w" == "time" || "$w" == "builtin" || "$w" == "command" ]]; then
            continue
        fi
        main_tool="${w:t}"
        break
    done
    [[ -z "$main_tool" ]] && return

    # 2. Smart Filter: Ignore instant micro-commands to prevent visual flicker
    case "$main_tool" in
        cd|ls|ll|dir|clear|cls|cat|bat|pwd|echo|exit|history|which|where|type|true|false)
            return
            ;;
        *)
            set_term_title "⚡ ${main_tool}"
            ;;
    esac
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd precmd_title
add-zsh-hook preexec preexec_title

# =========================================================
# ⚡ 3. Tmux Persistent Session Suite (Verb-Noun & Semantic)
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

# =========================================================
# 🎨 4. Unified Theme Switcher & Prompt Suite (With Blacklist)
# =========================================================
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

# --- Powerlevel10k Theme Suite ---
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

    echo -e "\033[31m🗑️ Permanently deleting and blacklisting Powerlevel10k theme: '$cur'...\033[0m"
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

# --- Starship Theme Suite ---
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

    echo -e "\033[31m🗑️ Permanently deleting and blacklisting Starship theme: '$cur'...\033[0m"
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

# --- Prompt Engine Switchers ---
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

# 1:1 Verb-Noun to Semantic Aliases
alias chp10k="Change-P10kTheme"
alias rmp10k="Remove-P10kTheme"
alias chship="Change-StarshipTheme"
alias rmship="Remove-StarshipTheme"
alias use-starship="Use-StarshipPrompt"
alias use-p10k="Use-P10kPrompt"

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
        chosen=$(printf '%s\n' "${available[@]}" | fzf --prompt="Select Termux Nerd Font > " --height=40% --reverse)
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

# =========================================================
# ⚡ 5. Plugins & Autocompletion Suite
# =========================================================
autoload -Uz compinit && compinit -C
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' menu select

# 1. FZF-Tab (Interactive fuzzy tab completion menu)
if [[ -f "$HOME/.zsh/fzf-tab/fzf-tab.plugin.zsh" ]]; then
    source "$HOME/.zsh/fzf-tab/fzf-tab.plugin.zsh"
    zstyle ':fzf-tab:*' fzf-flags --height=40% --reverse
fi

# 2. Zsh Autosuggestions (Fish-style ghost text autocompletion)
if [[ -f "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
    source "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"
    ZSH_AUTOSUGGEST_STRATEGY=(history completion)
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=244'
fi

# 3. Zsh Autopair (Auto-closes quotes, brackets, and parens on mobile)
if [[ -f "$HOME/.zsh/zsh-autopair/autopair.zsh" ]]; then
    source "$HOME/.zsh/zsh-autopair/autopair.zsh"
    autopair-init
fi

# 4. Zsh You-Should-Use (Teaches shorthand aliases)
if [[ -f "$HOME/.zsh/zsh-you-should-use/you-should-use.plugin.zsh" ]]; then
    source "$HOME/.zsh/zsh-you-should-use/you-should-use.plugin.zsh"
fi

# 5. Zsh History Substring Search (Up/Down arrow fuzzy search matching current line)
if [[ -f "$HOME/.zsh/zsh-history-substring-search/zsh-history-substring-search.zsh" ]]; then
    source "$HOME/.zsh/zsh-history-substring-search/zsh-history-substring-search.zsh"
    bindkey '^[[A' history-substring-search-up
    bindkey '^[[B' history-substring-search-down
    bindkey -M vicmd 'k' history-substring-search-up
    bindkey -M vicmd 'j' history-substring-search-down
fi

# 6. Fast Syntax Highlighting (High-performance replacement for zsh-syntax-highlighting)
if [[ -f "$HOME/.zsh/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh" ]]; then
    source "$HOME/.zsh/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
elif [[ -f "$HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
    source "$HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# 7. Zoxide (Smart directory jumping)
if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init zsh)"
fi

# 8. Direct FZF Keybindings & Completions (Zero Eval Overhead)
if [[ -f "$PREFIX/share/fzf/key-bindings.zsh" ]]; then
    source "$PREFIX/share/fzf/key-bindings.zsh" 2>/dev/null
fi
if [[ -f "$PREFIX/share/fzf/completion.zsh" ]]; then
    source "$PREFIX/share/fzf/completion.zsh" 2>/dev/null
fi

# =========================================================
# 🛠️ 6. Standard Utilities & Shell Control
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
