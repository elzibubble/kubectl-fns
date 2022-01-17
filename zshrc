path[1,0]=("$(cd "$(dirname "$0")" && pwd)")

function kswitch() {
  CONTEXTS=$(kubectl config get-contexts -o name)
  if [[ $(wc -w <<<"$CONTEXTS") > 1 ]]; then
    kubectl config use-context $(percol <<<"$CONTEXTS")
  fi
}

# Removed the kubectl completion so you can choose which to use.
# EG https://github.com/nnao45/zsh-kubectl-completion
# compdef k=kubectl

# Aliases work with completion
alias k="kubectl"
alias kk="kubectl"
alias kg="kubectl get"
alias kd="kubectl describe"
alias krm="kubectl delete"
alias krm-9="kubectl delete --force --grace-period=0"
alias ktail="kubectl logs --tail=10 --follow"
alias ktail0="kubectl logs --tail=0 --follow"
alias kscale0="kubectl scale --replicas=0"
alias kscale1="kubectl scale --replicas=1"
alias kscale3="kubectl scale --replicas=3"
