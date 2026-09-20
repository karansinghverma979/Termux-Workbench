# ⚡ Termux-Workbench Workspace Rules & Invariants

> **Project**: Termux-Workbench (High-Velocity Mobile DevOps & Terminal Workstation)  
> **Environment**: Android Termux / ZSH / POSIX Shell  
> **Author**: Karan Singh Verma

---

## 🏛️ Core Principles & Invariants

### 1. 🧱 CRLF / LF Line-Ending Firewall (MANDATORY)
- **Strict LF Line Endings**: All shell scripts (`*.sh`, `*.zsh`), dotfiles, and config templates MUST use Unix LF (`\n`) line endings exclusively.
- **Gitattributes Enforcement**: Enforce `text eol=lf` across all shell and configuration files. Never commit CRLF line endings to prevent `$'\r': command not found` interpreter crashes on Android/Linux.

### 2. 📱 Non-Root & POSIX Architecture
- **Termux Prefix Portability**: Never assume standard `/usr/bin` paths. Always support `$PREFIX/bin` (`/data/data/com.termux/files/usr/bin`) and `$HOME`.
- **Zero Sudo Requirement**: All installation, profile switching, and configuration commands must execute cleanly in unrooted userspace.
- **Graceful Tool Fallbacks**: When external commands (like `eza`, `bat`, `fzf`, `starship`) are missing, scripts must fall back gracefully to POSIX standards (`ls`, `cat`, etc.) without terminal errors.

### 3. 🛡️ Safe Non-Destructive Dotfile Migration
- **Timestamped Backups**: Any automated installer or profile switcher must create timestamped backups of existing dotfiles (`~/.zshrc`, `~/.termux/`, `~/.tmux.conf`) before writing modifications.
- **Idempotence**: Running installation or profile configuration multiple times must produce identical, clean results without duplicate entries or shell syntax degradation.

### 4. 🔑 Sovereign Cryptographic Key Discipline
- **Zero In-Repo Secrets**: Never commit SSH private keys (`id_ed25519`), tokens, or credentials to git.
- **Automated Peer Discovery**: Network peer connections (`peer`, `motobook`) must rely on dynamic gateway resolution and Ed25519 public key authentication.

### 5. 🛣️ Zero Machine Path Invariant
- **Relative & Dynamic Paths**: Never hardcode local workstation paths. Use dynamic shell expansion (`$HOME`, `$PREFIX`).
