function source_if_exists {
    file=$1
    [ -f "$file" ] && source "$file"
}

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


if [[ -d "$HOME/.nvm" ]]; then
  # nvm initialization
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

  # place this after nvm initialization!
  autoload -U add-zsh-hook

  load-nvmrc() {
    local nvmrc_path
    nvmrc_path="$(nvm_find_nvmrc)"

    if [ -n "$nvmrc_path" ]; then
      local nvmrc_node_version
      nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

      if [ "$nvmrc_node_version" = "N/A" ]; then
	nvm install
      elif [ "$nvmrc_node_version" != "$(nvm version)" ]; then
	nvm use
      fi
    elif [ -n "$(PWD=$OLDPWD nvm_find_nvmrc)" ] && [ "$(nvm version)" != "$(nvm version default)" ]; then
      echo "Reverting to nvm default version"
      nvm use default
    fi
  }

  add-zsh-hook chpwd load-nvmrc
  load-nvmrc
fi
