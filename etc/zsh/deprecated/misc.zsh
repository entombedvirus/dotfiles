export HISTSIZE=1000

# function for launching and disowning processes
function run {
  sh -c $@ &
  disown
}
