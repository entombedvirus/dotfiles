HISTFILE=~/.history
HISTSIZE=100
SAVEHIST=$HISTSIZE

setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
# this causes history corruption as of zsh 5.0.2 (x86_64-pc-linux-gnu)
# setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY
