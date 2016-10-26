#! /bin/bash

LOCAL_CLUSTER_ALIAS=$(cat config.json | jq -r '.cluster_alias')
LOCAL_CONTEXT_NAME=$(cat config.json | jq -r '.context_name')
DEFAULT_NAMESPACE=$(cat config.json | jq -r '.default_namespace')
ADDRESS_NAME=$(cat config.json | jq -r '.address_name')
KUBERNETES_PUBLIC_ADDRESS=$(gcloud compute addresses describe $ADDRESS_NAME --format 'value(address)') 

kubectl config set-cluster $LOCAL_CLUSTER_ALIAS \
  --certificate-authority=./ca/ca.pem \
  --embed-certs=true \
  --server=https://${KUBERNETES_PUBLIC_ADDRESS}:6443

kubectl config set-credentials admin --token $(bash ./auth/parsetoken.sh ./auth/token.csv admin)

kubectl config set-context $LOCAL_CONTEXT_NAME \
  --namespace=$DEFAULT_NAMESPACE \
  --cluster=$LOCAL_CLUSTER_ALIAS \
  --user=admin

kubectl config use-context $LOCAL_CONTEXT_NAME 
