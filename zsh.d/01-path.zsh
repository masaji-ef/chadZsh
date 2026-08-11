# Set cursor to blinking block
echo -ne "\e[2 q"

# Remove duplicate path entries
typeset -U path

# Add directories to PATH if they exist
add_path() {
    for p in "$@"; do
        [[ -d "$p" ]] && path=("$p" $path)
    done
}

# Common binary directories
add_path \
    "$HOME/.local/bin" \
    "$HOME/bin" \
    "/usr/local/bin" \
    "/usr/local/sbin" \
    "$(go env GOPATH 2>/dev/null)/bin" \
    "$HOME/.cargo/bin" \
    "$HOME/.local/share/npm/bin" \
    "$HOME/.local/share/flatpak/exports/bin"

export PATH

# CDPATH for cd command - current and home only
export CDPATH=".:~"
