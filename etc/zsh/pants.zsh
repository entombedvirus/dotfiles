#
# function pants_root {
#   dir=`pwd`
#
#   while [[ ! -x "$dir/pants" && $dir != "/" ]]; do
#     dir=`dirname $dir`
#   done
#
#   if [[ -x "$dir/pants" ]]; then
#     echo $dir
#   else
#     pwd
#   fi
# }
#
# function pants {
#   root=`pants_root`
#   cwd=`pwd`
#   $root/pants $@
# }

# Shortened ~/workspace/birdcage to just ~birdcage in prompts
birdcage=~/workspace/birdcage
: ~birdcage