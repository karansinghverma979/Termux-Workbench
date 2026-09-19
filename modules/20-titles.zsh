# =========================================================
# 🏷️ 20-titles.zsh : Dynamic Tab Title Sentinel
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
            echo -e "\033[90m🏷️ Tab title reset to dynamic default.\033[0m"
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
        menu_lines+=("reset      ──► 🔄 [Dynamic Default]")

        local choice=$(printf '%s\n' "${menu_lines[@]}" | fzf --prompt="Select Workspace Title > " --height=40% --reverse --header="[Enter to Select | Esc to Cancel]")
        if [[ -n "$choice" ]]; then
            local chosen_key=$(echo "$choice" | awk '{print $1}')
            if [[ "$chosen_key" == "reset" ]]; then
                STICKY_TAB_TITLE=""
                precmd_title
                echo -e "\033[90m🏷️ Tab title reset to dynamic default.\033[0m"
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

    # 1. Sticky Title Immunity: 100% frozen & clean
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

    local active_engine=$(cat "$HOME/.prompt_engine" 2>/dev/null || echo "starship")
    if (( last_status != 0 )); then
        set_term_title "❌ ${current_dir} [${active_engine}]"
    else
        set_term_title "📲 ${current_dir} [${active_engine}]"
    fi
}

preexec_title() {
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

    # Smart Filter: Ignore instant micro-commands to prevent visual flicker
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
