# BEGIN flag as new block
source ~/.gcpdevbox
# END flag as new block
# Setup some colors to use later in interactive shell or scripts
export COLOR_NC='\033[0m' # No Color
export COLOR_WHITE='\033[1;37m'
export COLOR_BLACK='\033[0;30m'
export COLOR_BLUE='\033[0;34m'
export COLOR_LIGHT_BLUE='\033[1;34m'
export COLOR_GREEN='\033[0;32m'
export COLOR_LIGHT_GREEN='\033[1;32m'
export COLOR_CYAN='\033[0;36m'
export COLOR_LIGHT_CYAN='\033[1;36m'
export COLOR_RED='\033[0;31m'
export COLOR_LIGHT_RED='\033[1;31m'
export COLOR_PURPLE='\033[0;35m'
export COLOR_LIGHT_PURPLE='\033[1;35m'
export COLOR_BROWN='\033[0;33m'
export COLOR_YELLOW='\033[1;33m'
export COLOR_GRAY='\033[1;30m'
export COLOR_LIGHT_GRAY='\033[0;37m'
alias colorslist="set | egrep 'COLOR_\w*'"  # lists all the colors

if [ -f /opt/local/etc/bash_completion ]; then
  . /opt/local/etc/bash_completion
fi

# Aliases
if [ "$OS" = "darwin" ]; then
  alias ls="gls --color=tty -F"
  alias ll="gls --color=tty -Fl"
  alias lla='ll -a'

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
alias glr='git pull --rebase'
alias gp='git push'
alias gd='git diff | mvim -'
alias gdc='git diff --cached | mvim -'
alias gc='git commit -v'
alias gca='git commit -v -a'
alias gb='git branch'
alias gba='git branch -a --color'
alias push?='git cherry -v origin'
alias gitk='gitk --all &'

#if [ "$OS" = "darwin" ]; then
  #alias ops='ssh -t ops.sea -l rohith screen -U'
#fi
# http://blog.macromates.com/2008/working-with-history-in-bash/#more-189
export HISTCONTROL=erasedups
export HISTSIZE=10000
shopt -s histappend

export CLICOLOR=1

if [ "$OS" = "darwin" ]; then
  export EDITOR="mvim"
  export GIT_EDITOR="mvim -f"

else
  export EDITOR="vim"
  export GIT_EDITOR="vim"
fi

# This was for memcached, I think. Renable if shit breaks.
# export EVENT_NOKQUEUE=1

if [ `whoami` = 'root' ]; then
  export PS1="\[${COLOR_LIGHT_RED}\]\u@\h \[${COLOR_BLUE}\]\w \[${COLOR_GREEN}\]\$(__git_ps1 '(%s)') \[${COLOR_BLUE}\]\$ \[${COLOR_NC}\]\n→ "

else
  export PS1="\[${COLOR_GRAY}\]\u@\h \[${COLOR_BLUE}\]\w \[${COLOR_GREEN}\]\$(__git_ps1 '(%s)') \[${COLOR_BLUE}\]\$ \[${COLOR_NC}\]\n→ "
fi

export SUDO_PS1="\[${COLOR_LIGHT_RED}\]\u@\h \[${COLOR_BLUE}\]\w\$ \[${COLOR_NC}\]\n→ "

shopt -s checkwinsize # After each command, checks the windows size and changes lines and columns

# bash completion settings (actually, these are readline settings)
# bind "set completion-ignore-case on" # note: bind used instead of sticking these in .inputrc
# bind "set bell-style none" # no bell
# bind "set show-all-if-ambiguous On" # show list automatically, without double tab

export NODE_PATH='/usr/local/lib/node_modules'

# function to copy ssh keys to new machines
function copy_keys {
  if [[ -z "$1" ]]; then
    echo "Usage: $0 <host> <key>";
  else
    echo "Copying Key";
    ssh ${1} "mkdir -p ~/.ssh && cat - >> ~/.ssh/authorized_keys" < $2;
    echo "Done!"
  fi
}

# For Maven
export MAVEN_OPTS="-Xmx512m"

# Set tmux window title
ssh() {
  if [[ "$TERM" =~ ^screen ]]; then
    tmux rename-window "$1"
    command /usr/bin/env TERM=screen ssh "$@"
    tmux rename-window "`hostname -s`"
  else
    command ssh "$@"
  fi
}

# For tmuxinator
[[ -s $HOME/.tmuxinator/scripts/tmuxinator ]] && source $HOME/.tmuxinator/scripts/tmuxinator
source $HOME/analytics/.shellenv

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
. "$HOME/.cargo/env"
