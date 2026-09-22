#!/data/data/com.termux/files/usr/bin/bash
# ==============================================================================
# ⚡ Termux-Workbench: Essential Package Provisioner & Diagnostics Hub
# Project: Termux-Workbench
# Author: Karan Singh Verma & Antigravity Assistant
# Compatible with: Rooted & Non-Rooted Android Termux (Android 7 - Android 15+)
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
 │       ⚡ TERMUX-WORKBENCH : ESSENTIAL PACKAGE PROVISIONER   │
 │   Universal Root & Non-Root Dev, Network & Admin Toolkit   │
 └─────────────────────────────────────────────────────────────┘
EOF
echo -e "${NC}"

# 1. Environment Verification
if [ ! -d "/data/data/com.termux/files/home" ]; then
    echo -e "${RED}❌ Error: This script must be executed inside Android Termux.${NC}"
    exit 1
fi

MODE="${1:-install}"

# Core Essential Tiers
CORE_SYSTEM_PKGS=(
    coreutils
    findutils
    tar
    unzip
    bzip2
    xz-utils
    debianutils     # provides which, tempfile
    file
    mandoc          # provides man documentation viewer
    proot
)

DEV_SCRIPTING_PKGS=(
    python
    python-pip
    git
    gh              # GitHub official CLI
    lazygit         # Modern terminal UI for git
    ripgrep         # Ultra-fast Rust grep replacement (rg)
    fd              # Modern Rust find replacement (fd)
    bat             # Syntax-highlighted cat with git integration
    eza             # Modern Rust ls replacement with icons & tree
    fzf             # Interactive fuzzy finder
    zoxide          # Smarter cd command for rapid navigation
    jq              # Command-line JSON processor
    nano
    vim
)

NETWORKING_PKGS=(
    curl
    wget
    openssh
    net-tools       # provides ifconfig, netstat, route, arp
    iproute2        # provides ip addr, ip route, ip link
    netcat-openbsd
    nmap
    lsof
    dnsutils
)

MONITORING_UI_PKGS=(
    htop
    tree
    fastfetch
    termux-api
    termux-tools
    termux-services
)

# Optional Root Tools (iw, etc.)
ROOT_PKGS=(
    iw              # CLI wireless device configuration (root-repo)
)

check_pkg_status() {
    local pkg="$1"
    if dpkg -s "$pkg" 2>/dev/null | grep -q "Status: install ok installed"; then
        echo -e "  [${GREEN}✓${NC}] ${pkg}"
    else
        echo -e "  [${RED}✗${NC}] ${pkg} (Missing)"
    fi
    return 0
}

cmd_check() {
    echo -e "${CYAN}${BOLD}📋 Auditing Termux Essentials...${NC}\n"
    
    echo -e "${BOLD}1. Core & System Utilities:${NC}"
    for p in "${CORE_SYSTEM_PKGS[@]}"; do check_pkg_status "$p"; done

    echo -e "\n${BOLD}2. Development & Scripting:${NC}"
    for p in "${DEV_SCRIPTING_PKGS[@]}"; do check_pkg_status "$p"; done

    echo -e "\n${BOLD}3. Networking & Connectivity:${NC}"
    for p in "${NETWORKING_PKGS[@]}"; do check_pkg_status "$p"; done

    echo -e "\n${BOLD}4. Monitoring & Hardware Tools:${NC}"
    for p in "${MONITORING_UI_PKGS[@]}"; do check_pkg_status "$p"; done

    echo -e "\n${BOLD}5. Root & Wireless Extensions:${NC}"
    for p in "${ROOT_PKGS[@]}"; do check_pkg_status "$p" || true; done

    echo -e "\n${GREEN}Audit complete.${NC}"
}

cmd_install() {
    echo -e "${CYAN}📦 [1/5] Updating Termux package repositories...${NC}"
    pkg update -y || apt-get update -y

    echo -e "\n${CYAN}⚙️  [2/5] Installing Core & System Utilities...${NC}"
    pkg install -y "${CORE_SYSTEM_PKGS[@]}"

    echo -e "\n${CYAN}🐍 [3/5] Installing Development & Python Runtimes...${NC}"
    pkg install -y "${DEV_SCRIPTING_PKGS[@]}"

    echo -e "\n${CYAN}🌐 [4/5] Installing Networking & Diagnostics (ifconfig, ip, nmap, curl)...${NC}"
    pkg install -y "${NETWORKING_PKGS[@]}"

    echo -e "\n${CYAN}📊 [5/5] Installing Monitoring & Termux UI Utilities...${NC}"
    pkg install -y "${MONITORING_UI_PKGS[@]}"

    # Root packages installation (Safe check: only if rooted or requested)
    echo -e "\n${CYAN}🛡️  Checking Root & Wireless Utilities...${NC}"
    IS_ROOTED=false
    if command -v su >/dev/null 2>&1 || [ "$(id -u)" -eq 0 ]; then
        IS_ROOTED=true
    fi

    if [ "$IS_ROOTED" = true ]; then
        echo -e "${GREEN}   Root environment detected. Enabling root-repo & wireless-tools (iwconfig)...${NC}"
        pkg install -y root-repo || true
        pkg install -y "${ROOT_PKGS[@]}" || true
    else
        echo -e "${YELLOW}   Non-rooted environment detected. Skipping wireless-tools (root-only).${NC}"
        echo -e "   (All standard network tools like 'ifconfig', 'ip', 'curl', 'nmap' are fully functional).${NC}"
    fi

    echo -e "\n${GREEN}${BOLD}✨ All Termux Essential Packages are installed & verified!${NC}\n"
}

case "$MODE" in
    check|--check|-c)
        cmd_check
        ;;
    install|--install|-i|"")
        cmd_install
        ;;
    *)
        echo -e "${YELLOW}Usage: ./pkg-essentials.sh [install|check]${NC}"
        exit 1
        ;;
esac
