#!/data/data/com.termux/files/usr/bin/bash
# ==============================================================================
# ⚡ Termux-Workbench: Turnkey Mobile DevOps & Terminal Workstation Installer
# Complete Hands-Free Automation: Packages, Fonts, SSH, API, Touch Matrix & Starship
# ==============================================================================

set -e

CYAN='\033[1;36m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
MAGENTA='\033[1;35m'
BOLD='\033[1m'
NC='\033[0m'

echo -e "${CYAN}${BOLD}"
cat << 'EOF'
 ┌─────────────────────────────────────────────────────────────┐
 │       ⚡ TERMUX-WORKBENCH : TURNKEY DEVOPS WORKSTATION       │
 │   Automated Packages • SSH Key Bridge • Fonts • 2×7 Touch   │
 └─────────────────────────────────────────────────────────────┘
EOF
echo -e "${NC}"

# 1. Environment Verification
if [ ! -d "/data/data/com.termux/files/home" ]; then
    echo -e "${RED}❌ Error: This installer must be executed inside Android Termux.${NC}"
    exit 1
fi

HOME_DIR="/data/data/com.termux/files/home"
WORKBENCH_DIR="${HOME_DIR}/.termux-workbench"
BACKUP_DIR="${HOME_DIR}/.termux_workbench_backup_$(date +%Y%m%d_%H%M%S)"

# Resolve script directory or self-bootstrap from GitHub if piped via curl
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd)"
if [ ! -f "${SCRIPT_DIR}/config/.zshrc" ]; then
    echo -e "${CYAN}📥 Initializing bootstrap: Fetching Termux-Workbench assets from GitHub...${NC}"
    pkg update -y || apt-get update -y
    pkg install -y git || apt-get install -y git
    BOOTSTRAP_DIR="${HOME_DIR}/.termux-workbench-src"
    if [ -d "${BOOTSTRAP_DIR}" ]; then
        git -C "${BOOTSTRAP_DIR}" pull --quiet 2>/dev/null || true
    else
        git clone --depth 1 https://github.com/karansinghverma979/Termux-Workbench.git "${BOOTSTRAP_DIR}"
    fi
    SCRIPT_DIR="${BOOTSTRAP_DIR}"
fi

echo -e "${CYAN}📦 [1/8] Backing up existing configurations...${NC}"
mkdir -p "${BACKUP_DIR}"
[ -f "${HOME_DIR}/.zshrc" ] && cp -f "${HOME_DIR}/.zshrc" "${BACKUP_DIR}/"
[ -f "${HOME_DIR}/.tmux.conf" ] && cp -f "${HOME_DIR}/.tmux.conf" "${BACKUP_DIR}/"
[ -d "${HOME_DIR}/.termux" ] && cp -rf "${HOME_DIR}/.termux" "${BACKUP_DIR}/"
[ -d "${HOME_DIR}/.config" ] && cp -rf "${HOME_DIR}/.config" "${BACKUP_DIR}/"
echo -e "${GREEN}   Saved current configuration to: ${BACKUP_DIR}${NC}"

echo -e "${CYAN}📥 [2/8] Updating package repositories & provisioning full toolkit...${NC}"
pkg update -y || apt-get update -y
pkg install -y \
    zsh \
    starship \
    tmux \
    fzf \
    jq \
    zoxide \
    bat \
    nano \
    vim \
    openssh \
    netcat-openbsd \
    curl \
    wget \
    git \
    coreutils \
    findutils \
    tar \
    unzip \
    bzip2 \
    xz-utils \
    debianutils \
    file \
    mandoc \
    proot \
    python \
    python-pip \
    net-tools \
    iproute2 \
    htop \
    tree \
    nmap \
    lsof \
    dnsutils \
    termux-api \
    termux-tools \
    termux-services \
    fastfetch \
    ripgrep \
    fd \
    eza \
    gh \
    lazygit

