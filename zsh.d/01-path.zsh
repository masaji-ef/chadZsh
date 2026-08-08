typeset -U path

add_path() {
    for p in "$@"; do
        [[ -d "$p" ]] && path=("$p" $path)
    done
}

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

export CDPATH=".:~:/var/log:/etc:/usr/local/etc:/opt:/mnt:/srv"
