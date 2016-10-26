#! /bin/bash

NETWORK=$(cat config.json | jq -r '.network')
SUBNET=$(cat config.json | jq -r '.subnet')
ADDRESS_NAME=$(cat config.json | jq -r '.address_name')

gcloud -q compute addresses delete $ADDRESS_NAME

gcloud -q compute firewall-rules delete \
  $NETWORK-allow-api-server \
  $NETWORK-allow-healthz \
  $NETWORK-allow-icmp \
  $NETWORK-allow-internal \
  $NETWORK-allow-rdp \
  $NETWORK-allow-ssh

gcloud -q compute networks subnets delete $SUBNET 

gcloud -q compute networks delete $NETWORK
