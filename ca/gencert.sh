#! /bin/bash


# [ -z "$1" ] && echo "Usage: gencert.sh <host>" && exit 1

ADDRESS_NAME=$(cat ../config.json | jq -r '.address_name')
KUBERNETES_PUBLIC_ADDRESS=$(gcloud compute addresses describe $ADDRESS_NAME --format 'value(address)') 

cat > kubernetes-csr.json <<EOF
{
  "CN": "kubernetes",
  "hosts": [
    "etcd0",
    "worker0",
    "worker1",
    "worker2",
    "ip-10-240-0-20",
    "ip-10-240-0-21",
    "ip-10-240-0-22",
    "10.32.0.1",
    "10.240.0.10",
    "10.240.0.11",
    "10.240.0.12",
    "10.240.0.20",
    "10.240.0.21",
    "10.240.0.22",
    "${KUBERNETES_PUBLIC_ADDRESS}",
    "127.0.0.1"
  ],
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "San Francisco",
      "O": "Kubernetes",
      "OU": "Cluster",
      "ST": "CA"
    }
  ]
}
EOF

cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=kubernetes kubernetes-csr.json \
    | cfssljson -bare kubernetes
