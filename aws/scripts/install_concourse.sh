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
chmod 400 $(pwd)/$FOLDER/*

ls -la

cd $(pwd)/$FOLDER/

ls -la
 
# Concourse...

kubectl apply --filename concourse-workers-pv.yaml

helm repo add concourse https://concourse-charts.storage.googleapis.com/

helm repo update

kubectl create namespace $NAMESPACE

helm install $NAME concourse/concourse \
  --namespace $NAMESPACE \
  --wait

kubectl --namespace $NAMESPACE rollout status concourse/concourse

# https://whynopadlock.com
# https://www.ssllabs.com/ssltest/

# https://rancher.com/docs/rancher/v2.x/en/installation/options/troubleshooting/

set +x

exit 0