if command -v su >/dev/null 2>&1 || [ "$(id -u)" -eq 0 ]; then
    echo -e "${GREEN}   Root environment detected. Enabling root-repo & wireless extensions...${NC}"
    pkg install -y root-repo wireless-tools || true
fi

echo -e "${CYAN}📱 [3/8] Configuring Termux storage & hardware APIs...${NC}"
# Setup shared storage access (~/storage)
if [ ! -d "${HOME_DIR}/storage" ]; then
    termux-setup-storage 2>/dev/null || true
fi

# Termux:API Verification
if timeout 1.5 termux-battery-status >/dev/null 2>&1; then
    echo -e "${GREEN}   Termux:API is connected and responsive.${NC}"
else
    echo -e "${YELLOW}   Notice: Ensure 'Termux:API' application is installed from F-Droid${NC}"
    echo -e "${YELLOW}   and set Android Battery to 'Unrestricted' for real-time telemetry.${NC}"
fi

echo -e "${CYAN}🔌 [4/8] Installing high-speed Zsh plugin suite...${NC}"
mkdir -p "${HOME_DIR}/.zsh"

clone_or_pull() {
    local repo_url="$1"
    local target_dir="$2"
    if [ -d "$target_dir" ]; then
        echo -e "${YELLOW}   Updating $(basename "$target_dir")...${NC}"
        git -C "$target_dir" pull --quiet 2>/dev/null || true
    else
        echo -e "${GREEN}   Cloning $(basename "$target_dir")...${NC}"
        git clone --depth 1 --quiet "$repo_url" "$target_dir"
    fi
}

clone_or_pull "https://github.com/Aloxaf/fzf-tab" "${HOME_DIR}/.zsh/fzf-tab"
clone_or_pull "https://github.com/zsh-users/zsh-autosuggestions" "${HOME_DIR}/.zsh/zsh-autosuggestions"
clone_or_pull "https://github.com/zdharma-continuum/fast-syntax-highlighting" "${HOME_DIR}/.zsh/fast-syntax-highlighting"
clone_or_pull "https://github.com/hlissner/zsh-autopair" "${HOME_DIR}/.zsh/zsh-autopair"
clone_or_pull "https://github.com/MichaelAquilina/zsh-you-should-use" "${HOME_DIR}/.zsh/zsh-you-should-use"
clone_or_pull "https://github.com/zsh-users/zsh-history-substring-search" "${HOME_DIR}/.zsh/zsh-history-substring-search"

echo -e "${CYAN}⚙️  [5/8] Deploying modular workbench architecture & configs...${NC}"
mkdir -p "${WORKBENCH_DIR}"
mkdir -p "${HOME_DIR}/.termux"
mkdir -p "${HOME_DIR}/.config"
mkdir -p "${HOME_DIR}/.local/bin"

# Deploy Modular Directories
[ -d "${SCRIPT_DIR}/bin" ] && cp -rf "${SCRIPT_DIR}/bin" "${WORKBENCH_DIR}/"
[ -d "${SCRIPT_DIR}/modules" ] && cp -rf "${SCRIPT_DIR}/modules" "${WORKBENCH_DIR}/"
[ -d "${SCRIPT_DIR}/profiles" ] && cp -rf "${SCRIPT_DIR}/profiles" "${WORKBENCH_DIR}/"
[ -d "${SCRIPT_DIR}/scripts" ] && cp -rf "${SCRIPT_DIR}/scripts" "${WORKBENCH_DIR}/"

# Install workbench CLI binary
if [ -f "${WORKBENCH_DIR}/bin/workbench" ]; then
    chmod +x "${WORKBENCH_DIR}/bin/workbench"
    cp -f "${WORKBENCH_DIR}/bin/workbench" "${HOME_DIR}/.local/bin/workbench"
    chmod +x "${HOME_DIR}/.local/bin/workbench"
fi

