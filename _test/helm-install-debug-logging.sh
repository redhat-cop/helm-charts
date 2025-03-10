#!/bin/bash

TEST_NAMESPACE=$1

echo
echo "### Get Pods ###"
kubectl get pods --namespace ${TEST_NAMESPACE}

echo
echo "### Describe Pods ###"
kubectl describe pods --namespace ${TEST_NAMESPACE}

echo
echo "### Dump Pods Logs for debugging ###"
kubectl get pods --namespace ${TEST_NAMESPACE} --output name  2>&1 | tee pods.csv
while read pod || [ -n "${pod}" ]; do
    kubectl logs ${pod} --namespace ${TEST_NAMESPACE}
done < <(sort -u pods.csv)

echo
echo "### Get Jobs ###"
kubectl get jobs --namespace ${TEST_NAMESPACE}

echo
echo "### Describe Jobs ###"
kubectl describe jobs --namespace ${TEST_NAMESPACE}

echo
echo "### Dump Jobs Logs for debugging ###"
kubectl get jobs --namespace ${TEST_NAMESPACE} --output name  2>&1 | tee jobs.csv
while read job || [ -n "${job}" ]; do
    kubectl logs job/${pod} --namespace ${TEST_NAMESPACE}
done < <(sort -u jobs.csv)
