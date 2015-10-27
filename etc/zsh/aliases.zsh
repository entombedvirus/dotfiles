# enable color support of ls and also add handy aliases
if hash dircolors 2>/dev/null; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias ll='ls -la --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

alias eprofile='subl --new-window --wait ~/.zshrc && source ~/.zshrc'

# Git Aliases
alias gst='git status'
alias gl='git pull'
alias gp='git push'
alias gd='git diff HEAD | subl --new-window'
alias gc='git commit -v'
alias gca='git commit -v -a'
alias gb='git branch'
alias gba='git branch -a'
alias ga='git add .'
alias ddd="gst | grep deleted | awk '{print \$3}' | xargs -I{} git rm {}"

alias gs="echo NOT GHOST SCRIPT!!1"

alias lines-by-author='find . -type f \( -name "*.scala" -and -not -ipath "*scrooge*" -and -not -ipath "*plugins*" \)  -exec git blame -f {} \; |cawk 3|sed s/\(//g|grep -v Not| sort |uniq -c|sort -n'

function irb() {
  echo "using pry instead"
  pry
}

function gcb {
  branch=$1
  count=`gb | grep $1  | wc -l`
  if [[ $count -ge 2 ]]; then
    echo "too many branches with $branch in the name:"
    gb | grep $1
    return
  fi

  if [[ $count -eq 1 ]]; then
    git co `gb | grep $1`
  else
    echo "no branches with $branch in the name"
  fi
}

function mvn-install {
  mvn -am -pl :$1 -Dmaven.test.skip install
}

function metrics {
  service=${1}
  role=${2:-$service}
  dc=${3:-smf1}
  ssh nest1.corp.twitter.com "cql2 --zone $dc keys $service audubon.role.$role"
}

alias mvn="mvn -Pzinc"
alias zinc-start='zinc -start -S"-JXmx=4G"'
