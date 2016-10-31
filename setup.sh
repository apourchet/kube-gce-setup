#! /bin/bash
set -x

# PART 0: Gcloud config
gcloud config set disable_usage_reporting True

gcloud config set account $(cat config.json | jq -r '.account')
gcloud config set project $(cat config.json | jq -r '.project')

# Order of setup
# - Auth generate new token
# - Network setup.sh
# - CA gencert.sh
# - Controller setup.sh
# - Worker setup.sh
# - Kubectl config.sh
# - Subnets setup.sh

bash ./auth/gentoken.sh ./auth/token.csv

bash network/setup.sh
cd ca && bash gencert.sh && cd -
bash ./controller/setup.sh
bash ./worker/setup.sh
bash ./kubectl/config.sh
bash ./subnets/setup.sh
