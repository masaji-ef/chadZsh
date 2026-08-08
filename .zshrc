[ -z "$PS1" ] && return
for file in ~/.zsh.d/*.zsh; do
    [[ -r "$file" ]] && source "$file"
done
auto_tmux
