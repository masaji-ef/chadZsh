<div align="center">

<img src="pic.svg" alt="chadZsh" width="900">

# ⚡chadZsh

**Modern Zsh configuration for daily development**

[![Zsh](https://img.shields.io/badge/Zsh-5.0+-4EAA25?style=for-the-badge&logo=gnubash&logoColor=white)](https://www.zsh.org/)
[![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)](https://www.linux.org/)
[![macOS](https://img.shields.io/badge/macOS-000000?style=for-the-badge&logo=apple&logoColor=white)](https://www.apple.com/macos/)
[![WSL](https://img.shields.io/badge/WSL-0a97f5?style=for-the-badge&logo=windows&logoColor=white)](https://learn.microsoft.com/en-us/windows/wsl/)
[![MIT License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

[![GitHub stars](https://img.shields.io/github/stars/masaji-ef/chadZsh?style=social)](https://github.com/masaji-ef/chadZsh/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/masaji-ef/chadZsh?style=social)](https://github.com/masaji-ef/chadZsh/network/members)
[![GitHub watchers](https://img.shields.io/github/watchers/masaji-ef/chadZsh?style=social)](https://github.com/masaji-ef/chadZsh/watchers)
[![GitHub last commit](https://img.shields.io/github/last-commit/masaji-ef/chadZsh)](https://github.com/masaji-ef/chadZsh/commits)

[Installation](#-installation) •
[Features](#-features) •
[Git Status](#-git-status) •
[Keyboard Shortcuts](#-keyboard-shortcuts) •
[Utility Functions](#-utility-functions) •
[Contributing](#-contributing)

</div>

---

## 📖 Description

A simple modular Zsh configuration with symlink-based installation — no clutter in your home directory. The entire configuration is split into numbered modules (`00-env.zsh`, `01-path.zsh`, etc.), making it easy to understand, customize, and extend.

### ✨ Features

- **Modular structure** — `zsh.d/` with logical numbering (00-99)
- **One-command installation** — auto OS detection and package installation
- **Smart prompt** — shows detailed Git status with colors and full text indicators
- **Modern tools** — integration with `eza`, `bat`, `fzf`, `zoxide`, `yazi`
- **Interactive widgets** — `Ctrl+R` for history search, `Ctrl+Y` for yazi
- **Auto-start tmux** — automatically creates a session on terminal launch
- **Cross-platform** — works on Linux, macOS, and WSL
- **No bloat** — clean configuration without unnecessary aliases

### 📦 Included Tools

| Category | Tools |
|----------|-------|
| **File Management** | `eza` (modern ls), `bat` (better cat), `yazi` (file manager) |
| **Search & Find** | `ripgrep` (rg), `fd-find` (fd), `fzf` (fuzzy finder) |
| **System** | `btop` (monitoring), `ncdu` (disk usage), `tmux` (terminal multiplexer) |
| **Navigation** | `zoxide` (smart cd), custom CDPATH |
| **Network** | `curl`, `wget`, `aria2` (download accelerator) |

---

## 🛠️ Installation

### Quick start

```bash
# Clone the repository
git clone https://github.com/masaji-ef/chadZsh.git

# Enter the directory
cd chadZsh

# Run the installer
./install.sh

# Apply changes
source ~/.zshrc
```

### Installation options

```bash
# Skip package installation (useful if you already have tools)
./install.sh --no-packages
```

### What gets installed

| Category | Packages |
|----------|----------|
| **Base** | `zsh`, `curl`, `wget`, `git`, `vim`, `tmux`, `ncdu`, `jq`, `less` |
| **Tools** | `btop`, `ripgrep`, `fd-find`, `bat`, `eza`, `fzf`, `zoxide`, `direnv`, `aria2`, `yazi` |

---

## 🎨 Git Status

The prompt shows detailed Git information in plain text — no cryptic symbols:

```bash
# Clean repository — nothing to commit
fedora@fedora:~/project main abc1234
❯

# With changes — ready to commit or push
fedora@fedora:~/project main abc1234 staged:3 unstaged:2 untracked:5 ahead:4 behind:1 stash:7
❯

# During merge — resolving conflicts
fedora@fedora:~/project main | merge
❯

# During rebase — rewriting history
fedora@fedora:~/project main | rebase
❯
```

### What each indicator means

| Indicator | Meaning |
|-----------|---------|
| `main` | Current branch name (green) |
| `abc1234` | Short commit hash (blue) |
| `staged:3` | 3 files added with `git add`, ready to commit (yellow) |
| `unstaged:2` | 2 files modified but not added (yellow) |
| `untracked:5` | 5 new files not tracked by Git (magenta) |
| `ahead:4` | 4 commits ahead of remote — need to `git push` (red) |
| `behind:1` | 1 commit behind remote — need to `git pull` (red) |
| `stash:7` | 7 stashes saved with `git stash` |
| `merge` | Currently resolving merge conflicts |
| `rebase` | Currently in the middle of a rebase |

---

## ⌨️ Keyboard Shortcuts

| Key | Action |
|-----|--------|
| `Ctrl+R` | Search command history with fzf (fuzzy finder) |
| `Ctrl+Y` | Open yazi file manager, automatically cd into selected directory |
| `↑` / `↓` | Search history by command prefix (type first letters then press arrow) |
| `Ctrl+P` | History search backward |
| `Ctrl+N` | History search forward |
| `Tab` | Smart autocompletion with colors and groups |

---

## 🛠️ Utility Functions

### Directory management

```bash
mkcd dir/            # Create directory and cd into it
take dir/            # Same as mkcd
tmp                  # Create temp directory and cd into it
up N                 # Go up N directories (up 3 = cd ../../..)
```

### File operations

```bash
extract archive.zip  # Extract any archive (supports .tar.gz, .zip, .rar, .7z, .xz, .zst, and more)
backup file.txt      # Create timestamped backup: file.txt.bak.20240101_120000
empty file.txt       # Clear file contents without deleting the file
size file.txt        # Show file/directory size with human-readable format
touchp file.txt      # Create file and open it in vim
```

### Search and find

```bash
findfile "*.go"      # Search for files (uses fd if available, otherwise find)
finddir "src"        # Search for directories (uses fd if available, otherwise find)
histgrep "command"   # Search history with rg or grep
hg "command"         # Alias for histgrep
histdate             # Show today's history entries
```

### System and network

```bash
killport 8080        # Kill process running on port 8080
portcheck 8080       # Check if port 8080 is open and listening
copypath             # Copy current path to clipboard (supports Wayland and X11)
copyfile file.txt    # Copy file contents to clipboard
mkpy script.py       # Create executable Python script with shebang
mksh script.sh       # Create executable Bash script with shebang
log "message"        # Log message with timestamp to ~/.bash_log
path                 # Show all PATH entries, one per line
```

---

## 🎯 Core Aliases

### Navigation
```bash
.. ... .... .....    # Quick directory traversal
~                    # Go to home directory
ll la l              # ls variants (list, all, long)
sl                   # ls (typo protection — maps to ls)
```

### Quick commands
```bash
c                    # Clear screen
src                  # Source ~/.zshrc (reload configuration)
vi v nv              # vim, vim (alias), nvim
s                    # sudo
e q cls              # exit, exit, clear
```

### System
```bash
df                   # Disk free with human-readable sizes and filesystem type
free                 # Memory info with human-readable sizes
ps                   # Process list with tree view
psg                  # ps aux | grep (quick process search)
ss                   # Socket statistics with listening ports
ping                 # ping with 5 packets by default
load                 # Show uptime, memory, and disk usage at once
```

### File viewing
```bash
ls                   # eza with icons, Git status, and colors
tree                 # Directory tree with icons and Git status
```

---

## 🖥️ Supported Platforms

| OS | Status | Package Manager |
|----|--------|-----------------|
| 🐧 **Linux (Debian/Ubuntu)** | ✅ Full support | `apt` |
| 🐧 **Linux (Fedora/RHEL)** | ✅ Full support | `dnf`/`yum` |
| 🐧 **Linux (Arch)** | ✅ Full support | `pacman` |
| 🐧 **Linux (Alpine)** | ✅ Full support | `apk` |
| 🐧 **Linux (openSUSE)** | ✅ Full support | `zypper` |
| 🍎 **macOS** | ✅ Full support | `brew` |
| 🪟 **WSL2** | ✅ Full support | - |

---

## 🤝 Contributing

Contributions are welcome! Here's how:

1. **Fork** the repository
2. **Create** a feature branch:
   ```bash
   git checkout -b feature/amazing-feature
   ```
3. **Commit** your changes:
   ```bash
   git commit -m 'Add amazing feature'
   ```
4. **Push** to the branch:
   ```bash
   git push origin feature/amazing-feature
   ```
5. **Open** a Pull Request

### Development guidelines

- Keep modules numbered (00-99)
- Test on at least one Linux distribution
- Update README if adding features

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

<div align="center">

### ⭐ Star this repo if you find it useful!

[![GitHub stars](https://img.shields.io/github/stars/masaji-ef/chadZsh?style=for-the-badge&logo=github)](https://github.com/masaji-ef/chadZsh/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/masaji-ef/chadZsh?style=for-the-badge&logo=github)](https://github.com/masaji-ef/chadZsh/network/members)

</div>

