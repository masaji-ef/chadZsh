setopt PROMPT_SUBST
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:git:*' formats ' %F{green}%b%f %F{blue}%i%f%F{yellow}%c%u%f%F{magenta}%m%f%F{cyan}%a%f%F{red}%S%f'
zstyle ':vcs_info:git:*' actionformats ' %F{red}%b%f %F{yellow}|%f %F{cyan}%a%f%F{yellow}%c%u%f%F{magenta}%m%f%F{red}%S%f'
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked git-stash git-aheadbehind git-staged git-unstaged
+vi-git-staged() {
    local staged=$(git diff --cached --name-only 2>/dev/null | wc -l)
    if [[ $staged -gt 0 ]]; then
        hook_com[staged]=" staged:${staged}"
    else
        hook_com[staged]=""
    fi
}
+vi-git-unstaged() {
    local unstaged=$(git diff --name-only 2>/dev/null | wc -l)
    if [[ $unstaged -gt 0 ]]; then
        hook_com[unstaged]=" unstaged:${unstaged}"
    else
        hook_com[unstaged]=""
    fi
}
+vi-git-untracked() {
    local untracked=$(git status --porcelain 2>/dev/null | grep -c '??')
    if [[ $untracked -gt 0 ]]; then
        hook_com[untracked]=" untracked:${untracked}"
    else
        hook_com[untracked]=""
    fi
}
+vi-git-aheadbehind() {
    local ahead behind
    local -a gitstatus
    ahead=$(git rev-list --count @{upstream}..HEAD 2>/dev/null)
    behind=$(git rev-list --count HEAD..@{upstream} 2>/dev/null)
    if [[ -n "$ahead" && "$ahead" -gt 0 ]]; then
        gitstatus+=("ahead:${ahead}")
    fi
    if [[ -n "$behind" && "$behind" -gt 0 ]]; then
        gitstatus+=("behind:${behind}")
    fi
    if [[ ${#gitstatus} -gt 0 ]]; then
        hook_com[staged]+=" ${(j: :)gitstatus}"
    fi
}
+vi-git-stash() {
    local stash_count=$(git stash list 2>/dev/null | wc -l)
    if [[ $stash_count -gt 0 ]]; then
        hook_com[staged]+=" stash:${stash_count}"
    fi
}
precmd() {
    local exit_code=$?
    RPROMPT=""
    if [[ $exit_code -ne 0 ]]; then
        RPROMPT+=" %F{red}✘%f"
    fi
    RPROMPT+=" %F{blue}%*%f"
    if [[ -n "$VIRTUAL_ENV" ]]; then
        RPROMPT+=" %F{green}🐍 $(basename $VIRTUAL_ENV)%f"
    fi
    if [[ -n "$TMUX" ]]; then
        RPROMPT+=" %F{magenta}tmux%f"
    fi
    if [[ -n "$SSH_CONNECTION" ]]; then
        RPROMPT+=" %F{red}SSH%f"
    fi
    vcs_info
}
GREEN='%F{green}'
BLUE='%F{blue}'
YELLOW='%F{yellow}'
RED='%F{red}'
MAGENTA='%F{magenta}'
CYAN='%F{cyan}'
RESET='%f'
BOLD='%B'
if [[ $UID -eq 0 ]]; then
    USER_COLOR=$RED
    PROMPT_SYMBOL="#"
else
    USER_COLOR=$GREEN
    PROMPT_SYMBOL="❯"
fi
PROMPT=$'\n'"${BOLD}${USER_COLOR}%n${RESET}@${BLUE}%m${RESET}:${YELLOW}%~${RESET}"'${vcs_info_msg_0_}'$'\n'"%F{cyan}${PROMPT_SYMBOL}%f "

