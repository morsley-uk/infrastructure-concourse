#!/usr/bin/env bash

#    _____           _        _ _    _____                                          
#   |_   _|         | |      | | |  / ____|                                         
#     | |  _ __  ___| |_ __ _| | | | |     ___  _ __   ___ ___  _   _ _ __ ___  ___ 
#     | | | '_ \/ __| __/ _` | | | | |    / _ \| '_ \ / __/ _ \| | | | '__/ __|/ _ \
#    _| |_| | | \__ \ || (_| | | | | |___| (_) | | | | (_| (_) | |_| | |  \__ \  __/
#   |_____|_| |_|___/\__\__,_|_|_|  \_____\___/|_| |_|\___\___/ \__,_|_|  |___/\___|
#                                                                                 
                                                                        
# Install Pivotal Concourse via Helm
    
set -x    
                                        
export KUBECONFIG=$(pwd)/$FOLDER/kube_config.yaml
chmod 400 $(pwd)/$FOLDER/node.pem

# Cert-Manager...

#kubectl apply -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.12/deploy/manifests/00-crds.yaml
#
#kubectl create namespace cert-manager
#
#helm repo add jetstack https://charts.jetstack.io
#
#helm repo update
#
#helm install cert-manager jetstack/cert-manager \
#  --version v0.12.0 \
#  --namespace cert-manager \
#  --wait
#
#kubectl get pods --namespace cert-manager
  
# Concourse...

helm repo add concourse https://concourse-charts.storage.googleapis.com/

helm repo update

kubectl create namespace $NAMESPACE

helm install $NAME concourse/concourse \
  --namespace $NAMESPACE \
  --wait

#helm install rancher rancher-stable/rancher \
#  --namespace cattle-system \
#  --version v2.3.5 \
#  --set hostname=rancher.morsley.io \
#  --set ingress.tls.source=letsEncrypt \
#  --set letsEncrypt.email=letsencrypt@morsley.uk \
#  --wait

#helm install rancher rancher-latest/rancher \
#  --namespace cattle-system \
#  --set hostname=rancher.morsley.io \
#  --set ingress.tls.source=letsEncrypt \
#  --set letsEncrypt.email=letsencrypt@morsley.uk \
#  --set letsEncrypt.environment=staging \
#  --wait

//kubectl --namespace $NAMESPACE rollout status stable/concourse

# https://whynopadlock.com
# https://www.ssllabs.com/ssltest/

# https://rancher.com/docs/rancher/v2.x/en/installation/options/troubleshooting/

set +x

exit 0