#! /bin/bash
set -x

NUM_WORKERS=$(cat config.json | jq -r '.num_workers')
ADDRESS_NAME=$(cat config.json | jq -r '.address_name')
INGRESS_ADDRESS_NAME=$(cat config.json | jq -r '.ingress_address_name')
SUBNET=$(cat config.json | jq -r '.subnet')
KUBERNETES_PUBLIC_ADDRESS=$(gcloud compute addresses describe $ADDRESS_NAME --format 'value(address)') 

[ -z "$NUM_WORKERS" ] && NUM_WORKERS=1

worker_names=""
for i in $(seq -w $NUM_WORKERS); do
    worker_names=$worker_names"worker"$i" "
done

gcloud compute instances create $worker_names \
   --boot-disk-size "10" \
   --can-ip-forward \
   --image "ubuntu-1604-xenial-v20160921" \
   --image-project ubuntu-os-cloud \
   --machine-type "f1-micro" \
   --subnet $SUBNET

sleep 30

env="K8S_APISERVERS=https://10.240.0.10:6443"
env=$env" K8S_APIMASTER=https://10.240.0.10:6443"
env=$env" K8S_TOKEN="$(bash ./auth/parsetoken.sh ./auth/token.csv "kubelet")
for worker_name in $worker_names; do
    gcloud compute copy-files \
       ./worker/cloud-init.sh \
       ./ca/ca.pem \
       ./ca/kubernetes-key.pem \
       ./ca/kubernetes.pem \
       ./auth/token.csv \
       ./auth/authorization-policy.jsonl \
       ubuntu@$worker_name:/home/ubuntu/

    gcloud compute ssh ubuntu@$worker_name --command="sudo $env bash /home/ubuntu/cloud-init.sh"
done
