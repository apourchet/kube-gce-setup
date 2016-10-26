#! /bin/bash

NETWORK=$(cat config.json | jq -r '.network')

nodes=$(kubectl get nodes --output=jsonpath='{range .items[*]}{.status.addresses[?(@.type=="InternalIP")].address}:{.spec.podCIDR} {"\n"}{end}')

for node in $nodes; do 
    hop=$(echo $node | cut -d ':' -f 1)
    dest=$(echo $node | cut -d ':' -f 2)
    name=${dest//./-}
    name=${name//\//-}
    echo $name" = "$hop" => "$dest

    gcloud compute routes create kubernetes-route-$name \
      --network $NETWORK \
      --next-hop-address $hop \
      --destination-range $dest 
done

