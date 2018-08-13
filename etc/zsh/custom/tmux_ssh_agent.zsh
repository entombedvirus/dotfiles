# register a prexec hook that refreshes SSH_AUTH_SOCK to solve the problem of
# SSH_AUTH_SOCK becoming stale when attaching to an existing tmux session with
# already spawned shells.
# based on https://babushk.in/posts/renew-environment-tmux.html
if [ -n "$TMUX" ]; then
    function refresh_ssh_auth {
        eval $(tmux show-environment -s)
    }
    # runs refresh_ssh_auth before every running every command typed at the prompt
    autoload -Uz  add-zsh-hook
    add-zsh-hook preexec refresh_ssh_auth
fi
