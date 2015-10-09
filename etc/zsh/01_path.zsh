# Only keep unique items in the path array
typeset -U path

export GOPATH=/Users/rravi/workspace/gocode

path=($HOME/bin
$HOME/.bin
$GOPATH/bin
#$HOME/Python/CPython-2.6.9/bin
$HOME/Python/CPython-2.7.10/bin
#$HOME/Python/CPython-3.3.6/bin
#$HOME/Python/CPython-3.4.3/bin
$HOME/Python/PyPy-2.6.0/bin
/opt/twitter/bin
/opt/twitter/sbin
/usr/local/mysql/bin
$HOME/.twitools/src/twitter-utilities/sbt
$HOME/.twitools/src/twitter-utilities/sbt11
$HOME/.twitools/src/twitter-utilities/bin
/usr/local/sbin
$HOME/workspace/maven-tools/bin
$path)

if [[ -r $HOME/.tools-cache/setup-dottools-path.sh ]]; then
	source $HOME/.tools-cache/setup-dottools-path.sh
fi
