# See following for more information: http://www.infinitered.com/blog/?p=10

# Identify OS and Machine -----------------------------------------
export OS=`uname -s | sed -e 's/  */-/g;y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/'`
export OSVERSION=`uname -r`; OSVERSION=`expr "$OSVERSION" : '[^0-9]*\([0-9]*\.[0-9]*\)'`
export MACHINE=`uname -m | sed -e 's/  */-/g;y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/'`
export PLATFORM="$MACHINE-$OS-$OSVERSION"
# Note, default OS is assumed to be linux



# Path ------------------------------------------------------------
if [ "$OS" = "darwin" ] ; then
  export PATH=/usr/local/homebrew/bin:/usr/local/bin:/usr/local/sbin:/usr/local/mysql/bin:$PATH
  #export PATH=/opt/local/bin:/opt/local/sbin:$PATH  # OS-X Specific, with MacPorts installed
fi

if [ -d ~/.bin ]; then
	export PATH=:~/.bin:$PATH  # add your bin folder to the path, if you have it.  It's a good place to add all your scripts
fi

if [ -d ~/.local/bin ]; then
	export PATH=:~/.local/bin:$PATH  # add your bin folder to the path, if you have it.  It's a good place to add all your scripts
fi

if [ -d ~/cl/bin ]; then
	export PATH=:~/cl/bin:$PATH  # add your bin folder to the path, if you have it
fi

if [ -d /home/linuxbrew/.linuxbrew/bin ]; then
	export PATH=:/home/linuxbrew/.linuxbrew/bin:$PATH  # add your bin folder to the path, if you have it
fi

if [ -d /usr/local/share/npm/bin ]; then
	export PATH=:/usr/local/share/npm/bin:$PATH  # add your bin folder to the path, if you have it
fi

if [ -d ~/.gem/ruby/1.8/bin ]; then
	export PATH=:~/.gem/ruby/1.8/bin:$PATH  # add your bin folder to the path, if you have it
fi

# Start ssh-agent
SSH_ENV="$HOME/.ssh/environment"

function start_agent {
  echo "Initializing new SSH agent..."
  /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
  echo succeeded
  chmod 600 "${SSH_ENV}"
  . "${SSH_ENV}" > /dev/null
  /usr/bin/ssh-add;
  ssh-add ~/.ssh/new_serious_key
}

# Source SSH settings, if applicable
if [ "$OS" = "linux" -a "$HOSTNAME" = "s04.seriousops.com" ]; then
  if [ -f "${SSH_ENV}" ]; then
    . "${SSH_ENV}" > /dev/null
    #ps ${SSH_AGENT_PID} doesn't work under cywgin
    ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
    start_agent;
  }
  else
    start_agent;
  fi 
fi

# Load in .bashrc -------------------------------------------------
source ~/.bashrc



# Hello Messsage --------------------------------------------------
case "$-" in
	*i*)
		# Only do this for interactive shells
		echo -e "Kernel Information: " `uname -smr`
		echo -e "${COLOR_BROWN}`bash --version`"
		echo -ne "${COLOR_GRAY}Uptime: "; uptime
		echo -ne "${COLOR_GRAY}Server time is: "; date
		;;
esac



# Notes: ----------------------------------------------------------
# When you start an interactive shell (log in, open terminal or iTerm in OS X, 
# or create a new tab in iTerm) the following files are read and run, in this order:
#     profile
#     bashrc
#     .bash_profile
#     .bashrc (only because this file is run (sourced) in .bash_profile)
#
# When an interactive shell, that is not a login shell, is started 
# (when you run "bash" from inside a shell, or when you start a shell in 
# xwindows [xterm/gnome-terminal/etc] ) the following files are read and executed, 
# in this order:
#     bashrc
#     .bashrc

##
# Your previous /Users/rohith/.profile file was backed up as /Users/rohith/.profile.macports-saved_2009-11-13_at_11:48:26
##

# MacPorts Installer addition on 2009-11-13_at_11:48:26: adding an appropriate PATH variable for use with MacPorts.
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
# Finished adapting your PATH environment variable for use with MacPorts.
export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
export MANPATH="/home/linuxbrew/.linuxbrew/share/man:$MANPATH"
export INFOPATH="/home/linuxbrew/.linuxbrew/share/info:$INFOPATH"

# gcp devbox env vars
export SETUP_MACHINE=1
export DEVBOX=1
export GCP_DEVBOX=1
export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
export MANPATH="/home/linuxbrew/.linuxbrew/share/man:$MANPATH"
export INFOPATH="/home/linuxbrew/.linuxbrew/share/info:$INFOPATH"
# BEGIN ANSIBLE MANAGED BLOCK
CURRENTSHELL="$(echo $SHELL | grep -oP '/bin/\K\w+')" source ~/.fzf."${CURRENTSHELL}"
source ~/analytics/google-cloud/scripts/kube.sh
# END ANSIBLE MANAGED BLOCK
. "$HOME/.cargo/env"
