#!/data/data/com.termux/files/usr/bin/bash
# ==============================================================================
# ⚡ Termux-Matrix: High-Velocity Mobile DevOps & Terminal Operating Matrix
# 1-Line Automated Installer & Configuration Engine
# ==============================================================================

set -e

CYAN='\033[1;36m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
BOLD='\033[1m'
NC='\033[0m'

echo -e "${CYAN}${BOLD}"
cat << 'EOF'
 ┌─────────────────────────────────────────────────────────────┐
 │       ⚡ TERMUX-MATRIX : HIGH-VELOCITY MOBILE DEVOPS        │
 │     Ergonomic 2×7 Touch Layout • Dual Prompt • Peer Bridge  │
 └─────────────────────────────────────────────────────────────┘
EOF
echo -e "${NC}"

# 1. Environment Verification
if [ ! -d "/data/data/com.termux/files/home" ]; then
    echo -e "${RED}❌ Error: This installer must be executed inside Android Termux.${NC}"
    exit 1
fi

HOME_DIR="/data/data/com.termux/files/home"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="${HOME_DIR}/.termux_matrix_backup_$(date +%Y%m%d_%H%M%S)"

echo -e "${CYAN}📦 [1/6] Backing up existing configurations...${NC}"
mkdir -p "${BACKUP_DIR}"
[ -f "${HOME_DIR}/.zshrc" ] && cp -f "${HOME_DIR}/.zshrc" "${BACKUP_DIR}/"
[ -f "${HOME_DIR}/.tmux.conf" ] && cp -f "${HOME_DIR}/.tmux.conf" "${BACKUP_DIR}/"
[ -d "${HOME_DIR}/.termux" ] && cp -rf "${HOME_DIR}/.termux" "${BACKUP_DIR}/"
[ -d "${HOME_DIR}/.config" ] && cp -rf "${HOME_DIR}/.config" "${BACKUP_DIR}/"
echo -e "${GREEN}   Saved current configuration to: ${BACKUP_DIR}${NC}"

echo -e "${CYAN}📥 [2/6] Updating packages & installing core dependencies...${NC}"
pkg update -y
pkg install -y \
    zsh \
    starship \
    tmux \
    fzf \
    jq \
    zoxide \
    bat \
    openssh \
    netcat-openbsd \
    curl \
    git \
    coreutils

echo -e "${CYAN}🔌 [3/6] Installing high-speed Zsh plugin suite...${NC}"
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

echo -e "${CYAN}⚙️  [4/6] Deploying matrix configurations...${NC}"
mkdir -p "${HOME_DIR}/.termux"
mkdir -p "${HOME_DIR}/.config"

cp -f "${SCRIPT_DIR}/config/termux.properties" "${HOME_DIR}/.termux/termux.properties"
cp -f "${SCRIPT_DIR}/config/.zshrc" "${HOME_DIR}/.zshrc"
cp -f "${SCRIPT_DIR}/config/.tmux.conf" "${HOME_DIR}/.tmux.conf"
cp -f "${SCRIPT_DIR}/config/starship.toml" "${HOME_DIR}/.config/starship.toml"
[ ! -f "${HOME_DIR}/.config/terminal_titles.json" ] && cp -f "${SCRIPT_DIR}/config/terminal_titles.json" "${HOME_DIR}/.config/terminal_titles.json"
[ ! -f "${HOME_DIR}/.peer_pc.env" ] && cp -f "${SCRIPT_DIR}/config/peer_pc.env.example" "${HOME_DIR}/.peer_pc.env"

echo -e "${CYAN}🐚 [5/6] Setting default shell to Zsh...${NC}"
if [ "$SHELL" != "$(which zsh)" ]; then
    chsh -s zsh
fi

echo -e "${CYAN}🔄 [6/6] Reloading Termux UI settings...${NC}"
if command -v termux-reload-settings >/dev/null 2>&1; then
    termux-reload-settings
fi

echo -e "${GREEN}${BOLD}"
cat << 'EOF'
 ┌─────────────────────────────────────────────────────────────┐
 │       ✨ TERMUX-MATRIX SETUP COMPLETE & OPERATIONAL!         │
 └─────────────────────────────────────────────────────────────┘
EOF
echo -e "${NC}"
echo -e "${CYAN}🚀 Next Steps:${NC}"
echo -e "   1. Restart Termux or execute: ${YELLOW}exec zsh${NC}"
echo -e "   2. Customize your PC bridge in: ${YELLOW}~/.peer_pc.env${NC}"
echo -e "   3. Switch prompt themes anytime: ${YELLOW}chship${NC} or ${YELLOW}chp10k${NC}"
echo -e "   4. Switch terminal tab title: ${YELLOW}title${NC}\n"
