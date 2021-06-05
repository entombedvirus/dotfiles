export CLICOLOR=yes
export EDITOR="nvim"

export PATH=/opt/local/bin:$PATH
export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/sbin:$PATH
export PATH=/usr/local/mysql/bin:$PATH

export PATH=~/bin:$PATH
export PATH=$HOME/.linuxbrew/bin:$PATH
export PATH=/home/linuxbrew/.linuxbrew/bin:$PATH

export PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

function source_if_exists {
    file=$1
    [ -f "$file" ] && source "$file"
}

source_if_exists "$HOME/.host.$(hostname | xargs echo -n).zshenv"
export PATH=~/analytics/go/bin:$PATH
. "$HOME/.cargo/env"
