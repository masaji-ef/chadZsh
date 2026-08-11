#!/bin/bash
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m'

NO_PACKAGES=false
while [[ $# -gt 0 ]]; do
    case "$1" in
        --no-packages) NO_PACKAGES=true ;;
        --help|-h)
            echo -e "${BOLD}Usage:${NC} ./install.sh [OPTIONS]"
            echo ""
            echo -e "${BOLD}Options:${NC}"
            echo "  --no-packages    Skip package installation"
            echo "  --help, -h       Show this help message"
            exit 0
            ;;
        *) echo -e "${RED}❌ Unknown option: $1${NC}"; exit 1 ;;
    esac
    shift
done

clear
echo ""
echo -e "${BOLD}${CYAN}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}${CYAN}║                                                           ║${NC}"
echo -e "${BOLD}${CYAN}║   🚀  CHADZSH INSTALLER                                 ║${NC}"
echo -e "${BOLD}${CYAN}║                                                           ║${NC}"
echo -e "${BOLD}${CYAN}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""

detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [ -f /etc/os-release ]; then
        . /etc/os-release
        echo "$ID"
    else
        echo "unknown"
    fi
}

OS=$(detect_os)
echo -e "${GREEN}✅${NC} Detected OS: ${BOLD}${CYAN}$OS${NC}"

case $OS in
    macos) PKG_MANAGER="brew" ;;
    alpine) PKG_MANAGER="apk" ;;
    debian|ubuntu|pop|linuxmint|elementary) PKG_MANAGER="apt" ;;
    fedora|rhel|centos|rocky|almalinux|ol) PKG_MANAGER="dnf" ;;
    opensuse*|suse) PKG_MANAGER="zypper" ;;
    arch|manjaro|endeavouros) PKG_MANAGER="pacman" ;;
    *) PKG_MANAGER="unknown" ;;
esac
echo -e "${GREEN}✅${NC} Package manager: ${BOLD}${CYAN}$PKG_MANAGER${NC}"
echo ""

if [[ ! -f .zshrc ]] || [[ ! -d zsh.d ]]; then
    echo -e "${RED}❌ Please run this script from the root of the chadZsh repository.${NC}"
    exit 1
fi

install_pkgs() {
    local packages=("$@")
    if [[ ${#packages[@]} -eq 0 ]]; then
        return 0
    fi
    echo -e "${BLUE}📦 Installing: ${BOLD}${packages[*]}${NC}"
    case $OS in
        macos)
            if ! command -v brew &>/dev/null; then
                echo -e "${YELLOW}⚠️ Homebrew not found. Skipping.${NC}"
                return 0
            fi
            brew update 2>/dev/null || true
            brew install "${packages[@]}" 2>/dev/null || true
            ;;
        alpine)
            apk update 2>/dev/null || true
            apk add "${packages[@]}" 2>/dev/null || true
            ;;
        debian|ubuntu|pop|linuxmint|elementary)
            apt update 2>/dev/null || true
            apt install -y "${packages[@]}" 2>/dev/null || true
            ;;
        fedora|rhel|centos|rocky|almalinux|ol)
            if command -v dnf &>/dev/null; then
                dnf install -y epel-release 2>/dev/null || true
                dnf install -y "${packages[@]}" 2>/dev/null || true
            else
                yum install -y epel-release 2>/dev/null || true
                yum install -y "${packages[@]}" 2>/dev/null || true
            fi
            ;;
        opensuse*|suse)
            zypper refresh 2>/dev/null || true
            zypper install -y "${packages[@]}" 2>/dev/null || true
            ;;
        arch|manjaro|endeavouros)
            pacman -Sy --noconfirm --needed "${packages[@]}" 2>/dev/null || true
            ;;
        *)
            echo -e "${YELLOW}⚠️ Unsupported OS. Skipping.${NC}"
            ;;
    esac
}

BACKUP_DIR="$HOME/.zsh_backup_$(date +%Y%m%d_%H%M%S)"
backup_existing() {
    if [[ -f ~/.zshrc ]] || [[ -d ~/.zsh.d ]]; then
        echo -e "${YELLOW}⚠️ Existing config files found.${NC}"
        read -p "Create backup before installing? [Y/n] " -r
        if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
            mkdir -p "$BACKUP_DIR"
            [[ -f ~/.zshrc ]] && cp ~/.zshrc "$BACKUP_DIR/"
            [[ -d ~/.zsh.d ]] && cp -r ~/.zsh.d "$BACKUP_DIR/"
            echo -e "${GREEN}✅ Backup saved to: $BACKUP_DIR${NC}"
        fi
    fi
}

if [[ "$NO_PACKAGES" == true ]]; then
    echo -e "${YELLOW}⏩ Skipping package installation (--no-packages).${NC}"
