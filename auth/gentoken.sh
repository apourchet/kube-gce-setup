#! /bn/bash

[ -z "$1" ] && echo "Usage: gentoken <token-csv-path>" && exit 1
admin=$(cat /dev/random | env LC_ALL=C tr -cd 'a-zA-Z0-9' | head -c 15)
scheduler=$(cat /dev/random | env LC_ALL=C tr -cd 'a-zA-Z0-9' | head -c 15)
kubelet=$(cat /dev/random | env LC_ALL=C tr -cd 'a-zA-Z0-9' | head -c 15)

echo "$admin,admin,admin" > $1
echo "$scheduler,scheduler,scheduler" >> $1
echo "$kubelet,kubelet,kubelet" >> $1
