#!/data/data/com.termux/files/usr/bin/bash
# ==============================================================================
# 📦 Termux-Matrix Backup Utility
# ==============================================================================

set -e

BACKUP_DIR="${HOME}/backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
ARCHIVE="${BACKUP_DIR}/termux_matrix_backup_${TIMESTAMP}.tar.gz"

mkdir -p "${BACKUP_DIR}"

echo -e "\033[1;36m📦 Creating Termux-Matrix backup archive...\033[0m"

tar -czf "${ARCHIVE}" \
    -C "${HOME}" \
    .termux/termux.properties \
    .zshrc \
    .tmux.conf \
    .config/starship.toml \
    .config/terminal_titles.json \
    .peer_pc.env 2>/dev/null || true

echo -e "\033[1;32m✅ Backup successfully created:\033[0m ${ARCHIVE}"
echo -e "\033[0;33mSize:\033[0m $(du -h "${ARCHIVE}" | cut -f1)"
