# Git aliases
alias g='git'
alias gs='git status'

# Diff
alias gd='git --no-pager diff'
alias gds='git --no-pager diff --staged'
alias gdstat='git diff --stat'
alias gdsstat='git diff --staged --stat'
alias gdword='git --no-pager diff --word-diff'

# Log
alias glog='git log --oneline --graph --decorate'
alias gl='git log'
alias gls='git log --oneline --graph --decorate --stat'
alias glf='git log --oneline --graph --decorate --all'
alias gtree='git log --graph --oneline --decorate --all'

# Branch
alias gb='git branch'
alias gba='git branch -a'
alias gbd='git branch -d'
alias gbD='git branch -D'
alias gbr='git branch -r'
alias gbs='git branch -vv'
alias gbclean='git branch --merged | grep -v "\*" | grep -v main | grep -v develop | xargs -r git branch -d'

# Checkout
alias gco='git checkout'
alias gcob='git checkout -b'
alias gcom='git checkout main'
alias gcod='git checkout develop'
alias gcot='git checkout -t'

# Commit
alias gcmt='git commit -v'
alias gcmta='git commit -v --amend'
alias gcmtan='git commit -v --amend --no-edit'
alias gcm='git commit -m'
alias gcma='git commit -a -m'
alias gcmt!='git commit -v --amend'

# Add
alias ga='git add'
alias gaa='git add -A'
alias gap='git add -p'
alias gau='git add -u'

# Push
alias gps='git push'
alias gpsf='git push --force'
alias gpsu='git push -u origin HEAD'
alias gpsfl='git push --force-with-lease'

# Pull
alias gpl='git pull'
alias gplr='git pull --rebase'
alias gplrb='git pull --rebase'

# Fetch
alias gf='git fetch'
alias gfa='git fetch --all'
alias gtags='git fetch --tags'

# Stash
alias gstash='git stash'
alias gstasha='git stash apply'
alias gstashd='git stash drop'
alias gstashl='git stash list'
alias gstashp='git stash pop'
alias gstashs='git stash save'
alias gstashu='git stash -u'
alias gstashsh='git stash show -p'
alias gstashn='git stash push -m'

# Rebase
alias grb='git rebase'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias grbs='git rebase --skip'
alias grbi='git rebase -i'
alias grim='git rebase -i HEAD~'

# Merge
alias gm='git merge'
alias gma='git merge --abort'
alias gmc='git merge --continue'
alias gmff='git merge --no-ff'
alias gms='git merge --squash'

# Cherry-pick
alias gcp='git cherry-pick'
alias gcpa='git cherry-pick --abort'
alias gcpc='git cherry-pick --continue'
alias gcpb='git cherry-pick -x'

# Reset
alias gr='git reset'
alias grh='git reset --hard'
alias grs='git reset --soft'
alias gus='git reset --soft HEAD~1'
alias gum='git reset HEAD~1'
alias guh='git reset --hard HEAD~1'
alias gundo='git reset --soft HEAD~1'

# Revert
alias grv='git revert'

# Clone
alias gcl='git clone'
alias gclr='git clone --recurse-submodules'
alias gclsh='git clone --depth 1'

# Remote
alias grm='git remote -v'

# Tags
alias gt='git tag'
alias gta='git tag -a'

# Clean
alias gclean='git clean -fd'
alias gcleanx='git clean -fdx'
alias gdiscard='git reset --hard HEAD'
alias gcleanall='git clean -fdx && git reset --hard HEAD'

# Submodule
alias gsu='git submodule update --init --recursive'

# Utilities
alias ghelp='git help'
alias gconfig='git config --list'
alias gglobal='git config --global --list'
alias galias='git config --get-regexp alias'
alias gbranch='git rev-parse --abbrev-ref HEAD'
alias gfiles='git ls-files'
alias gutracked='git ls-files --others --exclude-standard'
alias gignored='git ls-files --others --ignored --exclude-standard'
alias gignore='git ls-files --others --ignored --exclude-standard'
alias gsp='git status --porcelain'
alias gmod='git diff --name-only'
alias gchanged='git diff --name-status'
alias gshow='git show'
alias glast='git diff HEAD~1 HEAD --name-status'
alias gnew='git log origin/main..HEAD --oneline'
alias gcurrent='git rev-parse --abbrev-ref HEAD'
alias gdmerge='git diff $(git merge-base HEAD origin/main)..HEAD'

# Functions
gblame() {
    git blame "$1" | fzf --height 40% --reverse
}
alias gbl='gblame'

gfixmsg() {
    git commit --amend -m "$*"
}
alias gfm='gfixmsg'

alias gunstage='git restore --staged'
alias gdiscardfile='git restore'

gbrdel() {
    git push origin --delete "$1"
}
alias gbrd='gbrdel'

gshown() {
    git show HEAD~"$1"..HEAD
}
alias gsh='gshown'

alias gstashpd='git stash pop && git stash drop'

gcofile() {
    git checkout "$1" -- "$2"
}

gmovenew() {
    git checkout -b "$1" && git cherry-pick HEAD@{1} && git branch -f main HEAD@{2}
}
alias gmn='gmovenew'

gsyncf() {
    local branch=$(git rev-parse --abbrev-ref HEAD)
    git pull --rebase origin $branch && git push origin $branch
}

gsquash() {
    if [[ -z "$1" ]]; then
        echo "Usage: gsquash <N>"
        return 1
    fi
    git reset --soft HEAD~$1 && git commit -m "Squash $1 commits"
}
alias gsq='gsquash'

# Power commands
gacpm() {
    git add -A && git commit -m "$*" && git push
}
alias gacp='gacpm'

gacpdate() {
    git add -A && git commit -m "Update $(date '+%Y-%m-%d %H:%M')" && git push
}
alias gacpd='gacpdate'

alias gac='git add -A && git commit -m'
alias gcp='git add -A && git commit -m "$*" && git push'
alias gacpa='git add -A && git commit --amend --no-edit && git push --force'
alias gaf='git add -A && git commit --amend --no-edit && git push --force-with-lease'
alias gcap='git add -A && git commit --amend --no-edit && git push --force'
alias gacps='git add -A && git commit -m && git push -u origin HEAD'
alias gacpp='git add -A && git commit -m && git pull && git push'
alias gpacp='git pull && git add -A && git commit -m && git push'
alias gsl='git status && git log --oneline -5'
alias gacm='git add -A && git commit -m'
