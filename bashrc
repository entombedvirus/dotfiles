TERMINFO=$HOME/lib/terminfo
export TERMINFO

source ~/.git-completion.bash

alias ls="gls --color=tty -F"
alias ll="gls --color=tty -Fl"
alias rscreen="screen -c ~/.screen/rails.screen"
alias erscreen="screen -c ~/.screen/er.screen"
alias mysqlroot="mysql -u root"
alias mysql_start='mysqld_safe &'
alias billr="ssh serenity -L3303:localhost:80 -l rravi"
alias pgrep="ps ax | grep"

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


# Spectre
alias specdom0='ssh -C specdom0'
alias shazbot='ssh -C shazbot -l shazbot'
alias rea='ssh -C rea'

alias sync_music="rsync -av --rsh=ssh --delete ~/Music/iTunes serenity:~/"

# Causes the window title to be set to last active process
#trap 'printf "\033]0;  `history 1 | cut -b8-`  \007"' DEBUG

# really awesome function, use: cdgem <gem name>, cd's into your gems directory and opens gem that best matches the gem name provided
function cdgem {
  gem_path=$(gem which $1 2>/dev/null | grep '^/') 
  if [ -e $gem_path ]
  then
    cd $(basename $gem_path)
  else
    print 'not found'
  fi
}

# http://blog.macromates.com/2008/working-with-history-in-bash/#more-189
export HISTCONTROL=erasedups
export HISTSIZE=10000
shopt -s histappend

export EDITOR="vim"
export EVENT_NOKQUEUE=1
export PATH="/Users/rohith/.bin:/opt/local/bin:/opt/local/sbin:/usr/local/bin:/usr/local/sbin:/usr/local/mysql/bin:$PATH"
#test -r /sw/bin/init.sh && . /sw/bin/init.sh
if [ `whoami` = 'root' ]; then
	export PS1='\[\033[01;31m\]\u@\h\[\033[01;34m\] \w \[\033[01;32m\]$(__git_ps1 "(%s) ")\[\033[01;34m\]\$\[\033[00m\]\n→ '
else
	export PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \[\033[01;32m\]$(__git_ps1 "(%s) ")\[\033[01;34m\]\$\[\033[00m\]\n→ '
fi
#bind '"\t":menu-complete'

if [ -f /opt/local/etc/bash_completion ]; then
  . /opt/local/etc/bash_completion
fi
