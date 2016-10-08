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
  anyframe-widget-checkout-git-branch
  # branch=$1
  # count=`gb | grep $1  | wc -l`
  # if [[ $count -ge 2 ]]; then
  #   echo "too many branches with $branch in the name:"
  #   gb | grep $1
  #   return
  # fi

  # if [[ $count -eq 1 ]]; then
  #   git co `gb | grep $1`
  # else
  #   echo "no branches with $branch in the name"
  # fi
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
    pod_names=$(kubectl get pods --selector="role=${role}" -o=jsonpath="{.items[*].metadata.name}")

    if [ -z "${pod_names}" ]; then
        echo "no pods found. exiting"
        return
    fi

    echo -en "About to delete $(wc -w <<< "${pod_names}") pods: ${pod_names}\nContinue (y/N): "
    read -q

    if [ $? -ne 0 ]; then
        echo -e "\naborting"
        return
    fi

    # ${=foo} enables splitting by IFS, aka by word
    for p in "${=pod_names}"; do
        echo
        cmd="kubectl delete pod ${p}"
        echo $cmd
        /bin/bash -c "${cmd}"

        count=5
        while [ ${count} -gt 0 ]; do
            ((count-=1))
            echo -en "\rwaiting... ${count}"
            sleep 1
        done
    done
}
