function source_if_exists {
    file=$1
    [ -f "$file" ] && source "$file"
}
source_if_exists "$HOME/.gcpdevbox"
source_if_exists "$HOME/analytics/.shellenv"

source ${HOME}/.antigen/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

antigen bundles <<EOBUNDLE
    history

    # fzf completions
    junegunn/fzf shell/
    mollifier/anyframe

	# custom stuff
	$HOME/.zsh/custom

	# Syntax highlighting bundle. should be last
	zsh-users/zsh-syntax-highlighting
EOBUNDLE

# Tell antigen that you're done.
antigen apply

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# can't use antigen theme for these
autoload -U promptinit; promptinit
prompt pure

