#! /bin/bash

# PART 1: Network stuff
gcloud config set compute/region $(cat config.json | jq -r '.region')
gcloud config set compute/zone $(cat config.json | jq -r '.zone')

NETWORK=$(cat config.json | jq -r '.network')
SUBNET=$(cat config.json | jq -r '.subnet')
ADDRESS_NAME=$(cat config.json | jq -r '.address_name')


gcloud compute networks create $NETWORK --mode custom

gcloud compute networks subnets create $SUBNET \
      --network $NETWORK \
      --range 10.240.0.0/24

gcloud compute firewall-rules create $NETWORK-allow-icmp \
      --allow icmp \
      --network $NETWORK \
      --source-ranges 0.0.0.0/0 

gcloud compute firewall-rules create $NETWORK-allow-internal \
      --allow tcp:0-65535,udp:0-65535,icmp \
      --network $NETWORK \
      --source-ranges 10.240.0.0/24

gcloud compute firewall-rules create $NETWORK-allow-rdp \
      --allow tcp:3389 \
      --network $NETWORK \
      --source-ranges 0.0.0.0/0

gcloud compute firewall-rules create $NETWORK-allow-ssh \
      --allow tcp:22 \
      --network $NETWORK \
      --source-ranges 0.0.0.0/0

gcloud compute firewall-rules create $NETWORK-allow-healthz \
      --allow tcp:8080 \
      --network $NETWORK \
      --source-ranges 130.211.0.0/22

gcloud compute firewall-rules create $NETWORK-allow-api-server \
      --allow tcp:6443 \
      --network $NETWORK \
      --source-ranges 0.0.0.0/0

gcloud compute addresses create $ADDRESS_NAME --region=us-central1
