export CLICOLOR=yes
export EDITOR="nvim"

# affects GNU sort order
export LC_ALL=en_US.UTF-8
export LANG=en_US

export PATH=/opt/local/bin:$PATH
export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/sbin:$PATH

export PATH=~/bin:$PATH
export PATH=~/.bin:$PATH

function source_if_exists {
    file=$1
    [ -f "$file" ] && source "$file"
}

source_if_exists "$HOME/.host.$(uname).zshenv"
source_if_exists "$HOME/.cargo/env"
# hide tokens and such from version control
source_if_exists "$HOME/.secrets.env"
