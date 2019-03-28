# Ctrl-r history seem to stop at line 1362 when this is enabled
export FZF_TMUX=0

#export FZF_DEFAULT_COMMAND='ag -g ""'
export FZF_DEFAULT_OPTS="--inline-info --exact"
export FZF_DEFAULT_COMMAND='rg --files'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
