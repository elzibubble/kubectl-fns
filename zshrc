path[1,0]=("$(cd "$(dirname "$0")" && pwd)")

function ksetns() {
  NS=$(kubectl get ns | awk 'BEGIN { print "" } NR > 1 { print $1 }' | percol)
  kubectl config set-context --current --namespace="$NS"
}

function kswitch() {
  CONTEXTS=$(kubectl config get-contexts -o name)
  if [[ $(echo "$CONTEXTS" | wc -w) > 1 ]]; then
    kubectl config use-context $(echo $CONTEXTS | percol)
  fi
  ksetns
}

# Removed the kubectl completion so you can choose which to use.
# EG https://github.com/nnao45/zsh-kubectl-completion
# compdef k=kubectl

# Aliases work with completion
# Might remove the `k` script at some point.
alias kk="kubectl"
alias kg="kubectl get"
alias kd="kubectl describe"
alias krm="kubectl delete"
alias ktail="kubectl logs --tail=10 --follow"
alias ktail0="kubectl logs --tail=0 --follow"
alias kscale0="kubectl scale --replicas=0"
alias kscale1="kubectl scale --replicas=1"
alias kscale3="kubectl scale --replicas=3"
