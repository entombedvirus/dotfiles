# Interactive kubectl helpers powered by fzf.

unalias k 2>/dev/null
unalias kctx 2>/dev/null
unalias kns 2>/dev/null
unalias kpods 2>/dev/null
unalias klogs 2>/dev/null
unalias kexec 2>/dev/null
unalias kport 2>/dev/null
unalias kportsvc 2>/dev/null
unalias kdpod 2>/dev/null
unalias kevents 2>/dev/null
unalias kimgs 2>/dev/null

alias k=kubectl

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

# If the query looks like a kubectl label selector (contains `=`), treat it as
# server-side label filter; otherwise it's an fzf fuzzy query.
function __kube_is_label_selector {
    [[ $1 == *=* ]]
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
    local -a list_args=(get pods --sort-by=.metadata.creationTimestamp --no-headers)
    local fzf_query=$query

    namespace=$(__kube_current_namespace)

    if __kube_is_label_selector "$query"; then
        list_args+=(-l "$query")
        fzf_query=
    fi

    local listing
    listing=$(kubectl "${list_args[@]}") || return 1

    if [[ -z "$listing" ]]; then
        print -u2 -- "no pods in namespace '$namespace'${query:+ matching '$query'}"
        return 1
    fi

    local fzf_status
    selection=$(print -r -- "$listing" \
        | __kube_fzf \
            --query "$fzf_query" \
            --header "Select a pod from namespace: $namespace" \
            --preview 'kubectl get pod {1} -o wide' \
            --preview-window=down:70%)
    fzf_status=$?

    if (( fzf_status == 1 )); then
        print -u2 -- "no pods matched '$fzf_query' in namespace '$namespace'"
        return 1
    fi
    (( fzf_status == 0 )) || return $fzf_status

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
    local -a list_args=(get pods --no-headers
        -o 'custom-columns=NAME:.metadata.name,PORTS:.spec.containers[*].ports[*].containerPort')
    local fzf_query=$query

    namespace=$(__kube_current_namespace)

    if __kube_is_label_selector "$query"; then
        list_args+=(-l "$query")
        fzf_query=
    fi

    local listing
    listing=$(kubectl "${list_args[@]}" | awk '$2 != "<none>" { print }') || return 1

    if [[ -z "$listing" ]]; then
        print -u2 -- "no pods with declared ports in namespace '$namespace'${query:+ matching '$query'}"
        return 1
    fi

    local fzf_status
    selection=$(print -r -- "$listing" \
        | __kube_fzf \
            --query "$fzf_query" \
            --header "Select a pod/port from namespace: $namespace")
    fzf_status=$?

    if (( fzf_status == 1 )); then
        print -u2 -- "no pods matched '$fzf_query' in namespace '$namespace'"
        return 1
    fi
    (( fzf_status == 0 )) || return $fzf_status

    [[ -n "$selection" ]] || return 1
    print -r -- "$selection"
}

function __kube_select_service_port_row {
    local query=$1
    local namespace
    local selection
    local -a list_args=(get services --no-headers
        -o 'custom-columns=NAME:.metadata.name,PORTS:.spec.ports[*].port')
    local fzf_query=$query

    namespace=$(__kube_current_namespace)

    if __kube_is_label_selector "$query"; then
        list_args+=(-l "$query")
        fzf_query=
    fi

    local listing
    listing=$(kubectl "${list_args[@]}" | awk '$2 != "<none>" { print }') || return 1

    if [[ -z "$listing" ]]; then
        print -u2 -- "no services with declared ports in namespace '$namespace'${query:+ matching '$query'}"
        return 1
    fi

    local fzf_status
    selection=$(print -r -- "$listing" \
        | __kube_fzf \
            --query "$fzf_query" \
            --header "Select a service/port from namespace: $namespace" \
            --preview 'kubectl get service {1} -o yaml' \
            --preview-window=down:70%)
    fzf_status=$?

    if (( fzf_status == 1 )); then
        print -u2 -- "no services matched '$fzf_query' in namespace '$namespace'"
        return 1
    fi
    (( fzf_status == 0 )) || return $fzf_status

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

    local fzf_status
    selection=$(kubectl get namespaces --no-headers \
        | __kube_fzf --query "$query" --header 'Select a namespace')
    fzf_status=$?

    if (( fzf_status == 1 )); then
        print -u2 -- "no namespaces matched '$query'"
        return 1
    fi
    (( fzf_status == 0 )) || return $fzf_status

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
    kubectl exec -it "$pod" -c "$container" -- /bin/sh
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

function kportsvc {
    __kube_require_tools || return 1

    local query=
    local local_port=
    local selection
    local service
    local ports_csv
    local remote_port

    if [[ $1 == <-> && -z $2 ]]; then
        local_port=$1
    else
        query=$1
        local_port=$2
    fi

    selection=$(__kube_select_service_port_row "$query") || return 1
    service=$(awk '{print $1}' <<< "$selection")
    ports_csv=$(awk '{print $2}' <<< "$selection")
    [[ -n "$service" && -n "$ports_csv" ]] || return 1

    remote_port=$(__kube_select_port "$service" "$ports_csv" "$query") || return 1
    kubectl port-forward "service/$service" "${local_port:-$remote_port}:$remote_port"
}

function kimgs {
    __kube_require_tools || return 1

    local query=$1
    local namespace
    local -a pods
    local -a list_args=(get pods --no-headers)
    local fzf_query=$query

    namespace=$(__kube_current_namespace)

    if __kube_is_label_selector "$query"; then
        list_args+=(-l "$query")
        fzf_query=
    fi

    local listing
    listing=$(kubectl "${list_args[@]}") || return 1

    if [[ -z "$listing" ]]; then
        print -u2 -- "no pods in namespace '$namespace'${query:+ matching '$query'}"
        return 1
    fi

    local fzf_output fzf_status
    fzf_output=$(print -r -- "$listing" \
        | __kube_fzf \
            --multi \
            --query "$fzf_query" \
            --header "Select pods from namespace: $namespace (TAB to multi-select)" \
            --preview 'kubectl get pod {1} -o wide' \
            --preview-window=down:70%)
    fzf_status=$?

    if (( fzf_status == 1 )); then
        print -u2 -- "no pods matched '$fzf_query' in namespace '$namespace'"
        return 1
    fi
    (( fzf_status == 0 )) || return $fzf_status

    pods=("${(@f)$(print -r -- "$fzf_output" | awk '{print $1}')}")

    (( ${#pods[@]} > 0 )) || return 1

    local pod
    for pod in "${pods[@]}"; do
        [[ -n "$pod" ]] || continue
        kubectl get pod "$pod" \
            -o jsonpath="{range .spec.containers[*]}${pod}\t{.name}\t{.image}{\"\n\"}{end}"
    done | column -t -s $'\t'
}
