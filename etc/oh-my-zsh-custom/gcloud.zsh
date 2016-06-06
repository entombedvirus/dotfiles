# The next line updates PATH for the Google Cloud SDK.
function source_if_exists {
    file=$1
    [ -f $file ] && source $file
}

source_if_exists '/home/rohith/work/google-cloud-sdk/path.zsh.inc'

# The next line enables shell command completion for gcloud.
source_if_exists '/home/rohith/work/google-cloud-sdk/completion.zsh.inc'


