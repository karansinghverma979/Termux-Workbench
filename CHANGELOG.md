# 📓 Changelog & Evolution Heritage

All notable changes to **Termux-Workbench** are documented in this file.
This project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html) and follows the [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) standard.

---

## [2.1.0] - 2026-09-20 (The Modular Era)

### Added
- **Modular Shell Architecture (`modules/`)**: Decoupled monolithic `.zshrc` into isolated, drop-in modules (`00-core`, `10-telemetry`, `20-titles`, `30-prompts`, `40-tmux`, `50-peer-bridge`, `60-aliases`).
- **Swappable Profile Engine (`profiles/`)**:
  - `dev`: Standard fullstack mobile development with tactile Unicode icons.
  - `vim`: Modal text editing layout featuring `:w`, `:wq`, `ESC`, and directionals.
  - `sysadmin`: Remote administration layout featuring SSH, pipes, modifiers, and system signals.
- **Unified `workbench` CLI**:
  - `workbench status`: Displays active profile, theme, and peer workstation telemetry.
  - `workbench profile <name>`: Instantly swaps touch extra-keys layout and reloads settings.
  - `workbench update`: Pulls upstream changes from GitHub and triggers atomic reload.
  - `workbench backup` / `workbench restore`: Built-in snapshot and rollback manager.
- **Documentation**: Added [`docs/PROFILES.md`](docs/PROFILES.md) detailing the profile engine and workflow customization.

---

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
