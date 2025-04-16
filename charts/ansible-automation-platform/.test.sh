#!/usr/bin/env bash

trap "exit 1" TERM
export TOP_PID=$$

export project_name="ansible-automation-platform-$(date +'%d%m%Y')"

install() {
  echo "install - $(pwd)"

  oc new-project ${project_name}
  helm upgrade --install ansible-automation-platform -f values.yaml --set namespace=${project_name} . --namespace ${project_name}
}

test() {
  echo "test - $(pwd)"

  timeout 2m bash <<"EOT"
  run() {
    echo "Attempting oc get deploymentansible-automation-platform"

    while [[ $(oc get deployment/ansible-automation-platform -o name -n ${project_name}) != 'deployment.apps/ansible-automation-platform' ]]; do
      sleep 10
    done
  }

  run
EOT

  oc rollout status deployment/ansible-automation-platform -n ${project_name} --watch=true

  timeout 2m bash <<"EOT"
  run() {
    host=$(oc get route/ansible-automation-platform -o jsonpath='{.spec.host}' -n ${project_name})
    echo "Attempting $host"

    while [[ $(curl -L -k -s -o /dev/null -w '%{http_code}' http://${host}) != '200' ]]; do
      sleep 10
    done
  }

  run
EOT

  if [[ $? != 0 ]]; then
    echo "CURL timed-out. Failing"

    host=$(oc get route/ansible-automation-platform -o jsonpath='{.spec.host}' -n ${project_name})
    curl -L -k -vvv "http://${host}"
    exit 1
  fi

  echo "Test complete"
}

cleanup() {
  echo "cleanup - $(pwd)"
  helm uninstall ansible-automation-platform --namespace ${project_name}
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
