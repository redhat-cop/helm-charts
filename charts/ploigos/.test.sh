#!/usr/bin/env bash

trap "exit 1" TERM
export TOP_PID=$$

export project_name="ploigos1-$(date +'%d%m%Y')"

install() {
  echo "install - $(pwd)"

  oc new-project ${project_name}
  helm upgrade --install ploigos -f values.yaml --set-string operator.namespaces[0].name=${project_name} . --namespace ${project_name}
}

test() {
  echo "test - $(pwd)"

  timeout 2m bash <<"EOT"
  run() {
    echo "Attempting oc get deployment/tssc-operator-controller-manager"

    while [[ $(oc get deployment/tssc-operator-controller-manager -o name -n ${project_name}) != 'deployment.apps/tssc-operator-controller-manager' ]]; do
      sleep 10
    done
  }

  run
EOT

  oc rollout status Deployment/tssc-operator-controller-manager -n ${project_name} --watch=true
}

cleanup() {
  echo "cleanup - $(pwd)"
  oc delete tsscplatforms/tsscplatform --wait -n ${project_name}
  helm uninstall ploigos --namespace ${project_name}
  oc delete all --all -n ${project_name}
  oc delete project/${project_name}
}

# Process arguments
case $1 in
  install)
    install
    ;;
  test)
    test
    ;;
  cleanup)
    cleanup
    ;;
  *)
    echo "Not an option"
    exit 1
esac
