#! /bin/bash
set -x

bash subnets/teardown.sh

bash worker/teardown.sh &
bash controller/teardown.sh &
wait

bash network/teardown.sh
