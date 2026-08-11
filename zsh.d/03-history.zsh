# History settings
HISTSIZE=50000
SAVEHIST=100000
HISTFILE=~/.zsh_history

# History options
setopt HIST_IGNORE_ALL_DUPS      # Remove duplicates
setopt HIST_IGNORE_SPACE         # Ignore commands with space
setopt HIST_REDUCE_BLANKS        # Remove extra blanks
setopt HIST_VERIFY               # Show command before running
setopt INC_APPEND_HISTORY        # Add immediately
setopt SHARE_HISTORY             # Share between sessions
setopt EXTENDED_HISTORY          # Add timestamps
setopt HIST_SAVE_NO_DUPS         # Don't save duplicates
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicates first

# Set history file permissions
if [[ -f "$HISTFILE" ]]; then
    current_perms=$(stat -c '%a' "$HISTFILE" 2>/dev/null || stat -f '%Lp' "$HISTFILE" 2>/dev/null)
    if [[ "$current_perms" != "600" ]]; then
        chmod 600 "$HISTFILE" &>/dev/null
    fi
fi

# FZF history search widget
if command -v fzf &>/dev/null; then
    fzf_history_widget() {
        local selected num
        setopt localoptions noglobsubst noposixbuiltins pipefail 2>/dev/null

        # Search history, remove duplicates
        selected=$(fc -l 1 2>/dev/null | \
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
                --preview='echo {2..}' \
                --preview-window='down:3:wrap' \
                --bind='tab:down,shift-tab:up' \
                --bind='ctrl-r:toggle-sort' \
                --bind='ctrl-y:execute(echo -n {2..} | wl-copy 2>/dev/null || echo -n {2..} | xclip -selection clipboard 2>/dev/null)' \
                2>/dev/null)

        # Insert selected command
        if [[ -n "$selected" ]]; then
            num=$(echo "$selected" | awk '{print $1}')
            if [[ -n "$num" ]]; then
                LBUFFER=$(fc -l $num $num 2>/dev/null | sed 's/^[ ]*[0-9]*[ ]*//')
                zle redisplay
            fi
        fi
        zle reset-prompt
    }

    zle -N fzf_history_widget
    bindkey '^R' fzf_history_widget

    # Show all history with fzf
    fzf_history_all() {
        fc -l 1 2>/dev/null | \
            awk '!seen[$0]++' | \
            fzf --tac --no-sort --exact \
                --height=60% \
                --reverse \
                --border \
                --prompt="All history> " \
                --preview='echo {2..}' \
                --preview-window='down:3:wrap' \
                --bind='tab:down,shift-tab:up' \
                --bind='ctrl-r:reload(fc -l 1 | awk "!seen[\$0]++" | tac)' \
                --bind='ctrl-y:execute(echo -n {2..} | wl-copy 2>/dev/null || echo -n {2..} | xclip -selection clipboard 2>/dev/null)' \
                2>/dev/null
    }

    # Search history by date
    fzf_history_date() {
        local date_pattern=$(date '+%Y-%m-%d')
        fc -l 1 2>/dev/null | grep "$date_pattern" | \
            fzf --tac --no-sort \
                --height=40% \
                --reverse \
                --border \
                --prompt="History for $date_pattern> " \
                2>/dev/null
    }

    # Clear history with confirmation
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

    # History aliases
    alias fh='fzf_history_widget'
    alias fha='fzf_history_all'
    alias fhd='fzf_history_date'
    alias fhc='fzf_history_clear'
fi

# History navigation
bindkey '^P' up-line-or-beginning-search
bindkey '^N' down-line-or-beginning-search
