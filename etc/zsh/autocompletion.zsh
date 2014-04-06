# The following lines were added by compinstall

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' matcher-list '' '+m:{a-z}={A-Z}' 'r:|[._-]=** r:|=**' 'l:|=* r:|=*'
zstyle ':completion:*' max-errors 1
zstyle :compinstall filename "$HOME/.zsh/autocompletion.zsh"

autoload -Uz compinit
compinit
# End of lines added by compinstall

zstyle ':completion:*' menu select

# disable git checkout completion cuz its super slow
compdef -d git checkout
