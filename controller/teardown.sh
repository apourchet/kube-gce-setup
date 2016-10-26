#! /bin/bash

gcloud -q compute instances delete controller0
gcloud -q compute forwarding-rules delete kubernetes-rule
gcloud -q compute target-pools delete kubernetes-pool
gcloud -q compute http-health-checks delete kube-apiserver-check
