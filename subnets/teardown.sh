#! /bin/bash

nodes=$(kubectl get nodes --output=jsonpath='{range .items[*]}{.status.addresses[?(@.type=="InternalIP")].address}:{.spec.podCIDR} {"\n"}{end}')

names=""
for node in $nodes; do 
    hop=$(echo $node | cut -d ':' -f 1)
    dest=$(echo $node | cut -d ':' -f 2)
    name=${dest//./-}
    name=${name//\//-}
    names=$names" kubernetes-route-"$name
done

gcloud -q compute routes delete $names
