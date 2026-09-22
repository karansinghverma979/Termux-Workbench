# 🗂️ Profiles & Modular Architecture Guide

**Termux-Workbench** is designed for continuous evolution. Instead of locking you into a single rigid configuration file, it uses a **Profile Engine** and a **Modular Module System**.

---

## 🏛️ The Core Architectural Challenge Solved

> *"Previously we built tools based on Oh-My-Zsh, then switched to Starship. Over time we upgrade, add new styling, and build new tools. Most of the time we have multiple types of layouts and workflows."*

The traditional approach of stuffing everything into a single monolithic `.zshrc` or `termux.properties` breaks down when:
1. You want different touch keys for different tasks (e.g., coding in Vim vs managing remote servers via SSH vs quick Python scripts).
2. You want to test a new shell tool without risking your working environment.
3. You want to share the repo publicly while maintaining multiple customized setups for yourself.

---

## 🎮 The Swappable Profile Engine

Profiles live in the [`profiles/`](../profiles/) directory. Each profile contains its own specialized `termux.properties` layout:

```
profiles/
├── dev/                 # Standard 2×7 Touch Grid (Tactile Unicode icons, clipboard, drawer)
│   └── termux.properties
├── vim/                 # Modal Editing Grid (:w, :wq, Esc, search, hjkl navigation)
│   └── termux.properties
└── sysadmin/            # Remote Server Grid (Sudo, pipes, SSH, background signals)
    └── termux.properties
```

### Switching Profiles
Use the built-in `workbench` CLI:
```bash
# Interactive fuzzy picker (FZF)
workbench profile

# Switch directly
workbench profile vim
workbench profile dev
workbench profile sysadmin
```
The engine copies the selected profile's `termux.properties` into `~/.termux/` and immediately calls `termux-reload-settings`.

---

## 🛠️ Creating Your Own Profile in 3 Steps

Want to create a custom layout for Python data science, Obsidian note-taking, or custom gaming/emulation?

### Step 1: Create Profile Directory
```bash
mkdir -p ~/.termux-workbench/profiles/my-profile
```

### Step 2: Add Your `termux.properties`
Create `~/.termux-workbench/profiles/my-profile/termux.properties` with your custom extra-keys grid:
```properties
extra-keys = [ \
  [ \
    { key: ESC, popup: { macro: ":q!\n", display: "Quit" } }, \
    { macro: "python3 ", display: "PY" }, \
    { macro: "git status\n", display: "STATUS" } \
  ] \
]
```

### Step 3: Activate It!
```bash
workbench profile my-profile
```
That's it! Your profile is instantly recognized by the `workbench` CLI and fuzzy switcher.

---

## 🧩 The Modular Shell System (`modules/`)

Rather than hacking your main `~/.zshrc`, all custom commands, functions, and tool integrations are structured into modular drop-in scripts:

```
~/.termux-workbench/modules/
├── 00-core.zsh          # Shell history, completions, and environment exports
├── 10-telemetry.zsh     # Centered boot telemetry radar and SSH supervision
├── 20-titles.zsh        # Sticky workspace tab titles and process-aware tracking
├── 30-prompts.zsh       # Starship preset switchboard
├── 40-tmux.zsh          # Session control suite and auto-attach
├── 50-peer-bridge.zsh   # Dynamic workstation auto-discovery and Ed25519 pairing
└── 60-aliases.zsh       # Personal shorthand and productivity aliases
```

### Adding a New Tool or Integration
When you create a new automation or tool (e.g., an Ollama AI daemon or an Obsidian vault sync script):
1. Drop a new file: `modules/70-obsidian-sync.zsh`
2. Add your functions and aliases.
3. Reload your shell: `exec zsh`

Your new tool is immediately live without touching core files!

---

## 🔄 Updating & Maintaining Your Workbench

When new profiles, themes, or modules are committed to the repository:
```bash
workbench update
```
This automatically pulls the latest changes from GitHub, preserves your active profile, and reloads your terminal settings seamlessly.
