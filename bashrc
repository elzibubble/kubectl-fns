export PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd):$PATH"

kswitch() {
  CONTEXTS=$(kubectl config get-contexts -o name)
  if [[ $(echo "$CONTEXTS" | wc -w) > 1 ]]; then
    kubectl config use-context $(echo $CONTEXTS | percol)
  fi
  export KUBE_NS=$(kubectl get ns | awk 'BEGIN { print "" } NR > 1 { print $1 }' | percol)
}
