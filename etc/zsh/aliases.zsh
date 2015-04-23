alias ls="ls -G"
alias ll='ls -al'
alias grep="grep --color=auto"

alias twitter='cd ~/workspace/twitter'
alias t='cd ~/workspace/twitter'
alias eprofile='subl --new-window --wait ~/.zshrc && source ~/.zshrc'

alias birdcage='cd ~/workspace/source/birdcage'
alias science='cd ~/workspace/source/science'

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

# pants
function notify() {
  terminal-notifier -message "$1"
}

function pc() {
  ./pants compile $@
  notify "compile done"
}

function pt() {
  ./pants test $1
  notify "test done"
}

function pb() {
  ./pants bundle $1 --bundle-archive=zip
  notify "bundle done"
}

function pca() {
  ./pants clean-all
  notify "clean-all done"
}

function nest1() {
  local loginAs=${1:=$USER}
  ssh nest.smfc.twitter.com -l $loginAs
}

function nest2() {
  local loginAs=${1:=$USER}
  ssh nest.atlc.twitter.com -l $loginAs
}

