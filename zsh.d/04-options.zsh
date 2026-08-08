setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt INTERACTIVE_COMMENTS
setopt NO_BEEP
setopt EXTENDED_GLOB
setopt GLOB_DOTS
setopt COMPLETE_IN_WORD
setopt ALWAYS_TO_END
setopt CORRECT
setopt COMPLETE_ALIASES
setopt NO_NOMATCH
setopt LIST_TYPES
setopt AUTO_REMOVE_SLASH

zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path ~/.zsh-cache

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' group-name ''
zstyle ':completion:*' format '%B%F{blue}-- %d --%f%b'
zstyle ':completion:*' menu select=2
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
