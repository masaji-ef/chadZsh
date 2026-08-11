# Auto tmux - start tmux automatically in interactive sessions
auto_tmux() {
    if [[ -z "$TMUX" ]] && [[ -z "$SSH_CONNECTION" ]] && [[ -t 0 ]]; then
        if command -v tmux &>/dev/null; then
            tmux attach -t main 2>/dev/null || tmux new -s main
        fi
    fi
}

auto_tmux
