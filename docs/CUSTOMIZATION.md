# 🛠️ Termux-Matrix Customization & Personalization Guide

This guide walks you through customizing every layer of **Termux-Matrix** so you can adapt it to your workflow, hardware, and external workstation.

---

## 📑 Table of Contents
1. [Customizing the 2×7 Touch Extra Keys](#1-customizing-the-27-touch-extra-keys)
2. [Pairing Termux with Your Personal Workstation (PC Bridge)](#2-pairing-termux-with-your-personal-workstation-pc-bridge)
3. [Managing Prompt Themes & Engines (Starship vs P10k)](#3-managing-prompt-themes--engines-starship-vs-p10k)
4. [Customizing Workspace Tab Titles](#4-customizing-workspace-tab-titles)
5. [Tmux Configuration & Statusline Tuning](#5-tmux-configuration--statusline-tuning)
6. [Managing Fonts & Color Schemes](#6-managing-fonts--color-schemes)

---

## 1. Customizing the 2×7 Touch Extra Keys

The touch extra keys live in `~/.termux/termux.properties`.

### Changing Key Labels & Icons
To change any button's icon or character, edit `display`:
```properties
{ key: TAB, display: "⇥", popup: { key: ESC } }
```

### Changing Swipe-Up Popup Actions
Every key button supports a `popup` parameter that fires when you swipe up on the key:
* **Direct Symbol Popup**:
  ```properties
  { key: '/', popup: '|' }
  ```
* **Special Key Token**:
  ```properties
  { key: UP, display: "🔼", popup: { key: PGUP } }
  ```
* **Macro (String Sequence)**:
  ```properties
  { key: ESC, popup: { macro: ":wq\n", display: "SaveExit" } }
  ```

### Applying Changes
Whenever you edit `~/.termux/termux.properties`, reload the UI:
```bash
termux-reload-settings
```

---

## 2. Pairing Termux with Your Personal Workstation (PC Bridge)

Termux-Matrix includes an automatic discovery and 1-key SSH bridge to connect your phone to your primary development computer.

### Step 1: Create Your Private Environment File
Copy the provided template to `~/.peer_pc.env`:
```bash
cp config/peer_pc.env.example ~/.peer_pc.env
chmod 600 ~/.peer_pc.env
```

### Step 2: Configure Your Workstation Parameters
Edit `~/.peer_pc.env` with your preferred editor (`nano ~/.peer_pc.env`):
```bash
# Display names shown in the boot telemetry radar
DEVICE_NAME="Pixel-8"
PEER_PC_NAME="MacBook-Pro"

# SSH connection details for your workstation
PEER_PC_USER="alex"
PEER_PC_PORT="22"

# Optional fallback IP (e.g. if Wi-Fi subnet discovery is slow)
PEER_PC_IP_OVERRIDE="192.168.1.150"

# Public key from your workstation (~/.ssh/id_ed25519.pub on your PC)
# When provided, Termux will automatically trust this key for zero-password logins!
PEER_PC_PUBKEY="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI... alex@MacBook-Pro"
```

### Step 3: Connect
Once configured, simply type:
```bash
peer
```
(Or use the alias `motobook` if migrating from legacy setups).

---

## 3. Managing Prompt Themes & Engines (Starship vs P10k)

Termux-Matrix features a **Dual-Engine Architecture** that lets you switch between **Starship** and **Powerlevel10k** in real-time.

### Switching Prompt Engines
* Switch to **Starship**:
  ```bash
  use-starship
  ```
* Switch to **Powerlevel10k**:
  ```bash
  use-p10k
  ```

### Switching Themes Interactively
* **Starship Presets**: Run `chship` without arguments to open an interactive fuzzy picker (FZF) featuring 12 curated mobile presets:
  ```bash
  chship
  # Or choose directly:
  chship tokyo-night
  chship gruvbox-rainbow
  chship catppuccin-powerline
  ```
* **Powerlevel10k Themes**:
  ```bash
  chp10k
  # Or configure interactively:
  chp10k wizard
  ```

### The Blacklist Feature
If you encounter a preset you dislike, blacklist it permanently so it never appears in your rotation again:
```bash
rmship    # Blacklists the active Starship theme
rmp10k    # Blacklists the active P10k theme
```
Blacklisted themes are saved in `~/.config/starship_disliked.txt` and `~/.p10k_disliked.txt`. To clear the blacklist, simply delete those files.

---

## 4. Customizing Workspace Tab Titles

Termux-Matrix includes an intelligent Tab Title engine with sticky manual overrides and automatic process tracking.

### Interactive Picker
Run `title` without arguments to open a fuzzy picker:
```bash
title
```

### Adding New Title Presets
Add custom persistent presets to `~/.config/terminal_titles.json` directly from the shell:
```bash
title -Name python -Value "🐍 Python"
title -Name docker -Value "🐳 Containers"
title -Name git -Value "🐙 Git Ops"
```

### Deleting Presets
```bash
title -Name docker -Delete
```

### Resetting to Dynamic Default
```bash
title reset
```

---

## 5. Tmux Configuration & Statusline Tuning

The tmux configuration is optimized for touchscreens and lives in `~/.tmux.conf`.

### Key Adjustments
* **Dual Prefix**: You can use either `Ctrl + B` or `Ctrl + A` as the command prefix.
* **Touch Mouse Scrolling**: Enabled by default (`set -g mouse on`). Tap any pane to focus, drag borders to resize, and swipe up to scroll back.
* **Statusline Accent**: Edit lines 33–36 in `~/.tmux.conf` to change the background color of the active session badge:
  ```tmux
  set -g status-left "#[fg=black,bg=magenta,bold] 📱 #S #[default] "
  ```
* **Reload Tmux**:
  ```bash
  tmux source-file ~/.tmux.conf
  ```

---

## 6. Managing Fonts & Color Schemes

* **Colors**: Place any custom Termux colors file in `~/.termux/colors.properties` and run `termux-reload-settings`.
* **Fonts**: Place your favorite Powerline/Nerd Font TTF file in `~/.termux/font.ttf` and run `termux-reload-settings`.
