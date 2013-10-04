export HISTSIZE=1000
# enable color support of ls and file hints
if [ "$TERM" != "dumb" ]; then
    alias ls='ls -FG'
    alias grep='grep --color=auto'
fi

# function for launching and disowning processes
function run {
  sh -c $@ &
  disown
}
