export CLICOLOR=yes
export EDITOR="nvim"

# affects GNU sort order
export LC_ALL=en_US.UTF-8
export LANG=en_US

export PATH=/opt/local/bin:$PATH
export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/sbin:$PATH
export PATH=/usr/local/mysql/bin:$PATH

export PATH=~/bin:$PATH
export PATH=~/.bin:$PATH
export PATH=$HOME/.linuxbrew/bin:$PATH
export PATH=/home/linuxbrew/.linuxbrew/bin:$PATH

export PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
export PATH=~/analytics/go/bin:$PATH

function source_if_exists {
    file=$1
    [ -f "$file" ] && source "$file"
}

source_if_exists "$HOME/.host.$(hostname | xargs echo -n).zshenv"
source_if_exists "$HOME/.cargo/env"
