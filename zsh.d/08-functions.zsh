# Create directory and cd into it
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

# Create temp directory and cd into it
tmp() {
    local dir=$(mktemp -d)
    cd "$dir"
    echo "📁 $dir"
}

# Go up N directories
up() {
    local n="${1:-1}"
    local p=""
    for ((i=0; i<n; i++)); do
        p="../$p"
    done
    cd "$p"
}

# Show PATH as list
path() {
    echo -e "${PATH//:/\\n}"
}

# Grep in history with fzf
histgrep() {
    if ! command -v fzf &>/dev/null; then
        echo "fzf not installed" >&2
        return 1
    fi
    if [[ -z "$1" ]]; then
        echo "Usage: histgrep <pattern>"
        return 1
    fi

    local result=$(fc -l 1 | grep -i --color=always "$1" | \
        fzf --tac --height=40% --reverse --border \
            --prompt="Found matches> " \
            --preview='echo {2..}' \
            --preview-window='down:3:wrap' \
            2>/dev/null | \
        sed 's/^[ ]*[0-9]*[ ]*//')

    if [[ -n "$result" ]]; then
        print -z "$result"
    fi
}

# Show last N commands with fzf
histlast() {
    if ! command -v fzf &>/dev/null; then
        echo "fzf not installed" >&2
        return 1
    fi
    local count=${1:-20}
    local cmd=$(fc -l -$count | \
        fzf --tac --no-sort \
            --height=40% \
            --reverse \
            --border \
            --prompt="Last $count commands> " \
            2>/dev/null | \
        sed 's/^[ ]*[0-9]*[ ]*//')

    if [[ -n "$cmd" ]]; then
        print -z "$cmd"
    fi
}

# Run command from history
histrun() {
    if ! command -v fzf &>/dev/null; then
        echo "fzf not installed" >&2
        return 1
    fi
    local cmd=$(fc -l 1 | \
        fzf --tac --no-sort --exact \
            --height=40% \
            --reverse \
            --border \
            --prompt="Run> " \
            2>/dev/null | \
        sed 's/^[ ]*[0-9]*[ ]*//')

    if [[ -n "$cmd" ]]; then
        eval "$cmd"
    fi
}

# History statistics
histstats() {
    echo "History statistics:"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    local total=$(fc -l 1 | wc -l)
    local unique=$(fc -l 1 | awk '!seen[$0]++' | wc -l)
    local duplicates=$((total - unique))

    echo "Total commands: $total"
    echo "Unique: $unique"
    echo "Duplicates: $duplicates"
    echo ""

    echo "Top 10 commands:"
    fc -l 1 | \
        sed 's/^[ ]*[0-9]*[ ]*//' | \
        awk '{print $1}' | \
        sort | \
        uniq -c | \
        sort -rn | \
        head -10 | \
        awk '{printf "  %4dx %s\n", $1, $2}'
}

# History aliases
alias hg='histgrep'
alias hl='histlast'
alias hr='histrun'
alias hs='histstats'
alias hc='history -c && history -w && echo "History cleared"'

# Find files by pattern
findfile() {
    if command -v fd &>/dev/null; then
        fd -tf "$1" 2>/dev/null
    else
        find . -type f -name "*$1*" 2>/dev/null
    fi
}

# Find directories by pattern
finddir() {
    if command -v fd &>/dev/null; then
        fd -td "$1" 2>/dev/null
    else
        find . -type d -name "*$1*" 2>/dev/null
    fi
}

# Extract various archive formats
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

# Create backup with timestamp
backup() {
    cp -iv "$1" "$1.bak.$(date +%Y%m%d_%H%M%S)"
}

# Clear file contents
empty() {
    if [ -f "$1" ]; then
        > "$1"
        echo "✅ Cleared: $1"
    else
        echo "❌ File not found: $1"
    fi
}

# Show file/directory size
size() {
    if [ -e "$1" ]; then
        du -sh "$1"
    else
        echo "❌ Not found: $1"
    fi
}

# Touch and edit file
touchp() {
    if [ -z "$1" ]; then
        echo "❌ Usage: touchp <filename>"
        return 1
    fi
    touch "$1"
    vim "$1"
}

# Create Python script template
mkpy() {
    echo "#!/usr/bin/env python3" > "$1"
    echo "print('Hello, World!')" >> "$1"
    chmod +x "$1"
    vim "$1"
}

# Create bash script template
mksh() {
    echo "#!/bin/bash" > "$1"
    echo "echo 'Hello, World!'" >> "$1"
    chmod +x "$1"
    vim "$1"
}

# Copy path to clipboard
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

# Copy file contents to clipboard
copyfile() {
    if [ -f "$1" ]; then
        cat "$1" | wl-copy 2>/dev/null || cat "$1" | xclip -selection clipboard 2>/dev/null
        echo "✅ Copied contents of: $1"
    else
        echo "❌ File not found: $1"
    fi
}

# Kill process using port
killport() {
    lsof -ti tcp:"$1" | xargs kill -9 2>/dev/null || echo "No process on port $1"
}

# Check if port is open
portcheck() {
    nc -zv localhost "$1" 2>&1
}

# Log with timestamp
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> ~/.bash_log
}
