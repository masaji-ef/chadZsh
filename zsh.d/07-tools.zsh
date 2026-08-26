# btop - modern system monitor
if command -v btop &>/dev/null; then
  alias top='btop'
  alias htop='btop'
fi

# ripgrep - better grep
if command -v rg &>/dev/null; then
  alias rg='rg'
fi

# eza - better ls
if command -v eza &>/dev/null; then
  alias ls='eza -l -a --group-directories-first --icons --git --time=modified --time-style=long-iso --no-permissions --no-filesize -s=name -g'
  alias tree='eza --tree --icons --git -a'
fi

# zoxide - better cd
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
fi

# fzf configuration (no colors)
if command -v fzf &>/dev/null; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git 2>/dev/null || find . -type f 2>/dev/null'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git 2>/dev/null || find . -type d 2>/dev/null'

  export FZF_DEFAULT_OPTS='
        --height 40%
        --reverse
        --border
        --inline-info
        --prompt "❯ "
        --pointer "▶ "
        --marker "✓ "
    '

  export FZF_CTRL_R_OPTS="
        --height 40%
        --reverse
        --border
        --prompt 'History> '
        --pointer '▶ '
        --no-sort
        --exact
        --tiebreak=index
    "

  fzf_find() {
    fd --type f 2>/dev/null | fzf --height 40% --reverse --preview 'bat --style=header,grid,numbers,changes --color=always {} 2>/dev/null || head -50 {}'
  }

  fzf_cd() {
    cd "$(fd --type d 2>/dev/null | fzf --height 40% --reverse)" 2>/dev/null
  }

  alias f='fzf'
  alias ff='fzf_find'
  alias fcd='fzf_cd'
fi

# bat - better cat
if command -v bat &>/dev/null; then
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
  alias less='bat -p'
  alias more='bat -p'
  export GIT_PAGER="bat -p"
fi

# ncdu - disk usage analyzer
if command -v ncdu &>/dev/null; then
  alias ncdu='ncdu'
fi

# Standard du
alias du='du -h'

# tmux
if command -v tmux &>/dev/null; then
  alias tm='tmux'
  alias tma='tmux attach -t'
  alias tml='tmux list-sessions'
  alias tmk='tmux kill-session -t'
fi

# jq - JSON processor
if command -v jq &>/dev/null; then
  alias jq='jq -C'
  alias json='jq -C .'
fi

# aria2 - download accelerator
if command -v aria2c &>/dev/null; then
  alias get='aria2c -x 16 -s 16 --console-log-level=error'
fi

# docker -> podman
if ! command -v docker &>/dev/null && command -v podman &>/dev/null; then
  alias docker='podman'
fi

# Yazi widget
yazi_widget() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi --cwd-file="$tmp"
  if [[ -f $tmp ]]; then
    local cwd="$(cat -- "$tmp")"
    if [[ -n $cwd ]] && [[ $cwd != "$PWD" ]]; then
      cd -- "$cwd"
    fi
    rm -f -- "$tmp"
  fi
  zle redisplay
}
zle -N yazi_widget
bindkey '^Y' yazi_widget

# git widget
git_widget() {
  zle -I
  echo ""
  local commit_msg
  echo -n "Commit message: "
  read -r commit_msg </dev/tty
  if [[ -n $commit_msg ]]; then
    git add -A && git commit -m "$commit_msg" && git push
  fi
  zle reset-prompt
}
zle -N git_widget
bindkey '^G' git_widget
