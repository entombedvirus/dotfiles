# My dotfiles

Just a bunch of dotfiles I've collected over the years. The primary purposes of this repository for me is to:

1. keep the setup time of a new machine to under 10 minutes
2. keep multiple machines in sync (home vs office laptop)

By convention, I create a new branch when I join a new company (from the HEAD of the last company I was at) and set it as the repo's main branch in Github. I used to try to keep the master branch clean without company specific aliases etc, but it was not worth it; way better to pay the cost of removing company specific stuff once every few years rather than try to keep separate over several hundred commits.

# My Workflow

This is what I typically run on a brand new machine to get it setup:

1. git clone git@github.com:entombedvirus/dotfiles.git ~/cl # some scripts in the repo assume the ~/cl path
1. cd ~/cl/
1. ./install.sh # this installs all the packages needed for my dev env using homebrew and apt-get
1. ./linkify # this creates symlinks to files inside cl repo. ex: $HOME/.vimrc -> $HOME/cl/vim/.vimrc etc

## Note on automatic symlink creation

The automatic symlink creation is managed by [GNU stow](https://www.gnu.org/software/stow/). In order to use it, you create a directory structure mirroring your home directory inside your dotfiles repo and then call stow. Check out [this article](https://alexpearce.me/2016/02/managing-dotfiles-with-stow/) if you're interested in more details.

# Forking

If you're interested in using this repo as your starting point, please fork it instead of cloning it directly. I make no guarantees on backwards compatibility and often do break things as I find better ways to do things.
