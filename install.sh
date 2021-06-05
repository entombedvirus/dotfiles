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
        echo 'export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"' >>~/.zshenv
        echo 'export MANPATH="/home/linuxbrew/.linuxbrew/share/man:$MANPATH"' >>~/.zshenv
        echo 'export INFOPATH="/home/linuxbrew/.linuxbrew/share/info:$INFOPATH"' >>~/.zshenv
    ;;
esac

brew install zsh ctags-exuberant global ripgrep ruby neovim fzf tmux jq bat nodejs llvm efm-langserver

# source code tagging
# brew tap universal-ctags/universal-ctags
# brew install --HEAD universal-ctags
# brew install global

LEMONADE_PATH=${HOME}/.bin/lemonade
if [ ! -e "$LEMONADE_PATH" ]; then
    mkdir -p $(dirname "$LEMONADE_PATH")
    curl --silent -L https://github.com/entombedvirus/lemonade/releases/download/v1.1.1-7-g2cc49d8/lemonade_linux_amd64.tar.gz | tar -xz -C $(dirname $LEMONADE_PATH)
    chmod 755 "$LEMONADE_PATH"
fi

NVIM_INIT_PATH="${HOME}/.config/nvim/init.vim"
if [ ! -L "$NVIM_INIT_PATH" ]; then
    mkdir -p $(dirname $NVIM_INIT_PATH)
    rm -f "$NVIM_INIT_PATH"
    ln -snf $HOME/.vimrc $NVIM_INIT_PATH
fi

#brew install python3
pip3 install neovim python-language-server pyls-black
# needed for various language servers
npm install --global typescript typescript-language-server vim-language-server \
    bash-language-server vscode-html-languageserver-bin vscode-json-languageserver \
    vls vscode-css-languageserver-bin

# unlink gcc and friends so that they don't interfere with bazel builds
#brew unlink gcc 2>/dev/null || true
#brew unlink binutils 2>/dev/null || true
#brew unlink glibc 2>/dev/null || true
#
## libjemalloc (dep of neovim) needs to find gcc-5 even after the unlink above
#file_to_patch=/home/linuxbrew/.linuxbrew/Cellar/jemalloc/5.1.0/lib/libjemalloc.so.2
#if [ -f "$file_to_patch" ]; then
#    chmod 755 "$file_to_patch"
#    patchelf --set-rpath '/home/linuxbrew/.linuxbrew/Cellar/jemalloc/5.1.0/lib/tls/x86_64:/home/linuxbrew/.linuxbrew/Cellar/jemalloc/5.1.0/lib/tls:/home/linuxbrew/.linuxbrew/Cellar/jemalloc/5.1.0/lib/x86_64:/home/linuxbrew/.linuxbrew/Cellar/jemalloc/5.1.0/lib:/home/linuxbrew/.linuxbrew/lib:/home/linuxbrew/.linuxbrew/Cellar/gcc/5.5.0_4/lib' $file_to_patch
#    chmod 555 "$file_to_patch"
#fi

# add zsh to list of known shells
zsh_path=$(command -v zsh)
if [ -n "$zsh_path" ]; then
    if ! grep -q "$zsh_path" /etc/shells; then
        echo "adding zsh to /etc/shells"
        echo $zsh_path | sudo tee -a /etc/shells >/dev/null
        echo "changing $USER shell to $zsh_path"
        sudo chsh --shell "$zsh_path" $USER
    fi
fi

# custom TERMs
for src in etc/terminfo/*.src; do tic -x -o etc/terminfo $src; done

# install rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

echo "logout and log back in and run linkify"
