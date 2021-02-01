#!/bin/bash

oc delete tsscplatforms tsscplatform --wait
helm uninstall ploigos --namespace devsecops
oc delete all --all -n devsecops
oc delete project devsecops
