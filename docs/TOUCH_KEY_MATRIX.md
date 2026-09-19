# 🎮 Ergonomic 2×7 Touch Key Matrix Specification

Standard virtual keyboards lack the essential modifier keys, terminal symbols, and directional navigation required for professional development. **Termux-Matrix** solves this through a dedicated, hardware-accelerated **2-Row × 7-Column Extra Keys Grid** embedded at the bottom of your screen.

---

## 📐 The 2×7 Interactive Layout Map

Each key features a **Primary Tap** and a high-velocity **Swipe-Up Popup Action**:

```
┌─────────────┬─────────────┬─────────────┬─────────────┬─────────────┬─────────────┬─────────────┐
│  [ESC]      │  [ | ]      │  [ * ]      │  [ _ ]      │  [ : ]      │  [PGUP]     │  [PASTE]    │
│     ▲       │     ▲       │     ▲       │     ▲       │     ▲       │     ▲       │     ▲       │
│     │       │     │       │     │       │     │       │     │       │     │       │     │       │
│    🔁       │    🚀       │    ⏸️       │    ➖       │    🟰       │    🔼       │    ⌨️       │
│   (TAB)     │    ( / )    │   ( ' )     │    ( - )    │    ( = )    │    (UP)     │ (KEYBOARD)  │
├─────────────┼─────────────┼─────────────┼─────────────┼─────────────┼─────────────┼─────────────┤
│  [ $ ]      │  [$HOME/]   │  [$PREFIX/] │  [ || ]     │  [HOME]     │  [PGDN]     │  [END]      │
│     ▲       │     ▲       │     ▲       │     ▲       │     ▲       │     ▲       │     ▲       │
│     │       │     │       │     │       │     │       │     │       │     │       │     │       │
│   CTRL      │    🗂️       │    ALT      │    🏠       │    ◀️       │    🔽       │    ▶️       │
│             │  (DRAWER)   │             │   (&&)      │   (LEFT)    │   (DOWN)    │   (RIGHT)   │
└─────────────┴─────────────┴─────────────┴─────────────┴─────────────┴─────────────┴─────────────┘
```

---

## 🔍 Detailed Key Functionality Matrix

### Row 1: Execution, Syntax & Terminal Control

| Visual Icon | Key Token | Tap Action | Swipe-Up (Popup) | Ergonomic Rationale |
| :---: | :---: | :--- | :--- | :--- |
| `🔁` | `TAB` | Autocomplete path / command | `ESC` | Instant exit from Vim/Nano or aborting prompt commands without reaching top screen. |
| `🚀` | `/` | Slash directory separator | `\|` (Pipe) | Piping stdout (`cmd1 \| cmd2`) without toggling symbol submenus on soft keyboard. |
| `⏸️` | `QUOTE` | Single quote (`'`) | `*` (Asterisk) | Shell wildcard expansion and string quoting in rapid succession. |
| `➖` | `-` | Hyphen flag delimiter (`-`) | `_` (Underscore) | Rapid typing of CLI flags (`--help`) and snake_case variable names. |
| `🟰` | `=` | Assignment operator (`=`) | `:` (Colon) | Variable declaration (`KEY=VAL`) and Vim command-mode initiation (`:`). |
| `🔼` | `UP` | Previous history line | `PGUP` (Page Up) | Smooth buffer and history traversal. |
| `⌨️` | `KEYBOARD` | Toggle soft keyboard visibility | `PASTE` | One-gesture Android clipboard injection directly into the active shell. |

---

### Row 2: Navigation, Environment & Modifiers

| Visual Icon | Key Token | Tap Action | Swipe-Up (Popup) | Ergonomic Rationale |
| :---: | :---: | :--- | :--- | :--- |
| `CTRL` | `CTRL` | Terminal Control modifier | `$` (Dollar) | Modifier latching for terminal signals (`Ctrl+C`, `Ctrl+Z`) plus fast variable access. |
| `🗂️` | `DRAWER` | Open Termux session drawer | `$HOME/` | Quick jump to user home directory path string. |
| `ALT` | `ALT` | Terminal Meta / Option modifier | `$PREFIX/` | Meta key combinations plus fast access to Termux package root (`/data/.../usr`). |
| `🏠` | `&&` | Logical AND chaining (`&&`) | `\|\|` (Logical OR) | Fast command orchestration (`make && make install`). |
| `◀️` | `LEFT` | Move cursor left by 1 character | `HOME` (Line Start) | Instant navigation to the beginning of lengthy shell commands. |
| `🔽` | `DOWN` | Next history line | `PGDN` (Page Down) | Downward scroll and prompt history navigation. |
| `▶️` | `RIGHT` | Move cursor right by 1 character | `END` (Line End) | Instant navigation to the tail of the current command buffer. |

---

## ⚡ Global Android Hardware & Session Hotkeys

These shortcuts are mapped directly into Termux via `shortcut.*` directives:

| Key Combination | Action | Description |
| :--- | :--- | :--- |
| `Ctrl + T` | **Create New Session** | Spawns a clean new terminal tab without opening the side drawer. |
| `Ctrl + 1` | **Previous Session** | Cycle backward through open terminal tabs. |
| `Ctrl + 2` | **Next Session** | Cycle forward through open terminal tabs. |
| `Ctrl + N` | **Rename Session** | Trigger interactive session rename dialog. |
| `Ctrl + Space` | **Keyboard Workaround** | Bypasses soft-keyboard IME input interception. |
