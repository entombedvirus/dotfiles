# set BROWSER for xdg-open
if type lemonade > /dev/null 2>&1; then
    export BROWSER="lemonade open"
fi

export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
export MANPATH="/home/linuxbrew/.linuxbrew/share/man:$MANPATH"
export INFOPATH="/home/linuxbrew/.linuxbrew/share/info:$INFOPATH"
