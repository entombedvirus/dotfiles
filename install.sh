#!/bin/bash

# vim: set ft=bash

set -o errexit
set -o pipefail
set -o nounset

# install linux brew deps
sudo apt-get install build-essential file git python3-pip

git config --global user.email 'rohith.ravi@mixpanel.com'
git config --global user.name 'Rohith Ravi'

git submodule update --init

# linuxbrew's use of curl fails if there is both a /usr/bin/curl and a /usr/local/bin/curl
if [ -e /usr/bin/curl -a ! -L /usr/bin/curl -a -e /usr/local/bin/curl ]; then
    sudo mv /usr/bin/curl /usr/bin/curl.bak
    sudo ln -nsf /usr/local/bin/curl /usr/bin/curl
fi

export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"

if ! command -v brew >/dev/null 2>&1; then
    # Install linuxbrew
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
fi

# these changes will be blown away by linkify
case :$PATH:
in
    *:$HOME/linuxbrew/.linuxbrew/bin:*)
        # do nothing, it's there
    ;;
    *)
        echo 'export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"' >>~/.profile
        echo 'export MANPATH="/home/linuxbrew/.linuxbrew/share/man:$MANPATH"' >>~/.profile
        echo 'export INFOPATH="/home/linuxbrew/.linuxbrew/share/info:$INFOPATH"' >>~/.profile
    ;;
esac

# brew install zsh ctags-exuberant global the_silver_searcher ruby neovim fzf tmux

# source code tagging
# brew tap universal-ctags/universal-ctags
# brew install --HEAD universal-ctags
# brew install global

LEMONADE_PATH=${HOME}/.bin/lemonade
if [ ! -e "$LEMONADE_PATH" ]; then
    mkdir -p $(dirname "$LEMONADE_PATH")
    curl --silent -L https://github.com/pocke/lemonade/releases/download/v1.1.1/lemonade_linux_amd64.tar.gz | tar -xz -C $(dirname $LEMONADE_PATH)
    chmod 755 "$LEMONADE_PATH"
fi

DEIN_HOME=${HOME}/.nvim/bundle/repos/github.com/Shougo
if [ ! -d "$DEIN_HOME" ]; then
    mkdir -p "$DEIN_HOME"
    git clone git@github.com:Shougo/dein.vim.git "${DEIN_HOME}/dein.vim"
fi

NVIM_INIT_PATH="${HOME}/.config/nvim/init.vim"
if [ ! -L "$NVIM_INIT_PATH" ]; then
    mkdir -p $(dirname $NVIM_INIT_PATH)
    rm -f "$NVIM_INIT_PATH"
    ln -snf $HOME/.vimrc $NVIM_INIT_PATH
fi

pip2 install neovim
brew install python3
pip3 install neovim
echo "logout and log back in and run linkify"