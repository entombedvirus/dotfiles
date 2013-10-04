
function gemdir {
  gems_dir=`gem env gemdir`/gems
  echo $gems_dir/`ls $gems_dir|grep $1|sort|tail -1`
}

function cdgem {
  cd `gemdir $1`
}

function ogem {
  local gems_dir
  gems_dir=`gem env gemdir`/gems
  gem_dir=$gems_dir/`ls $gems_dir|grep $1|sort|tail -1`
  mvim $gem_dir -c "cd $gem_dir"
}


# include rvm
[[ -s "/opt/twitter/rvm/scripts/rvm" ]] && source "/opt/twitter/rvm/scripts/rvm"  # This loads RVM into a shell session.