# Deploy active configs
cp -f "${SCRIPT_DIR}/config/termux.properties" "${HOME_DIR}/.termux/termux.properties"
cp -f "${SCRIPT_DIR}/config/.zshrc" "${HOME_DIR}/.zshrc"
cp -f "${SCRIPT_DIR}/config/.tmux.conf" "${HOME_DIR}/.tmux.conf"
cp -f "${SCRIPT_DIR}/config/starship.toml" "${HOME_DIR}/.config/starship.toml"
[ -f "${SCRIPT_DIR}/config/.nanorc" ] && cp -f "${SCRIPT_DIR}/config/.nanorc" "${HOME_DIR}/.nanorc"
mkdir -p "${HOME_DIR}/.nano_backups"
[ ! -f "${HOME_DIR}/.config/terminal_titles.json" ] && cp -f "${SCRIPT_DIR}/config/terminal_titles.json" "${HOME_DIR}/.config/terminal_titles.json"

# Universal Non-Interactive Environment (~/.zshenv)
cat << 'EOF' > "${HOME_DIR}/.zshenv"
export PATH="$HOME/.local/bin:$HOME/.termux-workbench/bin:$PREFIX/bin:$PATH"
export EDITOR="nano"
export VISUAL="nano"
EOF

# MOTD Suppression & Clean Startup
echo -e "${CYAN}🧹 Suppressing default MOTD splash banners...${NC}"
[ -f "/data/data/com.termux/files/usr/etc/motd" ] && mv -f "/data/data/com.termux/files/usr/etc/motd" "/data/data/com.termux/files/usr/etc/motd.bak" 2>/dev/null || true
[ -f "/data/data/com.termux/files/usr/etc/motd-playstore" ] && mv -f "/data/data/com.termux/files/usr/etc/motd-playstore" "/data/data/com.termux/files/usr/etc/motd-playstore.bak" 2>/dev/null || true
[ -f "/data/data/com.termux/files/usr/etc/motd.sh" ] && mv -f "/data/data/com.termux/files/usr/etc/motd.sh" "/data/data/com.termux/files/usr/etc/motd.sh.bak" 2>/dev/null || true
touch "${HOME_DIR}/.hushlogin"

echo -e "${CYAN}🔤 [6/8] Deploying Windows Terminal font (JetBrainsMono NF Bold)...${NC}"
mkdir -p "${HOME_DIR}/.termux/fonts"

# Deploy bundled fonts
if [ -d "${SCRIPT_DIR}/config/fonts" ]; then
    cp -rf "${SCRIPT_DIR}/config/fonts/"* "${HOME_DIR}/.termux/fonts/" 2>/dev/null || true
fi

# Set default font to JetBrainsMonoNF-Bold (matching Windows Terminal Bold standard)
if [ -f "${HOME_DIR}/.termux/fonts/JetBrainsMonoNF-Bold.ttf" ]; then
    cp -f "${HOME_DIR}/.termux/fonts/JetBrainsMonoNF-Bold.ttf" "${HOME_DIR}/.termux/font.ttf"
    echo "JetBrainsMonoNF-Bold" > "${HOME_DIR}/.termux_current_font.txt"
    echo -e "${GREEN}   De-facto Windows Terminal font deployed: JetBrainsMono NF Bold.${NC}"
elif [ ! -f "${HOME_DIR}/.termux/font.ttf" ]; then
    # Fallback to GitHub Release asset download
    echo -e "${CYAN}   Downloading JetBrains Mono Nerd Font standard...${NC}"
    curl -fsSL "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz" -o "${HOME_DIR}/.termux/fonts/JetBrainsMono.tar.xz" 2>/dev/null || true
    if [ -f "${HOME_DIR}/.termux/fonts/JetBrainsMono.tar.xz" ]; then
        tar -xf "${HOME_DIR}/.termux/fonts/JetBrainsMono.tar.xz" -C "${HOME_DIR}/.termux/fonts/" 2>/dev/null || true
        rm -f "${HOME_DIR}/.termux/fonts/JetBrainsMono.tar.xz"
        [ -f "${HOME_DIR}/.termux/fonts/JetBrainsMonoNerdFont-Bold.ttf" ] && cp -f "${HOME_DIR}/.termux/fonts/JetBrainsMonoNerdFont-Bold.ttf" "${HOME_DIR}/.termux/font.ttf"
        echo "JetBrainsMonoNF-Bold" > "${HOME_DIR}/.termux_current_font.txt"
    fi
