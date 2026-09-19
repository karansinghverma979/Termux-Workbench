# 🏛️ Termux-Matrix Architecture & Internal Systems

**Termux-Matrix** turns Android Termux into a high-performance terminal workstation optimized for mobile touch ergonomics, sub-50ms execution speed, and peer workstation federation.

---

## 🏗️ System Architecture Topology

```
┌────────────────────────────────────────────────────────────────────────┐
│                        ANDROID MOBILE HARDWARE                         │
│   Touchscreen Digits • Battery Governor • Network Interface (Wi-Fi)   │
└───────────────────────────────────┬────────────────────────────────────┘
                                    │
                                    ▼
┌────────────────────────────────────────────────────────────────────────┐
│                        TERMUX NATIVE RUNTIME                           │
│   AMOLED Black Surface • 5000-Row Buffer • Zero Margin Geometry       │
│                                                                        │
│   ┌────────────────────────────────────────────────────────────────┐   │
│   │           Ergonomic 2×7 Hardware Extra Keys Driver             │   │
│   │  [TAB]  [ / ]  [ ' ]  [ - ]  [ = ]  [UP]  [KEYBOARD]           │   │
│   │  [CTRL] [DIR]  [ALT]  [&&]   [LFT]  [DWN] [RIGHT]              │   │
│   └────────────────────────────────┬───────────────────────────────┘   │
└────────────────────────────────────┼───────────────────────────────────┘
                                     │
                                     ▼
┌────────────────────────────────────────────────────────────────────────┐
│                           ZSH SHELL RUNTIME                            │
│                                                                        │
│  ┌───────────────────────┐ ┌──────────────────────┐ ┌──────────────┐   │
│  │ Boot Telemetry Radar  │ │  Tab Title Sentinel  │ │ Plugin Suite │   │
│  │ (IP, SSH, Peer Status)│ │  (precmd / preexec)  │ │ (fzf, zoxide)│   │
│  └───────────────────────┘ └──────────────────────┘ └──────────────┘   │
│                                                                        │
│  ┌──────────────────────────────────────────────────────────────────┐  │
│  │                Dual Prompt Engine Switchboard                    │  │
│  │         Starship (12 Presets)  ◄──►  Powerlevel10k               │  │
│  └──────────────────────────────────────────────────────────────────┘  │
└────────────────────────────────────┬───────────────────────────────────┘
                                     │
                                     ▼
┌────────────────────────────────────────────────────────────────────────┐
│                      PEER WORKSTATION FEDERATION                       │
│    Dynamic Hotspot IP Discovery • Port 22/8022 • Ed25519 Key Trust     │
└────────────────────────────────────────────────────────────────────────┘
```

---

## ⚡ Core Subsystem Specifications

### 1. Boot Telemetry & Sentinel Engine (`show_boot_telemetry`)
* **Dynamic Horizontal Centering**: Uses terminal column geometry (`$COLUMNS` / `tput cols`) to center a clean HUD box in portrait or landscape orientations.
* **Auto-Supervision**: Verifies `sshd` is running on port 8022 and automatically asserts `termux-wake-lock` to prevent Android OS process hibernation.
* **Peer Probing**: Uses non-blocking `nc -z -w 1` TCP probes against the local gateway and subnet to instantly verify workstation availability without shell hangs.

### 2. Tab Title Sentinel (`precmd_title` & `preexec_title`)
* **Flicker-Free Micro-Command Filter**: Bypasses title updates for instant commands (`cd`, `ls`, `cat`, `clear`, `pwd`) to eliminate visual title flicker during fast navigation.
* **Sticky Mode Immunity**: When a user sets a manual title via `title <name>`, the title is frozen and ignores process execution events until explicitly reset.
* **Failure Sentinel**: Displays a red cross `❌` prefix whenever the preceding command exits with a non-zero status code.

### 3. Dual Prompt Engine
* **State Persistence**: Active prompt preference is saved in `~/.prompt_engine` (`starship` or `p10k`).
* **Preset Blacklisting**: Disliked themes are recorded in `~/.config/starship_disliked.txt` or `~/.p10k_disliked.txt` and dynamically excluded from the FZF theme rotation array.

### 4. Touch Matrix Driver
* Handled natively by Termux's Java layer reading `~/.termux/termux.properties`.
* All swipe-up events execute as atomic token emissions or macros without interfering with OS navigation gestures.
