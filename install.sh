#!/usr/bin/env bash

printf "==> tiny-k8s: %s\n" "create namespace tiny-k8s & etcd-operator"
kubectl apply -f sources/etcd-operator.yml

printf "==> tiny-k8s: %s\n" "create etcd cluster"
kubectl apply -f sources/etcd-cluster.yml

printf "==> tiny-k8s: %s\n" "create certs for kubernetes"
kubeadm init phase certs all --config kubernetes/kubeadm.conf
kubectl create cm tiny-certs   -n tiny-k8s --from-file kubernetes/pki/

printf "==> tiny-k8s: %s\n" "create kubeconfig for admin controller-manager scheduler"
kubeadm init phase kubeconfig all --config kubernetes/kubeadm.conf --kubeconfig-dir /root/zhanwang/tiny-k8s/kubernetes/kubeconfig
kubectl create cm tiny-configs -n tiny-k8s --from-file kubernetes/kubeconfig/

printf "%s\n" "创建 cluster-info 为 node 节点加入"
kubectl2 create -f sources/cluster-info.yml


### clean unuseful file
rm -rf /root/zhanwang/tiny-k8s/kubernetes/kubeconfig/kubelet.conf
rm -rf kubernetes/pki/etcd/ kubernetes/pki/apiserver-etcd-client.*
