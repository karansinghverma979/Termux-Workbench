# 📱 TERMUX OPERATOR CONFIG: PROJECT LEGACY (2020-2025)

![Platform](https://img.shields.io/badge/PLATFORM-ANDROID%20%2F%20TERMUX-green)
![Status](https://img.shields.io/badge/STATUS-BATTLE%20TESTED-blue)
![Legacy](https://img.shields.io/badge/TIMELINE-AUG%202020%20--%20JULY%202025-orange)

> **"Empty Your Mind. Be Formless, Be Shapeless, Be Fearless."**
> — *System Startup Protocol (Queen)*

---

## 1. THE ORIGIN STORY
This repository houses the **Master Configuration** used by **Karan Singh Verma** for 5 years on mobile architecture. Before the shift to Heavy PC Hardware in 2025, this environment turned a standard Android device into a weaponized development terminal.

It is optimized for **speed**, **touch-typing efficiency**, and **AI integration** on limited screen real estate.

---

## 2. TACTICAL INTERFACE (`termux.properties`)

The core of this build is the **2-Row Extra Keys Layout**. Standard keyboards are insufficient for coding; this layout brings desktop-class control to glass screens.

### **Key Features:**
* **The "Sarika" Row:** Custom macros for navigation and execution.
* **Visual Feedback:** Keys display icons (▶️, 🏠, ⏸️) but execute raw code.
* **Popup Logic:**
    * **Swipe Up on `TAB`** → Triggers `ESC` (Rapid exit).
    * **Swipe Up on `KEYBOARD`** → Triggers `PASTE` (Clipboard injection).
    * **Swipe Up on `DRAWER`** → Jumps to `$HOME`.

**Configuration Snippet:**
```properties
extra-keys = [ \
  [ \
    { key: TAB, display: "🔁", popup: { key: ESC } }, \
    { key: QUOTE, display:"⏸️" , popup: "*" }, \
    { key: UP, display: "🔼", popup: { key:COPY } } \
  ], \
  [ \
    { key: CTRL, popup: { key:"$"}}, \
    { key: "$SAHO/" , display:"🏠" , popup: "&&" } \
  ] \
]
```

---

## 3. THE NEURAL CORE (`.zshrc`)

The shell is built on **ZSH** with the **Mira/Agnoster** theme. It is not passive; it greets the user.

### **Startup Protocol: "Queen"**

Every time the terminal launches, the `queen` function executes:

1. **Identity:** Prints "SARIKA" in ASCII art (ansi_shadow).
2. **Philosophy:** Prints the "Be Fearless" mantra.
3. **AI Daemon:** Automatically checks if **Ollama** is running. If not, it launches a background `tmux` session for local AI inference.

### **Custom Functions & Aliases:**

| Command | Action |
| --- | --- |
| `fate "text"` | Centers text and applies `lolcat` gradient (Rainbow output). |
| `Note` / `Note2` | Launches Python-based quick note systems. |
| `chcolor` / `chfont` | Rapid switching of Termux fonts and color schemes. |
| `$SAHO` | Variable pointing to the secure storage vault. |

---

## 4. DEPLOYMENT INSTRUCTIONS

If you are setting up a new Termux environment and want to inherit this system:

**1. Backup your existing config:**

```bash
cp ~/.termux/termux.properties ~/.termux/termux.properties.bak
cp ~/.zshrc ~/.zshrc.bak
```

**2. Inject the Legacy files:**
*(Assuming you cloned this repo)*

```bash
cp termux.properties ~/.termux/
cp zshrc ~/.zshrc
```

**3. Reload the Matrix:**

```bash
termux-reload-settings
source ~/.zshrc
```

---

## 5. SYSTEM REQUIREMENTS

* **App:** Termux (F-Droid version recommended)
* **Shell:** ZSH + Oh-My-Zsh
* **Packages:** `python3`, `tmux`, `lolcat`, `figlet`, `ollama` (optional for AI features).

---

*Maintained by Karan Singh Verma.*
*Archives of the Mobile Era.*
