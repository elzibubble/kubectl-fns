#!/bin/bash

set -eu
set -o pipefail

op="$1"; shift
kind="$1"; shift
args="";

case "$op" in
    del | rm) op='delete';;
    g) op='get';;
    d | desc) op='describe';;
    scale0) op='scale'; args="--replicas=0";;
    scale1) op='scale'; args="--replicas=1";;
    scale3) op='scale'; args="--replicas=3";;
esac

case "$kind" in
    dep) kind='deploy';;
esac

set -- "$op" "$kind" "$@"
if [[ -z "$KUBE_NS" ]]; then
    kubectl $args "$@"
else
    kubectl -n "$KUBE_NS" $args "$@"
fi