else
    echo -e "${BOLD}${CYAN}📦 Package Selection${NC}"
    echo ""
    echo -e "${BOLD}${GREEN}Base packages:${NC} zsh, curl, wget, git, vim, tmux, ncdu, jq, less, podman, docker, docker-compose, containerd"
    echo -e "${BOLD}${GREEN}Tools:${NC} btop, ripgrep, fd-find, bat, eza, fzf, zoxide, direnv, aria2, yazi"
    echo ""

    read -p "Install base packages? [Y/n] " -r
    if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
        BASE_PKGS=(zsh curl wget git vim tmux ncdu jq less)
        case $OS in
            fedora|rhel|centos|rocky|almalinux|ol)
                BASE_PKGS+=(podman docker docker-compose containerd)
                ;;
            debian|ubuntu|pop|linuxmint|elementary)
                BASE_PKGS+=(podman docker.io docker-compose containerd)
                ;;
            arch|manjaro|endeavouros)
                BASE_PKGS+=(podman docker docker-compose containerd)
                ;;
            macos)
                BASE_PKGS+=(podman docker docker-compose containerd)
                ;;
            *)
                BASE_PKGS+=(podman docker docker-compose containerd)
                ;;
        esac
        install_pkgs "${BASE_PKGS[@]}"
        echo -e "${GREEN}✅ Base packages installed${NC}"
    else
        echo -e "${YELLOW}⏩ Skipping base packages.${NC}"
    fi
    echo ""

    read -p "Install tools (btop, ripgrep, fd, bat, eza, fzf, zoxide, direnv, aria2, yazi)? [Y/n] " -r
    if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
        TOOLS_PKGS=(btop ripgrep fd-find bat eza fzf zoxide direnv aria2)
        case $OS in
            macos|alpine|arch|manjaro|endeavouros)
                TOOLS_PKGS=(btop ripgrep fd bat eza fzf zoxide direnv aria2)
                ;;
            debian|ubuntu|pop|linuxmint|elementary)
                TOOLS_PKGS=(btop ripgrep fd-find bat eza fzf zoxide direnv aria2)
                ;;
            fedora|rhel|centos|rocky|almalinux|ol)
                TOOLS_PKGS=(btop ripgrep fd-find bat eza fzf zoxide direnv aria2)
                ;;
        esac
        TOOLS_PKGS+=(yazi)
        install_pkgs "${TOOLS_PKGS[@]}"
        echo -e "${GREEN}✅ Tools installed${NC}"
    else
        echo -e "${YELLOW}⏩ Skipping tools.${NC}"
    fi
fi

echo ""
backup_existing

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

echo -e "${BLUE}🧹 Cleaning old symlinks...${NC}"
rm -f ~/.zshrc
rm -f ~/.zsh.d

ln -sf "$SCRIPT_DIR/.zshrc" ~/.zshrc
echo -e "${GREEN}✅ Symlink created:${NC}"
echo -e "   ~/.zshrc  -> $SCRIPT_DIR/.zshrc"

ln -sf "$SCRIPT_DIR/zsh.d" ~/.zsh.d
echo -e "${GREEN}✅ Symlink created:${NC}"
echo -e "   ~/.zsh.d  -> $SCRIPT_DIR/zsh.d"

if [[ -L ~/.zsh.d ]]; then
    TARGET=$(readlink ~/.zsh.d)
    if [[ "$TARGET" != "$SCRIPT_DIR/zsh.d" ]]; then
        echo -e "${RED}❌ Symlink points to wrong location. Fixing...${NC}"
        rm -f ~/.zsh.d
        ln -sf "$SCRIPT_DIR/zsh.d" ~/.zsh.d
    fi
fi

if [[ -f ~/.zsh.d/16-personal.zsh ]] && [[ ! -L ~/.zsh.d/16-personal.zsh ]]; then
    echo -e "${YELLOW}⚠️ Removing duplicate 16-personal.zsh from ~/.zsh.d${NC}"
    rm -f ~/.zsh.d/16-personal.zsh
fi

grep -q "source ~/.zshrc" ~/.zprofile 2>/dev/null || echo 'source ~/.zshrc' >> ~/.zprofile

if [ "$SHELL" != "/bin/zsh" ] && [ -x /bin/zsh ]; then
    echo -e "${YELLOW}🔧 Changing default shell to zsh...${NC}"
    read -p "Change default shell to zsh? [Y/n] " -r
    if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
        if command -v chsh &>/dev/null; then
            chsh -s /bin/zsh "$(whoami)" 2>/dev/null && echo -e "${GREEN}✅ Shell changed to zsh${NC}" || echo -e "${YELLOW}⚠️ Run manually: chsh -s /bin/zsh${NC}"
        else
            echo -e "${YELLOW}⚠️ chsh not found. Please change shell manually: chsh -s /bin/zsh${NC}"
        fi
    else
        echo -e "${YELLOW}⏩ Keeping current shell.${NC}"
    fi
fi

echo ""
echo -e "${BOLD}${CYAN}🔍 Installed Tools${NC}"
for tool in bat eza fzf fd rg btop zoxide ncdu tmux jq direnv aria2c yazi vim podman docker git; do
    case $tool in
        fd)
            if command -v fd &>/dev/null || command -v fdfind &>/dev/null; then
                echo -e "  ${GREEN}✅${NC} $tool: OK"
            else
                echo -e "  ${YELLOW}⚠️${NC} $tool: not found"
            fi
            ;;
        *)
            if command -v $tool &>/dev/null; then
                echo -e "  ${GREEN}✅${NC} $tool: $(which $tool 2>/dev/null | head -1)"
            else
                echo -e "  ${YELLOW}⚠️${NC} $tool: not found"
            fi
            ;;
    esac
done

echo ""
echo -e "${BOLD}${GREEN}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}${GREEN}║                     ✅ DONE!                            ║${NC}"
echo -e "${BOLD}${GREEN}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}📌${NC} ${BOLD}To apply changes:${NC}"
echo -e "   ${CYAN}source ~/.zshrc${NC}   or   restart terminal"
echo ""
echo -e "${YELLOW}📌${NC} ${BOLD}Quick test:${NC}"
echo -e "   ${CYAN}ls${NC}       — should show colors and icons with eza"
echo -e "   ${CYAN}Ctrl+R${NC}   — fzf history search"
echo -e "   ${CYAN}Ctrl+Y${NC}   — open yazi file manager"
echo -e "   ${CYAN}git --version${NC} — should show Git version"
echo -e "   ${CYAN}docker ps${NC} — should work (podman alias if docker not installed)"
echo ""
echo -e "${BOLD}${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
