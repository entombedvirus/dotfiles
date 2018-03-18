# Git Aliases
alias gst='git status'
alias gl='git pull'
alias gp='git push'
alias gd='git diff'
alias gc='git commit -v'
alias gca='git commit -v -a'
alias gb='git branch'
alias gba='git branch -a'
alias ga='git add .'
alias ddd="gst | grep deleted | awk '{print \$3}' | xargs -I{} git rm {}"
alias gdn="git diff --name-only"

# oh-my-zsh git plugin defines an alias that inteferes with this function
unalias gcb 2>/dev/null
function gcb {
    local search=$1
    # desc sort on branches
    git branch --sort=-committerdate \
        | fzf --query "$search" --select-1 --ansi \
        | xargs -I {} git checkout {}
}
