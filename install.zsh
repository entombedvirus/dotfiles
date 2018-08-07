#!/bin/zsh

# vim: set ft=zsh

set -o errexit
set -o pipefail
set -o nounset

# install linux brew deps
sudo apt-get install build-essential curl file git

if ! command -v brew >/dev/null 2>&1; then
    # Install linuxbrew
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
fi

brew install fzf ctags-exuberant global the_silver_searcher

# source code tagging
# brew tap universal-ctags/universal-ctags
# brew install --HEAD universal-ctags
# brew install global

if [ ! -d ${HOME}/.antigen ]; then
    git clone git@github.com:zsh-users/antigen.git ${HOME}/.antigen
fi

LEMONADE_PATH=${HOME}/.bin/lemonade
if [ ! -e "$LEMONADE_PATH" ]; then
    mkdir -p $(dirname "$LEMONADE_PATH")
    curl --silent -L https://github.com/pocke/lemonade/releases/download/v1.1.1/lemonade_linux_amd64.tar.gz | tar -xz -C $(dirname $LEMONADE_PATH)
    chmod 755 "$LEMONADE_PATH"
fi
