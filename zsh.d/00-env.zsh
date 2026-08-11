# Default editor
export EDITOR=vim
export VISUAL=vim

# Pager settings
export PAGER=less
export LESS='-R'
export MANPAGER="less -R --use-color -Dd+r -Du+b"

# Locale
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Terminal
if [[ -n "$TMUX" ]]; then
    export TERM="screen-256color"
else
    export TERM="xterm-256color"
fi

# GPG and browser
export GPG_TTY=$(tty)
export BROWSER=firefox
