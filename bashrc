export PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd):$PATH"

kswitch() {
  export KUBE_NS=$(kubectl get ns | awk 'BEGIN { print "" } NR > 1 { print $1 }' | percol)
}
