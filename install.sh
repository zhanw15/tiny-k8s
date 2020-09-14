#!/usr/bin/env bash

printf "==> tiny-k8s: %s\n" "create etcd-operator in kube-system"
kubectl apply -f sources/etcd-operator.yml

printf "==> tiny-k8s: %s\n" "create certs for kubernetes"
kubeadm init phase certs all --config kubernetes/kubeadm.conf
kubectl create cm tiny-certs   -n tiny-k8s --from-file kubernetes/pki/

printf "==> tiny-k8s: %s\n" "create kubeconfig for admin controller-manager scheduler"
kubeadm init phase kubeconfig all --config kubernetes/kubeadm.conf --kubeconfig-dir /root/zhanwang/tiny-k8s/kubernetes/kubeconfig
kubectl create cm tiny-configs -n tiny-k8s --from-file kubernetes/kubeconfig/

printf "%s\n" "tiny-k8s control-plane init"
kubectl apply -f sources/control-plane.yml

printf "%s\n" "create kube-proxy, dns plugin, network plugin for tiny-k8s"
kubectl2 apply -f sources/plugins.yml

printf "%s\n" "create cluster-info for kubeadm join node"
kubectl2 apply -f sources/cluster-info.yml


### join node into tiny k8s
# kubeadm token create
# kubeadm join 10.110.18.78:30443 --token zb98xj.j1pa1edetukt75xp --discovery-token-ca-cert-hash sha256:dc079e11dbae14e70ab098b29471df366085ae80091573e3e8152b7fb48c7eac -v=8


### clean unuseful file
# rm -rf /root/zhanwang/tiny-k8s/kubernetes/kubeconfig/kubelet.conf
# rm -rf kubernetes/pki/etcd/ kubernetes/pki/apiserver-etcd-client.*
