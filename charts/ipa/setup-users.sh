#!/bin/bash

IPA_NAMESPACE="${1:-biscuits}"
IPA_RELEASE_NAME="${2:-my}"

# 1. oc get pod name for freeipa and oc rsh to it...
oc project ${IPA_NAMESPACE}
oc rsh `oc get po -l deploymentconfig=${IPA_RELEASE_NAME}-ipa -o name -n ${IPA_NAMESPACE}`


# 2. on the container running IPA Server
echo 'Passw0rd' | kinit admin
export GROUP_NAME=student
ipa group-add ${GROUP_NAME} --desc "TL500 Other" || true
# in a loop add random users to the group 
for i in {1..24};do
  export LAB_NUMBER="lab$i"
  printf "\n\nI is user login ${LAB_NUMBER}"
  PASSWD=$(ipa user-add ${LAB_NUMBER} --first=${LAB_NUMBER} --last=${LAB_NUMBER} --email=${LAB_NUMBER}@redhatlabs.dev --random | grep Random)
  printf "My creds are ${PASSWD}\n\n"  
  ipa group-add-member ${GROUP_NAME} --users=$LAB_NUMBER
done