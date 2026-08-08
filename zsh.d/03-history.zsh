HISTSIZE=10000
SAVEHIST=20000
HISTFILE=~/.zsh_history

setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_SAVE_NO_DUPS
setopt HIST_EXPIRE_DUPS_FIRST

if [[ -f "$HISTFILE" ]]; then
    current_perms=$(stat -c '%a' "$HISTFILE" 2>/dev/null || stat -f '%Lp' "$HISTFILE" 2>/dev/null)
    if [[ "$current_perms" != "600" ]]; then
        chmod 600 "$HISTFILE" &>/dev/null
    fi
fi
