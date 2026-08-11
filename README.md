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
[Utility Functions](#-utility-functions) •
[Contributing](#-contributing)

</div>

---

## 📖 Description

A modular Zsh configuration with symlink-based installation. The entire configuration is split into numbered modules (`00-env.zsh`, `01-path.zsh`, etc.), making it easy to understand, customize, and extend.

---

## ✨ Features

- **Modular structure** — `zsh.d/` with logical numbering (00-99)
- **One-command installation** — auto OS detection and package installation
- **Smart prompt** — shows Git status with compact indicators
- **Modern tools** — integration with `eza`, `bat`, `fzf`, `zoxide`, `yazi`
- **Auto-start tmux** — automatically creates a session on terminal launch
- **Cross-platform** — works on Linux, macOS, and WSL
- **No bloat** — clean configuration without unnecessary aliases

---

## 📦 Included Tools

| Category            | Tools                                                                   |
| ------------------- | ----------------------------------------------------------------------- |
| **File Management** | `eza` (modern ls), `bat` (better cat), `yazi` (file manager)            |
| **Search & Find**   | `ripgrep` (rg), `fd-find` (fd), `fzf` (fuzzy finder)                    |
| **System**          | `btop` (monitoring), `ncdu` (disk usage), `tmux` (terminal multiplexer) |
| **Navigation**      | `zoxide` (smart cd), custom CDPATH                                      |
| **Network**         | `curl`, `wget`, `aria2` (download accelerator)                          |
| **Git**             | Full set of git aliases for common operations                           |

---

## 🛠️ Installation

### Quick start

```bash
git clone https://github.com/masaji-ef/chadZsh.git
cd chadZsh
./install.sh
source ~/.zshrc
```

### Installation options

```bash
./install.sh --no-packages
```

### What gets installed

| Category  | Packages                                                                               |
| --------- | -------------------------------------------------------------------------------------- |
| **Base**  | `zsh`, `curl`, `wget`, `git`, `vim`, `tmux`, `ncdu`, `jq`, `less`                      |
| **Tools** | `btop`, `ripgrep`, `fd-find`, `bat`, `eza`, `fzf`, `zoxide`, `direnv`, `aria2`, `yazi` |

---

## 🎨 Git Status

The prompt shows Git status with compact indicators:

```bash
# Clean repository
fedora@fedora:project main
❯

# With changes
fedora@fedora:project main +3~2?5 ↑4 ↓1 ⚑7
❯

# During merge
fedora@fedora:project main | merge
❯

# During rebase
fedora@fedora:project main | rebase
❯
```

### Indicator meanings

| Indicator | Meaning                          |
| --------- | -------------------------------- |
| `+3`      | 3 staged files (ready to commit) |
| `~2`      | 2 modified files (not staged)    |
| `?5`      | 5 untracked files                |
| `↑4`      | 4 commits ahead of remote        |
| `↓1`      | 1 commit behind remote           |
| `⚑7`      | 7 stashed changes                |
| `merge`   | Resolving merge conflicts        |
| `rebase`  | In the middle of a rebase        |

---

## 🖥️ Supported Platforms

| OS                           | Status          | Package Manager |
| ---------------------------- | --------------- | --------------- |
| 🐧 **Linux (Debian/Ubuntu)** | ✅ Full support | `apt`           |
| 🐧 **Linux (Fedora/RHEL)**   | ✅ Full support | `dnf`/`yum`     |
| 🐧 **Linux (Arch)**          | ✅ Full support | `pacman`        |
| 🐧 **Linux (Alpine)**        | ✅ Full support | `apk`           |
| 🐧 **Linux (openSUSE)**      | ✅ Full support | `zypper`        |
| 🍎 **macOS**                 | ✅ Full support | `brew`          |
| 🪟 **WSL2**                  | ✅ Full support | -               |

---

## 🤝 Contributing

1. **Fork** the repository
2. **Create** a feature branch
3. **Commit** your changes
4. **Push** to the branch
5. **Open** a Pull Request

### Development guidelines

- Keep modules numbered (00-99)
- Test on at least one Linux distribution
- Update README if adding features

---

## 📄 License

MIT License. See [LICENSE](LICENSE) for details.

---

<div align="center">

### ⭐ Star this repo if you find it useful!

[![GitHub stars](https://img.shields.io/github/stars/masaji-ef/chadZsh?style=for-the-badge&logo=github)](https://github.com/masaji-ef/chadZsh/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/masaji-ef/chadZsh?style=for-the-badge&logo=github)](https://github.com/masaji-ef/chadZsh/network/members)

</div>
