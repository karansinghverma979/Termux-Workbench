# 📓 Changelog & Evolution Heritage

All notable changes to **Termux-Workbench** are documented in this file.
This project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html) and follows the [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) standard.

---

## [2.2.0] - 2026-09-22 (Turnkey Installer & Font Parity)

### Added
- **Turnkey Unattended Bootstrap (`install.sh`)**:
  - Self-cloning pipe-bootstrap: Enables true 1-command fresh Termux installation via `curl | bash` with automatic repo staging.
  - Automated SSH key federation: Pre-authorizes Motobook workstation key in `~/.ssh/authorized_keys`, generates local Termux client Ed25519 key, starts `sshd` on port 8022, and acquires CPU `termux-wake-lock`.
  - Automated storage permission request (`termux-setup-storage`) and Termux:API telemetry health check.
- **JetBrains Mono Bold Font Parity**:
  - Standardized default terminal font to **JetBrainsMono NF Bold** across both Windows Terminal and Android Termux (`JetBrainsMonoNF-Bold.ttf`).
  - Bundled font assets in `config/fonts/` for offline and immediate deployment without network 404 risk.
  - Automatic `no-nerd-font` preset fallback if font is reset or running headless.
- **New CLI Subcommands**:
  - `workbench ssh`: Live SSH daemon status, IP discovery, active sessions, and pairing diagnostics.
  - `workbench pkg [install|check]`: Comprehensive package audit and installer for 32+ essential tools (`fastfetch`, `eza`, `ripgrep`, `fd`, `lazygit`, `gh`, `termux-api`).
- **Universal Mobile Nano Configuration**:
  - Enforced `export EDITOR="nano"` and `export VISUAL="nano"` across `.zshrc` and `00-core.zsh`.
  - Deployed mobile-hardened `.nanorc` with touch scrolling, line numbers, AMOLED colors, and isolated `~/.nano_backups`.

---

## [2.1.0] - 2026-09-22 (Sovereign Starship Standardization)

### Changed
- **Sovereign Prompt Standard**: Completely eradicated Powerlevel10k (`p10k`) and background daemon overhead (`gitstatusd`). Standardized 100% on **Starship** across both Android Termux and Motobook Windows.
- **Architectural Cleanup**: Removed `~/.powerlevel10k`, `~/.p10k.zsh`, dual-engine state toggles (`.prompt_engine`), and p10k switching aliases (`chp10k`, `rmp10k`, `use-p10k`).
- **Streamlined Prompt Management**: Refactored `30-prompts.zsh` and `workbench theme` into a pure Starship preset selector (`chship`) and blacklist governor (`rmship`).

## [2.0.0] - 2026-09-20 (The Modern Workbench)

### Changed
- **Repository Rebrand**: Evolved from legacy `Termux-Extra-Keys` to **`Termux-Workbench`**.
- **Dual-Engine Prompt Switchboard**:
  - Replaced legacy Oh-My-Zsh theme engine with a live dual-engine architecture (**Starship** ◄► **Powerlevel10k**).
  - Added `chship` and `chp10k` fuzzy FZF theme selectors.
  - Added `rmship` and `rmp10k` smart blacklist governors to permanently exclude unwanted presets.
- **Ergonomic 2×7 Touch Grid**:
  - Overhauled touch extra-keys with tactile Unicode icons (`🔁`, `🚀`, `⏸️`, `➖`, `🟰`, `🔼`, `⌨️`, `🗂️`, `🏠`, `◀️`, `🔽`, `▶️`).
  - Added 14 high-velocity swipe-up popup macros (`ESC`, pipes, asterisks, clipboard paste, `$HOME/`, `$PREFIX/`).
  - Maximized visual canvas on OLED screens via AMOLED true-black UI (`use-black-ui = true`) and zero margin padding.
- **Dynamic Tab Title Sentinel**:
  - Added sticky workspace tagging (`title -Name dev`).
  - Injected process-aware execution tracking (`⚡ git`, `⚡ nvim`) with micro-command flicker filtering.
  - Injected error sentinel (`❌` on non-zero exit codes).
- **Federated Peer Workstation Bridge**:
  - Built dynamic gateway and hotspot IP discovery (<200ms).
  - Added zero-password Ed25519 pairing and 1-key reconnect (`peer` / `motobook`).
- **Mobile Tmux Runtime**:
  - Added dual prefix (`Ctrl+B` and `Ctrl+A`), touch mouse scrolling, zero escape delay, and minimal status bar.

### Security
- **OpenSSF Hardening**: Workflow permissions set to `permissions: contents: read`; third-party GitHub Actions pinned to immutable 40-character commit SHAs.
- **Path Portability**: Decoupled machine paths and private workstation credentials into `~/.peer_pc.env`.

---

## [1.0.0] - 2020-08-01 to 2025-07-31 (Project Legacy)

### Added
- Original mobile development configuration for Android Termux created by **Karan Singh Verma**.
- Shell foundation built on Oh-My-Zsh with `mira` and `agnoster` themes.
- **System Startup Protocol ("Queen")**:
  - ASCII art greeting "SARIKA" rendered with `figlet -f ansi_shadow` and `lolcat`.
  - "Empty Your Mind. Be Formless, Be Shapeless, Be Fearless" startup mantra.
  - Automatic background `tmux` daemon supervisor for local **Ollama** AI inference.
- Initial 2-row extra keys configuration with early popup macros.
- Early Python utilities (`note.py`, `note2.py`) and font/color switchers (`colors.sh`, `fonts.sh`).
- Preserved for historical provenance in [`legacy/`](legacy/).
