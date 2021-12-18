function source_if_exists {
    file=$1
    [ -f "$file" ] && source "$file"
}
source_if_exists "$HOME/.gcpdevbox"
source_if_exists "$HOME/analytics/.shellenv"

source ${HOME}/.antigen/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundles <<EOBUNDLE
    gitfast
    golang
    kubectl
    history
EOBUNDLE

# can't use antigen theme for these
autoload -U promptinit; promptinit
prompt pure

# Bundles from Github
antigen bundles <<EOBUNDLE
    # fzf completions
    junegunn/fzf shell/
    mollifier/anyframe
EOBUNDLE

# custom stuff
antigen bundle $HOME/.zsh/custom

# Syntax highlighting bundle. should be last
antigen bundle zsh-users/zsh-syntax-highlighting

# Tell antigen that you're done.
antigen apply

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
