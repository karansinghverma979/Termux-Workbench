# =========================================================
# 📡 10-telemetry.zsh : Centered Boot Telemetry & Sentinel
# =========================================================

show_boot_telemetry() {
    # 1. Background Wake-Lock & SSH Daemon supervision
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
    local pc_ip=$(find_peer_ip 2>/dev/null || echo "")
    local active_sessions=$(pgrep -f sshd-session 2>/dev/null | wc -l)
    local peer_status="None (Listening)"
    if [[ "$active_sessions" -gt 0 || -n "$SSH_CONNECTION" ]]; then
        peer_status="${PEER_PC_NAME:-"Workstation"} (Active)"
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
    echo -e "${pad}${c1}📱 THIS DEVICE (${DEVICE_NAME:-"Termux Node"})${rst}"
    echo -e "${pad}• IP:   ${cy}${phone_ip}${rst}"
    echo -e "${pad}• SSH:  ${cg}Port 8022 (Ready)${rst}"
    if [[ "$peer_status" == *"Active"* ]]; then
        echo -e "${pad}• Peer: ${cg}${PEER_PC_NAME:-"Workstation"} (Active)${rst}"
    else
        echo -e "${pad}• Peer: ${cy}None (Listening)${rst}"
    fi

    # ── SECTION 2: REMOTE PEER PC ──
    echo ""
    echo -e "${pad}${c2}💻 REMOTE PC (${PEER_PC_NAME:-"Workstation"})${rst}"
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
