#!/bin/bash

# vim: set ft=bash

set -o errexit
set -o pipefail
set -o nounset

git config --global user.email 'rohith.ravi@mixpanel.com'
git config --global user.name 'Rohith Ravi'
git submodule update --init

if ! command -v brew >/dev/null 2>&1; then
    # Install linuxbrew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

case $(uname):
in
    Linux:)
        # install linux brew deps
        sudo apt-get install build-essential file git python3-pip
        # packages that are not available via brew
        sudo apt-get install xdg-utils stow

        # linuxbrew's use of curl fails if there is both a /usr/bin/curl and a /usr/local/bin/curl
        if [ -e /usr/bin/curl -a ! -L /usr/bin/curl -a -e /usr/local/bin/curl ]; then
            sudo mv /usr/bin/curl /usr/bin/curl.bak
            sudo ln -nsf /usr/local/bin/curl /usr/bin/curl
        fi

        export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
        LEMONADE_ARTIFACT=lemonade_linux_amd64.tar.gz
    ;;

    Darwin:)
        export PATH="/usr/local/bin:$PATH"
        LEMONADE_ARTIFACT=lemonade_darwin_amd64.tar.gz
    ;;

    *:)
        echo "unrecognized uname: $(uname). exiting" 1>&2
        exit 1
    ;;
esac

brew bundle install --file homebrew/$(uname).Brewfile

LEMONADE_PATH=${HOME}/.bin/lemonade
if [ ! -e "$LEMONADE_PATH" ]; then
    mkdir -p $(dirname "$LEMONADE_PATH")
    curl --silent -L https://github.com/entombedvirus/lemonade/releases/download/v1.1.2-3-e78beb2/$LEMONADE_ARTIFACT | tar -xz -C $(dirname $LEMONADE_PATH)
    chmod 755 "$LEMONADE_PATH"
fi

pip3 install --user neovim

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
        sudo chsh -s "$zsh_path" $USER
    fi
fi

# custom TERMs
for src in zsh/.terminfo/*.{terminfo,src}; do tic -x -o zsh/.terminfo $src; done

# install rust
rustup-init

echo "logout and log back in and run linkify"
