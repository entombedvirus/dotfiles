function source_if_exists {
    file=$1
    [ -f "$file" ] && source "$file"
}

# Use 1password for ssh key management if available
ONE_PASSWORD_AGENT="$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
if [[ -S "$ONE_PASSWORD_AGENT" ]]; then
	export SSH_AUTH_SOCK="$ONE_PASSWORD_AGENT"
fi

