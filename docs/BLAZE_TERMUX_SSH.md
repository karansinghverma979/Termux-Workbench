# ⚡ Companion Integration: Blaze-Termux-SSH

[![Repository: Blaze-Termux-SSH](https://img.shields.io/badge/Companion%20Repo-Blaze--Termux--SSH-00f0ff?style=for-the-badge&logo=github&logoColor=black)](https://github.com/karansinghverma979/Blaze-Termux-SSH)
[![Device Pair: Motobook ⇄ Blaze](https://img.shields.io/badge/Device%20Pair-Motobook%20%E2%87%84%20Lava%20Blaze%205G-7928ca?style=for-the-badge&logo=android&logoColor=white)](https://github.com/karansinghverma979/Blaze-Termux-SSH)
[![Protocol: OpenSSH / ADB](https://img.shields.io/badge/Federation-Ed25519%20%7C%20Port%208022-ff0080?style=for-the-badge&logo=ssh&logoColor=white)](./ARCHITECTURE.md)

---

## 🏛️ Ecosystem Overview

**Termux-Workbench** is the **client runtime** operating inside Android Termux on the **Lava Blaze 5G** mobile node.

**[Blaze-Termux-SSH](https://github.com/karansinghverma979/Blaze-Termux-SSH)** is the **host orchestration system** operating on the **Motobook** (Windows 11 Pro) workstation. Together, they establish an edge-computing command federation bridging mobile Android telephony/sensors with desktop development workflows.

```
┌────────────────────────────────────────────────────────────────────────┐
│                   ⚡ DUAL-NODE AUTOMATION ARCHITECTURE                 │
├───────────────────────────────────┬────────────────────────────────────┤
│ 💻 HOST WORKSTATION (Motobook)    │ 📱 MOBILE NODE (Lava Blaze 5G)     │
│ OS: Windows 11 Pro                │ OS: Android 14 / Termux            │
│ Framework: Blaze-Termux-SSH       │ Framework: Termux-Workbench        │
│ SSH Inbound: Port 22              │ SSH Daemon: Port 8022 (sshd)       │
│ Profiles: blaze_profile.ps1       │ Shell: Zsh + Starship / P10k       │
├───────────────────────────────────┴────────────────────────────────────┤
│ 🔗 FEDERATION HIGHWAYS:                                                │
│ 1. Wireless ADB (Port 5555) ── Root Telemetry, Key Injection, Recovery │
│ 2. OpenSSH (Port 8022)      ── Ed25519 Zero-Password Mutual Tunnel     │
│ 3. Wi-Fi / Hotspot Subnet   ── Dynamic Zero-Config ARP/Gateway Ping    │
└────────────────────────────────────────────────────────────────────────┘
```

---

## 📡 The 10 Host Dispatch Channels (`blaze-*`)

From Motobook PowerShell, **Blaze-Termux-SSH** exposes 10 automated high-velocity control channels into the running **Termux-Workbench** environment:

| Host Command | Channel Name | Architectural Role & Termux Target |
| :--- | :--- | :--- |
| `blaze` | **Interactive Terminal** | Instant zero-password SSH shell into Termux (`ssh blaze`). |
| `blaze-status` | **Telemetry Dashboard** | Battery level, temperature, health, charging state, uptime, and memory via Termux:API. |
| `blaze-clip` | **Clipboard Engine** | Bi-directional synchronization between Windows clipboard and Android clipboard (`termux-clipboard-get` / `set`). |
| `blaze-location` | **Geospatial Radar** | GPS coordinates, accuracy, altitude, speed, and reverse Google Maps lookup (`termux-location`). |
| `blaze-phone` | **Telephony Hub** | Recent call log queries, unread SMS inspection, and CLI SMS dispatch (`termux-sms-list`, `termux-telephony-call`). |
| `blaze-notifs` | **Alert Sentinel** | Trigger Android status-bar notifications, sound alarms, and tactile vibrations (`termux-notification`, `termux-vibrate`). |
| `blaze-wifi` | **Network Topology** | Active Wi-Fi SSID, BSSID, RSSI signal strength, link speed, and channel scan (`termux-wifi-connectioninfo`). |
| `blaze-file` | **Fuzzy Transfer** | Bi-directional interactive file pushing/pulling between Motobook and Termux storage via `fzf` and `scp`. |
| `blaze-media` | **Screen & AV Bus** | Ultra-low latency screen mirroring via `scrcpy`, camera snaps, and audio recording. |
| `blaze-speak` | **Speech Synthesizer**| Mobile text-to-speech audio broadcast via phone speaker (`termux-tts-speak`). |

---

## 🔄 Reverse Traversal: The Mobile-to-PC Bridge (`peer`)

Inside **Termux-Workbench**, dynamic environment detection allows the phone to locate and SSH into Motobook automatically:

```bash
peer                # Dynamically locates Motobook IP and opens OpenSSH shell
motobook            # Alias to 'peer'
```

### Auto-Discovery Resolution Order:
1. **Last Client Cache**: Reads `~/.ssh_last_client` (updated automatically whenever Motobook connects to Blaze).
2. **Default Gateway**: Queries `ip route show default` to find the host hotspot or router IP.
3. **Static Override**: Reads `PEER_PC_IP_OVERRIDE` from `~/.peer_pc.env` if present.

---

## 🛡️ Security & Zero-Trust Invariants

1. **Ed25519 Key Quarantine**:
   - Motobook public key: `~/.ssh/authorized_keys` inside Termux with strict permissions (`chmod 700 ~/.ssh`, `chmod 600 ~/.ssh/authorized_keys`).
   - Host private keys are isolated strictly outside repository trees.
2. **Dynamic Resolution**:
   - Zero hardcoded local machine paths (`C:\Users\...` or absolute user paths). All scripts dynamically resolve paths via `$HOME` and `$PREFIX`.
3. **Safe Fallback**:
   - If Wi-Fi changes subnets, `find_peer_ip` handles dynamic network migration without manual config edits.

---

## 🔗 Associated Ecosystem Links

* **Host Orchestration Repository**: [karansinghverma979/Blaze-Termux-SSH](https://github.com/karansinghverma979/Blaze-Termux-SSH)
* **Mobile Runtime Repository**: [karansinghverma979/Termux-Workbench](https://github.com/karansinghverma979/Termux-Workbench)
* **Termux-Workbench Architecture Guide**: [ARCHITECTURE.md](./ARCHITECTURE.md)
* **Touch Key Matrix Guide**: [TOUCH_KEY_MATRIX.md](./TOUCH_KEY_MATRIX.md)
