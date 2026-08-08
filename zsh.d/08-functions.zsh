mkcd() {
    if [[ -d "$1" ]]; then
        cd "$1"
    else
        mkdir -p "$1" && cd "$1"
    fi
}
take() {
    mkcd "$1"
}

tmp() {
    local dir=$(mktemp -d)
    cd "$dir"
    echo "📁 $dir"
}

histgrep() {
    if command -v rg &>/dev/null; then
        history | rg "$1"
    else
        history | grep --color=auto "$1"
    fi
}
alias hg='histgrep'

histdate() {
    history | grep "$(date '+%Y-%m-%d')"
}

findfile() {
    if command -v fd &>/dev/null; then
        fd -tf "$1" 2>/dev/null
    else
        find . -type f -name "*$1*" 2>/dev/null
    fi
}

finddir() {
    if command -v fd &>/dev/null; then
        fd -td "$1" 2>/dev/null
    else
        find . -type d -name "*$1*" 2>/dev/null
    fi
}

extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1" ;;
            *.tar.gz)    tar xzf "$1" ;;
            *.tar.xz)    tar xJf "$1" ;;
            *.tar.zst)   tar --zstd -xf "$1" ;;
            *.bz2)       bunzip2 "$1" ;;
            *.gz)        gunzip "$1" ;;
            *.tar)       tar xf "$1" ;;
            *.tbz2)      tar xjf "$1" ;;
            *.tgz)       tar xzf "$1" ;;
            *.zip)       unzip "$1" ;;
            *.rar)       unrar x "$1" ;;
            *.7z)        7z x "$1" ;;
            *.xz)        xz -d "$1" ;;
            *.zst)       zstd -d "$1" ;;
            *)           echo "Unknown format: $1" ;;
        esac
    else
        echo "File not found: $1"
    fi
}

backup() {
    cp -iv "$1" "$1.bak.$(date +%Y%m%d_%H%M%S)"
}

killport() {
    lsof -ti tcp:"$1" | xargs kill -9 2>/dev/null || echo "No process on port $1"
}

portcheck() {
    nc -zv localhost "$1" 2>&1
}

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> ~/.bash_log
}

mkpy() {
    echo "#!/usr/bin/env python3" > "$1"
    echo "print('Hello, World!')" >> "$1"
    chmod +x "$1"
    vim "$1"
}

mksh() {
    echo "#!/bin/bash" > "$1"
    echo "echo 'Hello, World!'" >> "$1"
    chmod +x "$1"
    vim "$1"
}

copypath() {
    local file="${1:-.}"
    if [[ -d "$file" ]]; then
        local path="$(cd "$file" && pwd)"
    else
        local path="$(realpath "$file")"
    fi
    echo -n "$path" | wl-copy 2>/dev/null || echo -n "$path" | xclip -selection clipboard 2>/dev/null
    echo "✅ Copied: $path"
}

copyfile() {
    if [ -f "$1" ]; then
        cat "$1" | wl-copy 2>/dev/null || cat "$1" | xclip -selection clipboard 2>/dev/null
        echo "✅ Copied contents of: $1"
    else
        echo "❌ File not found: $1"
    fi
}

empty() {
    if [ -f "$1" ]; then
        > "$1"
        echo "✅ Cleared: $1"
    else
        echo "❌ File not found: $1"
    fi
}

size() {
    if [ -e "$1" ]; then
        du -sh "$1"
    else
        echo "❌ Not found: $1"
    fi
}

up() {
    local n="${1:-1}"
    local path=""
    for ((i=0; i<n; i++)); do
        path="../$path"
    done
    cd "$path"
}

touchp() {
    if [ -z "$1" ]; then
        echo "❌ Usage: touchp <filename>"
        return 1
    fi
    touch "$1"
    vim "$1"
}

path() {
    echo -e "${PATH//:/\\n}"
}
