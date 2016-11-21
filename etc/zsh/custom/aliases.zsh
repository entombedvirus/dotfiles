# Git Aliases
alias gst='git status'
alias gl='git pull'
alias gp='git push'
alias gd='git diff'
alias gc='git commit -v'
alias gca='git commit -v -a'
alias gb='git branch'
alias gba='git branch -a'
alias ga='git add .'
alias ddd="gst | grep deleted | awk '{print \$3}' | xargs -I{} git rm {}"
alias gdn="git diff --name-only"

# oh-my-zsh git plugin defines an alias that inteferes with this function
unalias gcb 2>/dev/null
function gcb {
  branch=$1
  if [[ -z "$branch" ]]; then
    anyframe-widget-checkout-git-branch
    return
  fi

  count=`gb | grep $1  | wc -l`
  if [[ $count -ge 2 ]]; then
    anyframe-source-git-branch -n \
      | anyframe-selector-auto "$branch" \
      | awk '{print $1}' \
      | anyframe-action-execute git checkout
    return
  fi

  if [[ $count -eq 1 ]]; then
    git co `gb | grep $1`
  else
    echo "no branches with $branch in the name"
  fi
}

function kctx {
    name=$1
    kubectl config get-contexts \
      | awk '$5==""{print $2 "\tdefault"}; $5!=""{print $2 "\t" $5}' \
      | xargs -L2  printf "%-60s %-30s\n" \
      | fzf --query "$name" --header-lines=1 \
      | awk '{print $1}' \
      | anyframe-action-execute kubectl config use-context
}

# kubernetes
alias k='kubectl'
alias dpod='kubectl describe pod'
alias dsvc='kubectl describe service'
alias ddep='kubectl describe deployment'

function kshell {
    local pod=$1
    local container=$2

    if [ -n "$container" ]; then
        kubectl exec $pod -c $container -t -i -- env COLUMNS=$(tput cols) LINES=$(tput lines) TERM=$TERM /bin/bash
    else
        kubectl exec $pod -t -i -- env COLUMNS=$(tput cols) LINES=$(tput lines) TERM=$TERM /bin/bash
    fi
}

function kpods {
    local grepStr=$1

    if [ -n "$grepStr" ]; then
        kubectl get pods | grep "$grepStr"
    else
        kubectl get pods
    fi
}

function kroll {
    local role=$1
    local delay=${2:-5}
    pod_names=$(kubectl get pods --selector="role=${role}" -o=jsonpath="{.items[*].metadata.name}")
    if [ -z "${pod_names}" ]
    then
        echo "no pods found. exiting"
        return
    fi
    echo -en "About to delete $(wc -w <<< "${pod_names}") pods: ${pod_names}\nContinue (y/N): "
    read -q
    if [ $? -ne 0 ]
    then
        echo -e "\naborting"
        return
    fi
    for p in "${=pod_names}"
    do
        echo
        cmd="kubectl delete pod ${p}"
        echo $cmd
        /bin/bash -c "${cmd}"
        count=${delay}
        while [ ${count} -gt 0 ]
        do
            ((count-=1))
            echo -en "\rwaiting... ${count}"
            sleep 1
        done
    done
    kubectl get pods --watch --selector="role=${role}"
}
