#!/data/data/com.termux/files/usr/bin/bash
# ==============================================================================
# 🔄 Termux-Matrix Restore Utility
# ==============================================================================

set -e

ARCHIVE="$1"

if [ -z "$ARCHIVE" ] || [ ! -f "$ARCHIVE" ]; then
    echo -e "\033[1;31m❌ Usage: $0 <path-to-backup.tar.gz>\033[0m"
    echo -e "\033[0;33mAvailable backups in ~/backups/:\033[0m"
    ls -lh "${HOME}/backups/"*.tar.gz 2>/dev/null || echo "No backups found."
    exit 1
fi

echo -e "\033[1;36m🔄 Restoring Termux-Matrix configuration from: ${ARCHIVE}...\033[0m"
tar -xzf "${ARCHIVE}" -C "${HOME}"

if command -v termux-reload-settings >/dev/null 2>&1; then
    termux-reload-settings
fi

echo -e "\033[1;32m✅ Restore complete! Reloading shell...\033[0m"
exec zsh
