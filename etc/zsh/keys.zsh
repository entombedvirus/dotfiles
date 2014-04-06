# Sane delete key
bindkey "\e[3~" delete-char

# up/down arrow keys do history search, space does history completion
bindkey "\e[B" history-search-forward
bindkey "\e[A" history-search-backward

# history completion on space
bindkey " " magic-space

# bash style delete word
export WORDCHARS=''
#autoload -U select-word-style
#select-word-style bash

# But, make Ctrl W delete arguments not words
function _backward_kill_default_word() {
  WORDCHARS='*?_-.[]~=/&;!#$%^(){}<>' zle backward-kill-word
}
zle -N backward-kill-default-word _backward_kill_default_word
bindkey '^w' backward-kill-default-word
