# ⚡ Termux-Matrix: High-Velocity Mobile DevOps & Terminal Operating Matrix

[![Platform: Android](https://img.shields.io/badge/Platform-Android%20%7C%20Termux-00f0ff?style=for-the-badge&logo=android&logoColor=black)](https://termux.dev)
[![Shell: ZSH](https://img.shields.io/badge/Shell-Zsh%205.9-7928ca?style=for-the-badge&logo=gnu-bash&logoColor=white)](https://www.zsh.org/)
[![Prompt: Dual-Engine](https://img.shields.io/badge/Prompt-Starship%20%2F%20P10k-ff0080?style=for-the-badge&logo=starship&logoColor=white)](https://starship.rs)
[![Security: OpenSSF](https://img.shields.io/badge/Security-OpenSSF%20Hardened-48bb78?style=for-the-badge&logo=shield&logoColor=white)](./SECURITY.md)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge)](./LICENSE)

> **Transform standard Android Termux into an ergonomic, desktop-class mobile development workstation featuring a tactile 2×7 touch extra-keys matrix, live dual-engine prompt switchboard, dynamic tab title sentinel, and a zero-password peer workstation bridge.**

---

<p align="center">
  <img src="assets/screenshots/termux_matrix_hud.svg" alt="Termux-Matrix Terminal HUD &amp; Touch Key Surface" width="100%">
</p>

---

## Quickstart & Installation

Get a fully-configured, battle-tested terminal workstation on your Android phone in 1 command:

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/karansinghverma979/Termux-Matrix/main/install.sh)"
```

> [!TIP]
> **Safety First**: The installer automatically creates a timestamped backup of your existing `~/.termux/`, `~/.zshrc`, `~/.tmux.conf`, and `~/.config/` in `~/.termux_matrix_backup_<timestamp>/`. Nothing is overwritten without backup.

---

## 🏛️ The 4 Core Pillar Systems

<p align="center">
  <img src="assets/screenshots/termux_features_matrix.svg" alt="Termux-Matrix Capability Matrix" width="100%">
</p>

```
┌────────────────────────────────────────────────────────────────────────┐
│                   ⚡ THE TERMUX-MATRIX ARCHITECTURE                    │
├───────────────────┬───────────────────┬────────────────────────────────┤
│ 🎮 2×7 TOUCH GRID │ 🎨 DUAL PROMPT    │ 🏷️ TAB TITLE SENTINEL          │
│ Tactile Unicode   │ Live Switch:      │ Dynamic Context: ⚡ git, ⚡ vim│
│ Icons & 14 Swipe- │ Starship ◄► P10k  │ Sticky Tags: title -Name dev   │
│ Up Macro Popups   │ 12 Mobile Presets │ Error Sentinel: ❌ on failure  │
├───────────────────┴───────────────────┴────────────────────────────────┤
│ 💻 PEER WORKSTATION BRIDGE : Sub-second dynamic IP & hotspot discovery │
│ Zero-password Ed25519 pairing • 1-key reconnect: peer (or motobook)    │
└────────────────────────────────────────────────────────────────────────┘
```

---

### 1. 🎮 Ergonomic 2×7 Touch Extra Keys Matrix

Mobile software keyboards hide modifiers (`Ctrl`, `Alt`, `Tab`, `Esc`) behind clumsy sub-menus. **Termux-Matrix** embeds a dedicated 2-row × 7-column touch surface at the base of your screen:

```
┌─────────────┬─────────────┬─────────────┬─────────────┬─────────────┬─────────────┬─────────────┐
│  [ESC]      │  [ | ]      │  [ * ]      │  [ _ ]      │  [ : ]      │  [PGUP]     │  [PASTE]    │
│     ▲       │     ▲       │     ▲       │     ▲       │     ▲       │     ▲       │     ▲       │
│    🔁       │    🚀       │    ⏸️       │    ➖       │    🟰       │    🔼       │    ⌨️       │
│   (TAB)     │    ( / )    │   ( ' )     │    ( - )    │    ( = )    │    (UP)     │ (KEYBOARD)  │
├─────────────┼─────────────┼─────────────┼─────────────┼─────────────┼─────────────┼─────────────┤
│  [ $ ]      │  [$HOME/]   │  [$PREFIX/] │  [ || ]     │  [HOME]     │  [PGDN]     │  [END]      │
│     ▲       │     ▲       │     ▲       │     ▲       │     ▲       │     ▲       │     ▲       │
│   CTRL      │    🗂️       │    ALT      │    🏠       │    ◀️       │    🔽       │    ▶️       │
│             │  (DRAWER)   │             │   (&&)      │   (LEFT)    │   (DOWN)    │   (RIGHT)   │
└─────────────┴─────────────┴─────────────┴─────────────┴─────────────┴─────────────┴─────────────┘
```

* **Atomic Swipe-Up Popups**: Swipe up on `TAB` for `ESC`; swipe up on `KEYBOARD` for instantaneous clipboard `PASTE`; swipe up on `UP` for `Page Up`.
* **AMOLED True-Black UI**: Built with `use-black-ui = true` and `0px` margin padding to maximize vertical code canvas on OLED screens.
* **Hardware Session Shortcuts**: `Ctrl + T` (New Session), `Ctrl + 1` / `Ctrl + 2` (Previous/Next Session), `Ctrl + N` (Rename Session).
* 📖 *Read the complete breakdown in [docs/TOUCH_KEY_MATRIX.md](docs/TOUCH_KEY_MATRIX.md).*

---

### 2. 🎨 Dual-Engine Prompt Suite (Starship ◄► Powerlevel10k)

Switch between the two most powerful prompt engines without restarting your shell or editing dotfiles:

```bash
use-starship    # Instant switch to Starship
use-p10k        # Instant switch to Powerlevel10k
```

* **Interactive Fuzzy Theme Pickers**:
  * Run `chship` to launch a fuzzy `fzf` picker across **12 curated mobile themes** (`tokyo-night`, `catppuccin-powerline`, `gruvbox-rainbow`, `bracketed-segments`, `pure-preset`, `jetpack`, etc.).
  * Run `chp10k` to switch Powerlevel10k presets or trigger the configuration wizard.
* **Smart Theme Blacklisting Engine**:
  * Don't like a preset? Run `rmship` (or `rmp10k`) while it's active. The engine will permanently blacklist the preset in `~/.config/starship_disliked.txt` and immediately transition you to another sleek theme!

---

### 3. 🏷️ Workspace Tab Title Sentinel

Never lose track of what is running across your terminal tabs:

* **Sticky Workspace Titles**:
  ```bash
  title -Name dev          # Locks title to "🛠️ Dev"
  title -Name termux       # Locks title to "📲 Termux"
  title                    # Opens interactive FZF title picker
  title reset              # Returns to dynamic automatic tracking
  ```
* **Process-Aware Execution Tracking**: Automatically detects long-running commands and reflects them in the tab title (`⚡ git`, `⚡ nvim`, `⚡ cargo`, `⚡ python`).
* **Flicker-Free Micro-Filter**: Silently ignores instant shell commands (`ls`, `cd`, `cat`, `clear`) to eliminate title bar flickering.
* **Error Sentinel**: Automatically prefixes the tab title with `❌` when a command fails.

---

### 4. 💻 Federated Peer Workstation Bridge

Seamlessly pair your mobile phone with your desktop or laptop development workstation:

```bash
peer                     # Automatically discovers and SSHs into your PC
```

* **Dynamic Network Auto-Discovery**: Probes your mobile hotspot gateway, local Wi-Fi subnet, and cached clients in <200ms without hardcoded IP dependencies.
* **Zero-Password Ed25519 Trust**: Automatically asserts your desktop's public SSH key in `~/.ssh/authorized_keys` for friction-free remote terminal synchronization.
* **Connection Drop Recovery**: Automatically traps connection drops when switching networks and guides you back online.
* **Centered Boot Telemetry Radar**: Prints a clean, horizontally centered HUD on terminal launch displaying local device IP, SSH port status, and workstation reachability.

---

## 🛠️ Make It Your Own: Customization & Portability

Termux-Matrix is completely decoupled from machine-specific paths and user credentials:

| File | Purpose | Customization |
| :--- | :--- | :--- |
| [`~/.peer_pc.env`](config/peer_pc.env.example) | Workstation Credentials | Set your PC's IP, username, port, and public key. |
| [`~/.termux/termux.properties`](config/termux.properties) | Touch Extra Keys & UI | Change button icons, swipe-up macros, cursor blink, and colors. |
| [`~/.config/terminal_titles.json`](config/terminal_titles.json) | Tab Title Registry | Add or edit custom workspace tags (`title -Name <k> -Value <v>`). |
| [`~/.tmux.conf`](config/.tmux.conf) | Mobile Tmux Runtime | Touch mouse support, zero escape delay, vim navigation splits. |

👉 **Read the comprehensive guide**: [docs/CUSTOMIZATION.md](docs/CUSTOMIZATION.md)

---

## 📦 Multi-Pathway Installation & Matrix Management

### Pathway A: 1-Line Automated Installer (Recommended)
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/karansinghverma979/Termux-Matrix/main/install.sh)"
```

### Pathway B: Git Clone & Local Development
```bash
git clone https://github.com/karansinghverma979/Termux-Matrix.git ~/.termux-matrix
cd ~/.termux-matrix
./install.sh
```

### Pathway C: Backup & Disaster Recovery
```bash
./scripts/backup.sh              # Creates timestamped .tar.gz in ~/backups/
./scripts/restore.sh <file.tar.gz> # Restores configs and reloads shell
```

---

## 📜 Architectural Heritage & Evolution

**Termux-Matrix** is the direct successor to **Project Legacy (2020–2025)**:
* **The 2020–2025 Era (`Termux-Extra-Keys`)**: Born as a personal weaponized terminal environment for Karan Singh Verma before transitioning to heavy desktop hardware. It featured the original "Queen" / "Sarika" startup sequence, lolcat text formatting, and early extra-key mappings.
* **The Modern Era (`Termux-Matrix`)**: Evolved into a fully modular, decoupled, and automated mobile operating matrix. It introduces the dual Starship/P10k prompt engine, dynamic workspace tab sentinel, mobile tmux touch suite, and automated peer workstation bridge.
* Historical files are preserved in [`legacy/`](legacy/).

---

## 🔒 Security & Supply Chain Integrity
- **OpenSSF Hardening**: GitHub Actions workflows enforce `permissions: contents: read` with commit SHA pinning.
- **Path Portability**: Zero hardcoded workstation host paths. All host pairing uses dynamic environment variables (`~/.peer_pc.env`).
- **Coordinated Disclosure**: See [SECURITY.md](SECURITY.md).

---

## 📄 License
Released under the [MIT License](LICENSE). Maintained by [Karan Singh Verma](https://github.com/karansinghverma979).
