function source_if_exists {
    file=$1
    [ -f "$file" ] && source "$file"
}

# The next line updates PATH for the Google Cloud SDK.
source_if_exists "$HOME/google-cloud-sdk/path.zsh.inc"

# The next line enables shell command completion for gcloud.
source_if_exists "$HOME/google-cloud-sdk/completion.zsh.inc"
