### COLORS ###
autoload -U colors
colors
fg_green=$'%{\e[0;32m%}'
fg_blue=$'%{\e[0;34m%}'
fg_cyan=$'%{\e[0;36m%}'
fg_red=$'%{\e[0;31m%}'
fg_brown=$'%{\e[0;33m%}'
fg_purple=$'%{\e[0;35m%}'

fg_light_gray=$'%{\e[0;37m%}'
fg_dark_gray=$'%{\e[1;30m%}'
fg_light_blue=$'%{\e[1;34m%}'
fg_light_green=$'%{\e[1;32m%}'
fg_light_cyan=$'%{\e[1;36m%}' fg_light_red=$'%{\e[1;31m%}'
fg_light_purple=$'%{\e[1;35m%}'
fg_no_color=$'%{\e[0m%}'

fg_white=$'%{\e[1;37m%}'
fg_black=$'%{\e[0;30m%}'


# Decide if we need to set titlebar text.
case $TERM in
  (xterm*|rxvt)
    titlebar_precmd () { print -Pn "\e]0;%~\a" }
    titlebar_preexec () { print -Pn "\e]0;$1\a" }
    ;;
  (screen)
    titlebar_precmd () { echo -ne "\ek${1%% *}\e\\" }
    titlebar_preexec () { echo -ne "\ek${1%% *}\e\\" }
    ;;
  (*)
    titlebar_precmd () {}
    titlebar_preexec () {}
    ;;
esac

precmd () {
  titlebar_precmd
}

preexec () {
  titlebar_preexec
}


# prompt helpers
current_git_branch() {
  git symbolic-ref HEAD 2> /dev/null | cut -d/ -f3-
}

git_prompt_info() {
  if [[ -n "$(current_git_branch)" ]]; then
    echo "($(current_git_branch)) "
  fi
}

pwd_length() {
  local length
  (( length = $COLUMNS / 2 - 25 ))
  echo $(($length < 20 ? 20 : $length))
}

prompt_user_host='%(!.${fg_red}.$fg_green%B)'`if [[ ! $HOME == */$USER ]] echo '%n@'`'%m%b '
prompt_jobs='${fg_cyan}%1(j.(%j) .)'
prompt_pwd='${fg_blue}%$(pwd_length)<...<%(!.%/.%~)%<<'
prompt_git_branch='${fg_purple}$(__git_ps1)'
#prompt_git_branch='${fg_purple}$(git_prompt_info)'
prompt_exit_code='${fg_light_red}%(0?..%? ↵)${fg_no_color}'
prompt_sigil='${fg_no_color}%(!.${fg_red}.) » '
prompt_end='${fg_no_color}'

setopt prompt_subst

# left
# PS1=$'%{${fg[blue]}%}%~%{${fg[red]}%}\$(__git_ps1 " (%s)")%{${fg[default]}%} $\n→ '
# PS1="$prompt_user_host$prompt_pwd$prompt_git_branch$prompt_jobs$prompt_sigil$prompt_end"
PS1="$prompt_user_host$prompt_pwd$prompt_git_branch$prompt_jobs$prompt_sigil$prompt_end
→ "
#right
RPS1="$prompt_exit_code"
