#! /bin/bash

INGRESS_ADDRESS_NAME=$(cat config.json | jq -r '.ingress_address_name')
NUM_WORKERS=$(cat config.json | jq -r '.num_workers')
[ -z "$NUM_WORKERS" ] && NUM_WORKERS=1

worker_names=""
for i in $(seq -w $NUM_WORKERS); do
    worker_names=$worker_names"worker"$i" "
done

gcloud -q compute instances delete $worker_names
