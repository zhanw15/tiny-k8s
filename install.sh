#!/usr/bin/env bash

printf "==> tiny-k8s: %s\n" "create namespace tiny-k8s & etcd-operator"
kubectl apply -f sources/etcd-operator.yml

printf "==> tiny-k8s: %s\n" "create etcd cluster"
kubectl apply -f sources/etcd-cluster.yml

printf "==> tiny-k8s: %s\n" "create cert from cert-file"
kubectl create cm tiny-certs   -n tiny-k8s --from-file kubernetes/pki/

printf "==> tiny-k8s: %s\n" "create cert from cert-file"
kubectl create cm tiny-configs -n tiny-k8s --from-file kubernetes/

printf "%s\n" "证书自动签名"
kubectl2 create clusterrolebinding kubelet-bootstrap --clusterrole=system:node-bootstrapper --user=kubelet-bootstrap

printf "%s\n" "创建 cluster-info 为 node 节点加入"
kubectl2 create -f sources/cluster-info.yml
