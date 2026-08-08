autoload -Uz compinit
compinit -i

zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' rehash true
zstyle ':completion:*' verbose yes
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _match _approximate
zstyle ':completion:*' expand prefix suffix

if command -v eza &>/dev/null && type _eza >/dev/null 2>&1; then
    if ! type _eza >/dev/null 2>&1; then
        eza --zsh-completion 2>/dev/null | source /dev/stdin 2>/dev/null
    fi
fi

if command -v podman &>/dev/null; then
    true
fi
if command -v systemctl &>/dev/null; then
    true
fi
if command -v journalctl &>/dev/null; then
    true
fi
