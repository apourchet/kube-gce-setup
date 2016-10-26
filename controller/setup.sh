#! /bin/bash

ADDRESS_NAME=$(cat config.json | jq -r '.address_name')
SUBNET=$(cat config.json | jq -r '.subnet')
KUBERNETES_PUBLIC_ADDRESS=$(gcloud compute addresses describe $ADDRESS_NAME --format 'value(address)') 

gcloud compute instances create "controller0" \
    --boot-disk-size "10" \
    --can-ip-forward \
    --image "ubuntu-1604-xenial-v20160921" \
    --image-project ubuntu-os-cloud \
    --machine-type "f1-micro" \
    --private-network-ip 10.240.0.10 \
    --subnet $SUBNET \

sleep 30

gcloud compute copy-files \
    ./controller/cloud-init.sh \
    ./ca/ca.pem \
    ./ca/kubernetes-key.pem \
    ./ca/kubernetes.pem \
    ./auth/token.csv \
    ./auth/authorization-policy.jsonl \
    ubuntu@controller0:/home/ubuntu/

gcloud compute ssh ubuntu@controller0 --command="sudo bash /home/ubuntu/cloud-init.sh"

gcloud compute http-health-checks create kube-apiserver-check \
      --description "Kubernetes API Server Health Check" \
      --port 8080 \
      --request-path /healthz

gcloud compute target-pools create kubernetes-pool \
      --health-check kube-apiserver-check

gcloud compute target-pools add-instances kubernetes-pool \
      --instances controller0

gcloud compute forwarding-rules create kubernetes-rule \
      --address ${KUBERNETES_PUBLIC_ADDRESS} \
      --ports 6443 \
      --target-pool kubernetes-pool
