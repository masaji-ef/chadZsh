# Completion settings
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path ~/.zsh-cache

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# Colored completion
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' group-name ''
zstyle ':completion:*' format '%B%F{blue}-- %d --%f%b'
zstyle ':completion:*' menu select=2
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle ':completion:*' rehash true
zstyle ':completion:*' verbose yes
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _match _approximate
zstyle ':completion:*' expand prefix suffix

# Load completion system
autoload -Uz compinit
compinit -i

# Completion for modern tools
if command -v eza &>/dev/null && type _eza >/dev/null 2>&1; then
    if ! type _eza >/dev/null 2>&1; then
        eza --zsh-completion 2>/dev/null | source /dev/stdin 2>/dev/null
    fi
fi
