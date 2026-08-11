# VCS info for git prompt
setopt PROMPT_SUBST
autoload -Uz vcs_info

# Git settings
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true

# Git prompt formats - только числа, без имён файлов
zstyle ':vcs_info:git:*' formats ' %F{green}%b%f %F{blue}%i%f%F{yellow}%c%u%f%F{magenta}%m%f%F{cyan}%a%f%F{red}%S%f'
zstyle ':vcs_info:git:*' actionformats ' %F{red}%b%f %F{yellow}|%f %F{cyan}%a%f%F{yellow}%c%u%f%F{magenta}%m%f%F{red}%S%f'

# Git hooks - только счётчики, без имён
zstyle ':vcs_info:git*+set-message:*' hooks git-staged git-unstaged git-untracked git-stash git-aheadbehind

# Count staged files
+vi-git-staged() {
    local staged=$(git diff --cached --name-only 2>/dev/null | wc -l)
    if [[ $staged -gt 0 ]]; then
        hook_com[staged]="+${staged}"
    else
        hook_com[staged]=""
    fi
}

# Count unstaged files
+vi-git-unstaged() {
    local unstaged=$(git diff --name-only 2>/dev/null | wc -l)
    if [[ $unstaged -gt 0 ]]; then
        hook_com[unstaged]="~${unstaged}"
    else
        hook_com[unstaged]=""
    fi
}

# Count untracked files
+vi-git-untracked() {
    local untracked=$(git status --porcelain 2>/dev/null | grep -c '??')
    if [[ $untracked -gt 0 ]]; then
        hook_com[untracked]="?${untracked}"
    else
        hook_com[untracked]=""
    fi
}

# Count ahead/behind commits
+vi-git-aheadbehind() {
    local ahead behind
    ahead=$(git rev-list --count @{upstream}..HEAD 2>/dev/null)
    behind=$(git rev-list --count HEAD..@{upstream} 2>/dev/null)
    if [[ -n "$ahead" && "$ahead" -gt 0 ]]; then
        hook_com[staged]+=" ↑${ahead}"
    fi
    if [[ -n "$behind" && "$behind" -gt 0 ]]; then
        hook_com[staged]+=" ↓${behind}"
    fi
}

# Count stash entries
+vi-git-stash() {
    local stash_count=$(git stash list 2>/dev/null | wc -l)
    if [[ $stash_count -gt 0 ]]; then
        hook_com[staged]+=" ⚑${stash_count}"
    fi
}

# Precmd function - runs before each prompt
precmd() {
    export GPG_TTY=$(tty)

    local exit_code=$?

    local left_info="%F{blue}%*%f"

    if [[ -n "$TMUX" ]]; then
        left_info+=" %F{magenta}tmux%f"
    fi

    if [[ -n "$VIRTUAL_ENV" ]]; then
        left_info+=" %F{green}🐍 $(basename $VIRTUAL_ENV)%f"
    fi

    if [[ -n "$SSH_CONNECTION" ]]; then
        left_info+=" %F{red}SSH%f"
    fi

    PROMPT_LEFT_INFO="$left_info"

    RPROMPT=""
    if [[ $exit_code -ne 0 ]]; then
        RPROMPT+=" %F{red}✘%f"
    fi

    vcs_info
}

# Color definitions
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

# Short path (last 2 directories)
PROMPT=$'\n'"\${PROMPT_LEFT_INFO} ${BOLD}${USER_COLOR}%n${RESET}@${BLUE}%m${RESET}:${YELLOW}%2~${RESET}"'${vcs_info_msg_0_}'$'\n'"%F{cyan}${PROMPT_SYMBOL}%f "
