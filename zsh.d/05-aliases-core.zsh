# File operations with safety
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -iv'
alias rmdir='rmdir -v'
alias mkdir='mkdir -pv'
alias ln='ln -iv'
alias chmod='chmod -v'
alias chown='chown -v'
alias chgrp='chgrp -v'

# Navigation shortcuts
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ~='cd ~'
alias cd..='cd ..'
alias cd...='cd ../..'
alias cd....='cd ../../..'
alias cd.....='cd ../../../..'
alias cd~='cd ~'

# Common commands
alias c='clear'
alias cls='clear'
alias src='source ~/.zshrc'
alias zc='source ~/.zshrc'
alias vi='vim'
alias s='sudo'
alias nv='nvim'
alias v='vim'
alias e='exit'
alias q='exit'
alias sl='ls'

# Listing
alias ll='ls -l'
alias la='ls -a'
alias l='ls'
alias sl='ls'

# System monitoring
alias df='df -hT'
alias free='free -h'
alias ps='ps auxf'
alias ss='ss -tulpn'
alias ping='ping -c 5'
alias ping6='ping6 -c 5'
alias netstat='ss -tulpn'
alias ifconfig='ip -c a'
alias route='ip -c r'
alias mount='mount | column -t'

# Process management
alias killall='killall -v'
alias pkill='pkill -f'
alias pgrep='pgrep -af'

# Networking and remote
alias rsync='rsync -avh'
alias scp='scp -v'
alias ssh='ssh -v'

# Utilities
alias diff='diff -u'
alias logs='tail -f /var/log/messages'
alias seelogs='less /var/log/messages'
alias load='uptime && free -h && df -h /'
alias histclear='history -c && history -w'
alias hist10='history 10'
alias lsblk='lsblk -f'

# Grep with color
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias psg='ps aux | grep'

# History
alias history='history 0'
alias h='history'

# Sudo with env preservation
alias sudo='sudo -E'

# Global aliases for piping
alias -g L='| less'
alias -g G='| grep --color=auto'
alias -g H='| head'
alias -g T='| tail'
alias -g NUL='> /dev/null 2>&1'
