# Interactive kubectl helpers powered by fzf.

unalias kctx 2>/dev/null
unalias kns 2>/dev/null
unalias kpods 2>/dev/null
unalias klogs 2>/dev/null
unalias kexec 2>/dev/null
unalias kport 2>/dev/null
unalias kdpod 2>/dev/null
unalias kevents 2>/dev/null

function __kube_require_tools {
    local tool

    for tool in kubectl fzf; do
        if ! command -v "$tool" >/dev/null 2>&1; then
            print -u2 -- "missing required command: $tool"
            return 1
        fi
    done
}

function __kube_fzf {
    fzf --select-1 --exit-0 "$@"
}

function __kube_current_namespace {
    local namespace

    namespace=$(kubectl config view --minify --output 'jsonpath={..namespace}' 2>/dev/null)
    print -r -- "${namespace:-default}"
}

function __kube_select_pod {
    local query=$1
    local namespace
    local selection

    namespace=$(__kube_current_namespace)
    selection=$(kubectl get pods --sort-by=.metadata.creationTimestamp --no-headers \
        | __kube_fzf \
            --query "$query" \
            --header "Select a pod from namespace: $namespace" \
            --preview 'kubectl get pod {1} -o wide' \
            --preview-window=down:70%) || return 1

    [[ -n "$selection" ]] || return 1
    awk '{print $1}' <<< "$selection"
}

function __kube_select_container {
    local pod=$1
    local query=$2
    local selection
    local -a containers

    containers=("${(@f)$(kubectl get pod "$pod" -o jsonpath='{range .spec.containers[*]}{.name}{"\n"}{end}' 2>/dev/null)}")
    (( ${#containers[@]} > 0 )) || return 1

    if (( ${#containers[@]} == 1 )); then
        print -r -- "$containers[1]"
        return 0
    fi

    selection=$(printf '%s\n' "${containers[@]}" \
        | __kube_fzf --query "$query" --header "Select a container from pod: $pod") || return 1

    [[ -n "$selection" ]] || return 1
    print -r -- "$selection"
}

function __kube_select_pod_port_row {
    local query=$1
    local namespace
    local selection

    namespace=$(__kube_current_namespace)
    selection=$(kubectl get pods --no-headers \
        -o 'custom-columns=NAME:.metadata.name,PORTS:.spec.containers[*].ports[*].containerPort' \
        | awk '$2 != "<none>" { print }' \
        | __kube_fzf \
            --query "$query" \
            --header "Select a pod/port from namespace: $namespace") || return 1

    [[ -n "$selection" ]] || return 1
    print -r -- "$selection"
}

function __kube_select_port {
    local pod=$1
    local ports_csv=$2
    local query=$3
    local selection
    local -a ports

    ports_csv=${ports_csv// /}
    ports=("${(@s:,:)ports_csv}")
    (( ${#ports[@]} > 0 )) || return 1

    if (( ${#ports[@]} == 1 )); then
        print -r -- "$ports[1]"
        return 0
    fi

    selection=$(printf '%s\n' "${ports[@]}" \
        | __kube_fzf --query "$query" --header "Select a port from pod: $pod") || return 1

    [[ -n "$selection" ]] || return 1
    print -r -- "$selection"
}

function kctx {
    __kube_require_tools || return 1

    local query=$1
    local context

    context=$(kubectl config get-contexts -o name \
        | __kube_fzf --query "$query" --header 'Select a kubectl context') || return 1

    [[ -n "$context" ]] || return 1
    kubectl config use-context "$context"
}

function kns {
    __kube_require_tools || return 1

    local query=$1
    local selection
    local namespace

    selection=$(kubectl get namespaces --no-headers \
        | __kube_fzf --query "$query" --header 'Select a namespace') || return 1

    [[ -n "$selection" ]] || return 1
    namespace=$(awk '{print $1}' <<< "$selection")
    [[ -n "$namespace" ]] || return 1
    kubectl config set-context --current --namespace="$namespace"
}

function kpods {
    __kube_require_tools || return 1

    local query=$1
    local pod

    pod=$(__kube_select_pod "$query") || return 1
    kubectl get pod "$pod" -o wide
}

function klogs {
    __kube_require_tools || return 1

    local -a flags=()
    local query=

    while (( $# )); do
        case $1 in
            -*) flags+=("$1"); shift ;;
            *)  query=$1; shift ;;
        esac
    done

    # Default to -f if no flags given
    (( ${#flags[@]} )) || flags=(-f)

    local pod
    local container

    pod=$(__kube_select_pod "$query") || return 1
    container=$(__kube_select_container "$pod" "$query") || return 1
    kubectl logs "${flags[@]}" "$pod" -c "$container"
}

function kexec {
    __kube_require_tools || return 1

    local query=$1
    local pod
    local container

    pod=$(__kube_select_pod "$query") || return 1
    container=$(__kube_select_container "$pod" "$query") || return 1
    kubectl exec -it "$pod" -c "$container" -- /bin/bash
}

function kdpod {
    __kube_require_tools || return 1

    local query=$1
    local pod

    pod=$(__kube_select_pod "$query") || return 1
    kubectl describe pod "$pod"
}

function kevents {
    __kube_require_tools || return 1

    local query=$1

    kubectl get events --sort-by=.lastTimestamp "$@"
}

function kport {
    __kube_require_tools || return 1

    local query=
    local local_port=
    local selection
    local pod
    local ports_csv
    local remote_port

    if [[ $1 == <-> && -z $2 ]]; then
        local_port=$1
    else
        query=$1
        local_port=$2
    fi

    selection=$(__kube_select_pod_port_row "$query") || return 1
    pod=$(awk '{print $1}' <<< "$selection")
    ports_csv=$(awk '{print $2}' <<< "$selection")
    [[ -n "$pod" && -n "$ports_csv" ]] || return 1

    remote_port=$(__kube_select_port "$pod" "$ports_csv" "$query") || return 1
    kubectl port-forward "pod/$pod" "${local_port:-$remote_port}:$remote_port"
}
