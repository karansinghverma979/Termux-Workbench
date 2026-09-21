# =========================================================
# 💻 50-peer-bridge.zsh : Federated Workstation SSH Bridge
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

# Auto-trust peer PC public key if configured
if [[ -n "$PEER_PC_PUBKEY" ]]; then
    mkdir -p "$HOME/.ssh"
    if [[ ! -f "$HOME/.ssh/authorized_keys" ]] || ! grep -qF "$PEER_PC_PUBKEY" "$HOME/.ssh/authorized_keys" 2>/dev/null; then
        echo "$PEER_PC_PUBKEY" >> "$HOME/.ssh/authorized_keys"
        chmod 700 "$HOME/.ssh"
        chmod 600 "$HOME/.ssh/authorized_keys"
    fi
fi

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
        echo -e "\033[0;36m💡 Type 'peer' to reconnect once PC is back online.\033[0m\n"
    fi
}
# Primary connection alias — the only command you need
alias motobook="Connect-Peer"
