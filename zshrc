path[1,0]=("$(cd "$(dirname "$0")" && pwd)")

function kswitch() {
  CONTEXTS=$(kubectl config get-contexts -o name)
  if [[ $(echo "$CONTEXTS" | wc -w) > 1 ]]; then
    kubectl config use-context $(echo $CONTEXTS | percol)
  fi
  export KUBE_NS=$(kubectl get ns | awk 'BEGIN { print "" } NR > 1 { print $1 }' | percol)
}

# Warning: this line is kinda slow :/
which kubectl > /dev/null 2>&1 && source <(kubectl completion zsh)
compdef k=kubectl
compdef kre=kubectl