fi

echo -e "${CYAN}🔑 [7/8] Automating SSH Keys, Workstation Pairing & SSHD Daemon...${NC}"
mkdir -p "${HOME_DIR}/.ssh"
chmod 700 "${HOME_DIR}/.ssh"

# Generate host keys if missing
if [ ! -f "/data/data/com.termux/files/usr/etc/ssh/ssh_host_ed25519_key" ]; then
    echo -e "${CYAN}   Generating OpenSSH host keys...${NC}"
    ssh-keygen -A 2>/dev/null || true
fi

# Motobook sovereign workstation authorized key
MOTOBOOK_PUBKEY="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPCNjdCpyt8IFlrtDnJNjZq6bWAMg6PUtfX/GYEaL3zF karan@Motobook"

# Merge authorized_keys from repo if present
if [ -f "${SCRIPT_DIR}/config/authorized_keys" ]; then
    while IFS= read -r key || [ -n "$key" ]; do
        [[ -z "$key" || "$key" =~ ^# ]] && continue
        if ! grep -qsF "$key" "${HOME_DIR}/.ssh/authorized_keys" 2>/dev/null; then
            echo "$key" >> "${HOME_DIR}/.ssh/authorized_keys"
        fi
    done < "${SCRIPT_DIR}/config/authorized_keys"
fi

# Ensure Motobook public key is explicitly authorized
if ! grep -qsF "$MOTOBOOK_PUBKEY" "${HOME_DIR}/.ssh/authorized_keys" 2>/dev/null; then
    echo "$MOTOBOOK_PUBKEY" >> "${HOME_DIR}/.ssh/authorized_keys"
fi
chmod 600 "${HOME_DIR}/.ssh/authorized_keys"
echo -e "${GREEN}   Workstation key authorized: Motobook (karan@Motobook)${NC}"

# Generate local client Ed25519 key if missing (for outbound connections to PC/GitHub)
if [ ! -f "${HOME_DIR}/.ssh/id_ed25519" ]; then
    DEVICE_MODEL=$(getprop ro.product.model 2>/dev/null || echo "blaze")
    DEVICE_MODEL_CLEAN=$(echo "$DEVICE_MODEL" | tr -d ' ' | tr '[:upper:]' '[:lower:]')
    echo -e "${CYAN}   Generating local client Ed25519 key (~/.ssh/id_ed25519)...${NC}"
    ssh-keygen -t ed25519 -N "" -f "${HOME_DIR}/.ssh/id_ed25519" -C "termux@${DEVICE_MODEL_CLEAN}" >/dev/null 2>&1
    chmod 600 "${HOME_DIR}/.ssh/id_ed25519"
    chmod 644 "${HOME_DIR}/.ssh/id_ed25519.pub"
    echo -e "${GREEN}   Generated Termux key: $(cat "${HOME_DIR}/.ssh/id_ed25519.pub")${NC}"
fi

# Deploy configured ~/.peer_pc.env for Motobook
cat << 'EOF' > "${HOME_DIR}/.peer_pc.env"
# =========================================================
# 💻 Termux-Workbench: Peer Workstation Environment
# =========================================================
DEVICE_NAME="Blaze"
PEER_PC_NAME="Motobook"
PEER_PC_USER="karan"
PEER_PC_PORT="22"
PEER_PC_IP_OVERRIDE=""
PEER_PC_PUBKEY="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPCNjdCpyt8IFlrtDnJNjZq6bWAMg6PUtfX/GYEaL3zF karan@Motobook"
EOF
chmod 600 "${HOME_DIR}/.peer_pc.env"
echo -e "${GREEN}   Configured peer environment: ~/.peer_pc.env${NC}"

# Engage Termux wake-lock to prevent CPU sleep during SSH sessions
if command -v termux-wake-lock >/dev/null 2>&1; then
    termux-wake-lock 2>/dev/null || true
    echo -e "${GREEN}   Acquired Termux CPU wake-lock.${NC}"
fi

# Auto-start SSH daemon on port 8022
if ! pgrep -x sshd >/dev/null 2>&1; then
    sshd
    echo -e "${GREEN}   Started OpenSSH daemon on port 8022.${NC}"
else
    echo -e "${GREEN}   OpenSSH daemon is already running on port 8022.${NC}"
fi

echo -e "${CYAN}🐚 [8/8] Setting default shell & reloading Termux UI...${NC}"
if [ "$SHELL" != "$(which zsh)" ]; then
    chsh -s zsh
fi

if command -v termux-reload-settings >/dev/null 2>&1; then
    termux-reload-settings
fi

# Discover network IP
PHONE_IP=$(ip route get 1.1.1.1 2>/dev/null | awk '{print $7}')
if [ -z "$PHONE_IP" ]; then
    PHONE_IP=$(ifconfig 2>/dev/null | grep -oE "inet [0-9.]+" | grep -v "127.0.0.1" | awk '{print $2}' | head -n1)
fi
[[ -z "$PHONE_IP" ]] && PHONE_IP="<phone-ip>"
TERMUX_USER=$(whoami)

echo -e "${GREEN}${BOLD}"
cat << 'EOF'
 ┌─────────────────────────────────────────────────────────────┐
 │       ✨ TERMUX-WORKBENCH SETUP COMPLETE & OPERATIONAL!     │
 └─────────────────────────────────────────────────────────────┘
EOF
echo -e "${NC}"
echo -e "${CYAN}📋 System Configuration Status:${NC}"
echo -e "  • ${BOLD}OpenSSH Daemon:${NC}   ${GREEN}Running on port 8022 (Wake-Lock Active)${NC}"
echo -e "  • ${BOLD}Workstation Auth:${NC} ${GREEN}Motobook key installed in ~/.ssh/authorized_keys${NC}"
echo -e "  • ${BOLD}Terminal Font:${NC}    ${CYAN}JetBrainsMono NF Bold (Windows Terminal 1:1)${NC}"
echo -e "  • ${BOLD}Touch Matrix:${NC}     ${YELLOW}2×7 Ergonomic Touch Keys (AMOLED Pure Black)${NC}"
echo -e "  • ${BOLD}Shell & Prompt:${NC}   ${MAGENTA}Zsh 5.9 + Starship Prompt (Zero p10k)${NC}\n"

echo -e "${CYAN}🔗 Connect instantly from Windows Terminal (Motobook):${NC}"
echo -e "   ${BOLD}${GREEN}ssh -p 8022 ${TERMUX_USER}@${PHONE_IP}${NC}"
echo -e "   ${YELLOW}(Or simply type 'blaze' in PowerShell!)${NC}\n"

echo -e "${CYAN}🚀 Control Center Commands:${NC}"
echo -e "   • Switch touch profile:  ${YELLOW}workbench profile [dev|vim|sysadmin]${NC}"
echo -e "   • Switch prompt theme:   ${YELLOW}workbench theme${NC} (or ${YELLOW}chship${NC})"
echo -e "   • Switch terminal font:  ${YELLOW}workbench font [name|reset]${NC}"
echo -e "   • SSH daemon & pairing:  ${YELLOW}workbench ssh${NC}"
echo -e "   • Connect to Motobook:   ${YELLOW}motobook${NC} (or ${YELLOW}peer${NC})"
echo -e "   • Package audit:         ${YELLOW}workbench pkg check${NC}"
echo -e "   • Runtime status:        ${YELLOW}workbench status${NC}\n"
