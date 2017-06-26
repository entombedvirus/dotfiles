#!/bin/zsh

# vim: set ft=zsh

set -o errexit
set -o pipefail
set -o nounset

if [ ! -d ${HOME}/.antigen ]; then
    git clone git@github.com:zsh-users/antigen.git ${HOME}/.antigen
fi

if ! command -v brew >/dev/null 2>&1; then
    # Install linuxbrew
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install)"
fi

brew install go fzf ctags-exuberant autossh the_silver_searcher

# source code tagging
brew tap universal-ctags/universal-ctags
brew install --HEAD universal-ctags
brew install global

export GOPATH=${HOME}/work/go
mkdir -p ${GOPATH}

LEMONADE_PATH=${GOPATH}/bin/lemonade
if [ ! -e "$LEMONADE_PATH" ]; then
    go get -d github.com/pocke/lemonade
    make -C $GOPATH/src/github.com/pocke/lemonade install
fi
