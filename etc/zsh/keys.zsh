# emacs keys by default
bindkey -e

# Sane delete key
bindkey "\e[3~" delete-char

# up/down arrow keys do history search, space does history completion
bindkey "\e[B" history-search-forward
bindkey "\e[A" history-search-backward

# history completion on space
bindkey " " magic-space

# bash style delete word
autoload -U select-word-style
select-word-style bash
