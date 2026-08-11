# History settings
HISTSIZE=50000
SAVEHIST=100000
HISTFILE=~/.zsh_history

# History options
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_SAVE_NO_DUPS
setopt HIST_EXPIRE_DUPS_FIRST

# Set history file permissions
if [[ -f "$HISTFILE" ]]; then
    current_perms=$(stat -c '%a' "$HISTFILE" 2>/dev/null || stat -f '%Lp' "$HISTFILE" 2>/dev/null)
    if [[ "$current_perms" != "600" ]]; then
        chmod 600 "$HISTFILE" &>/dev/null
    fi
fi

# FZF history search widget (no colors)
if command -v fzf &>/dev/null; then
    fzf_history_widget() {
        local selected
        setopt localoptions noglobsubst noposixbuiltins pipefail 2>/dev/null

        selected=$(fc -l -n -1 0 2>/dev/null | \
            awk '!seen[$0]++' | \
            fzf \
                --tac \
                --no-sort \
                --exact \
                --query="$LBUFFER" \
                --height=40% \
                --reverse \
                --border \
                --prompt="History> " \
                --pointer="▶ " \
                --bind='tab:down,shift-tab:up' \
                --bind='ctrl-r:toggle-sort' \
                2>/dev/null)

        if [[ -n "$selected" ]]; then
            LBUFFER="$selected"
            zle end-of-line
            zle redisplay
        fi
        zle reset-prompt
    }

    zle -N fzf_history_widget
    bindkey '^R' fzf_history_widget

    # Show all history
    fzf_history_all() {
        local selected
        selected=$(fc -l -n -1 0 2>/dev/null | \
            awk '!seen[$0]++' | \
            fzf \
                --tac \
                --no-sort \
                --exact \
                --height=60% \
                --reverse \
                --border \
                --prompt="All history> " \
                --bind='tab:down,shift-tab:up' \
                --bind='ctrl-r:reload(fc -l -n -1 0 | awk "!seen[\$0]++" | tac)' \
                2>/dev/null)

        if [[ -n "$selected" ]]; then
            LBUFFER="$selected"
            zle end-of-line
            zle redisplay
        fi
        zle reset-prompt
    }

    # Clear history
    fzf_history_clear() {
        echo -n "Clear history? (y/N) "
        read -r answer
        if [[ "$answer" =~ ^[Yy]$ ]]; then
            history -c
            history -w
            echo "History cleared"
        else
            echo "Cancelled"
        fi
    }

    # Aliases
    alias fh='fzf_history_widget'
    alias fha='fzf_history_all'
    alias fhc='fzf_history_clear'
fi

# History navigation
bindkey '^P' up-line-or-beginning-search
bindkey '^N' down-line-or-beginning-search
