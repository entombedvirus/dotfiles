# Only keep unique items in the path array
typeset -U path

path=($HOME/bin
$HOME/.bin
/opt/twitter/bin
/opt/twitter/sbin
/usr/local/mysql/bin
$HOME/.twitools/src/twitter-utilities/sbt
$HOME/.twitools/src/twitter-utilities/sbt11
$HOME/.twitools/src/twitter-utilities/bin
/usr/local/sbin
$HOME/workspace/maven-tools/bin
$path)
