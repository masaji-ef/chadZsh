# btop
if command -v btop &>/dev/null; then
    alias top='btop'
    alias htop='btop'
fi

# ripgrep
if command -v rg &>/dev/null; then
    alias rg='rg'
fi

# fd
if command -v fd &>/dev/null; then
    alias find='fd'
elif command -v fdfind &>/dev/null; then
    alias find='fdfind'
fi

# eza
if command -v eza &>/dev/null; then
    alias ls='eza -l -a --group-directories-first --icons --git --time=modified --time-style=long-iso --no-permissions --no-filesize -s=name -g'
    alias tree='eza --tree --icons --git -a'
fi

# zoxide
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init zsh)"
fi

# fzf, fd, bat, rg
if command -v fzf &>/dev/null; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
    export FZF_DEFAULT_OPTS='--height 40% --reverse --border --inline-info'

    fzf_history() {
        history | rg "$1" | fzf --height 40% --reverse
    }
    fzf_find() {
        fd --type f 2>/dev/null | fzf --height 40% --reverse --preview 'bat --style=header,grid,numbers,changes --color=always {} 2>/dev/null || head -50 {}'
    }
    fzf_cd() {
        cd "$(fd --type d 2>/dev/null | fzf --height 40% --reverse)" 2>/dev/null
    }
    alias f='fzf'
    alias fh='fzf_history'
    alias ff='fzf_find'
    alias fcd='fzf_cd'
fi

# bat for man
if command -v bat &>/dev/null; then
    export MANPAGER="sh -c 'col -bx | bat -l man -p --paging=always'"
    alias less='bat -p'
    alias more='bat -p'
    git config --global core.pager "bat -p" 2>/dev/null
fi

# ncdu
if command -v ncdu &>/dev/null; then
    alias du='ncdu'
else
    alias du='du -h --max-depth=1'
fi

# tmux
if command -v tmux &>/dev/null; then
    alias tm='tmux'
    alias tma='tmux attach -t'
    alias tml='tmux list-sessions'
    alias tmk='tmux kill-session -t'
fi

# jq
if command -v jq &>/dev/null; then
    alias jq='jq -C'
    alias json='jq -C .'
fi

# direnv
if command -v direnv &>/dev/null; then
    eval "$(direnv hook zsh)"
fi

# aria2
if command -v aria2c &>/dev/null; then
    alias wget='aria2c -x 16 -s 16 --console-log-level=error'
fi

# docker -> podman
if ! command -v docker &>/dev/null && command -v podman &>/dev/null; then
    alias docker='podman'
fi
