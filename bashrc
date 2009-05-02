# Setup some colors to use later in interactive shell or scripts
export COLOR_NC='\e[0m' # No Color
export COLOR_WHITE='\e[1;37m'
export COLOR_BLACK='\e[0;30m'
export COLOR_BLUE='\e[0;34m'
export COLOR_LIGHT_BLUE='\e[1;34m'
export COLOR_GREEN='\e[0;32m'
export COLOR_LIGHT_GREEN='\e[1;32m'
export COLOR_CYAN='\e[0;36m'
export COLOR_LIGHT_CYAN='\e[1;36m'
export COLOR_RED='\e[0;31m'
export COLOR_LIGHT_RED='\e[1;31m'
export COLOR_PURPLE='\e[0;35m'
export COLOR_LIGHT_PURPLE='\e[1;35m'
export COLOR_BROWN='\e[0;33m'
export COLOR_YELLOW='\e[1;33m'
export COLOR_GRAY='\e[1;30m'
export COLOR_LIGHT_GRAY='\e[0;37m'
alias colorslist="set | egrep 'COLOR_\w*'"  # lists all the colors

if [ -f /opt/local/etc/bash_completion ]; then
  . /opt/local/etc/bash_completion
fi
source ~/cl/git-completion.bash

# Aliases
if [ "$OS" = "darwin" ]; then
  alias ls="gls --color=tty -F"
  alias ll="gls --color=tty -Fl"
  alias pgrep="ps ax | grep"

else
  alias ls='ls --color --classify'
  alias ll='ls -l --color --classify'
  alias lla='ls -l --all --color --classify'
fi

alias rscreen="screen -c ~/.screen/rails.screen"
alias mysqlroot="mysql -u root"
alias mysql_start='mysqld_safe &'

#Git Stuff
alias gst='git status'
alias gl='git pull'
alias gp='git push'
alias gd='git diff | mate'
alias gc='git commit -v'
alias gca='git commit -v -a'
alias gb='git branch'
alias gba='git branch -a --color'
alias push?='git cherry -v origin'
alias gitk='gitk --all &'

# http://blog.macromates.com/2008/working-with-history-in-bash/#more-189
export HISTCONTROL=erasedups
export HISTSIZE=10000
shopt -s histappend

export GREP_OPTIONS='--color=auto' GREP_COLOR='1;32'
export CLICOLOR=1 

if [ "$OS" = "darwin" ]; then
  export EDITOR="mate"
  export GIT_EDITOR="mate -w"

else
  export EDITOR="vim"
  export GIT_EDITOR="vim"
fi

# This was for memcached, I think. Renable if shit breaks.
# export EVENT_NOKQUEUE=1

if [ `whoami` = 'root' ]; then
  export PS1="\[${COLOR_LIGHT_RED}\]\u@\h \[${COLOR_BLUE}\]\w \[${COLOR_GREEN}\]$(__git_ps1 "(%s)") \[${COLOR_BLUE}\]\$ \[${COLOR_NC}\]\n→ "

else
  export PS1="\[${COLOR_GRAY}\]\u@\h \[${COLOR_BLUE}\]\w \[${COLOR_GREEN}\]$(__git_ps1 "(%s)") \[${COLOR_BLUE}\]\$ \[${COLOR_NC}\]\n→ "
fi

shopt -s checkwinsize # After each command, checks the windows size and changes lines and columns

# bash completion settings (actually, these are readline settings)
bind "set completion-ignore-case on" # note: bind used instead of sticking these in .inputrc
bind "set bell-style none" # no bell
bind "set show-all-if-ambiguous On" # show list automatically, without double tab

