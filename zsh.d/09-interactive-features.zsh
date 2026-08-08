fzf_history_widget() {
    local selected
    selected=$(fc -l 1 | fzf --height=40% --reverse --no-sort --query="$LBUFFER")
    if [[ -n "$selected" ]]; then
        LBUFFER=$(echo "$selected" | sed 's/^[ ]*[0-9]*[ ]*//')
        zle redisplay
    fi
}
zle -N fzf_history_widget
bindkey '^R' fzf_history_widget

yazi_widget() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    yazi --cwd-file="$tmp"
    if [[ -f "$tmp" ]]; then
        local cwd="$(cat -- "$tmp")"
        if [[ -n "$cwd" ]] && [[ "$cwd" != "$PWD" ]]; then
            cd -- "$cwd"
        fi
        rm -f -- "$tmp"
    fi
    zle redisplay
}
zle -N yazi_widget
bindkey '^Y' yazi_widget

auto_tmux() {
    if [[ -z "$TMUX" ]] && [[ -z "$SSH_CONNECTION" ]] && [[ -t 0 ]]; then
        if command -v tmux &>/dev/null; then
            tmux attach -t main 2>/dev/null || tmux new -s main
        fi
    fi
}
