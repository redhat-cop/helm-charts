#!/usr/bin/env bash

trap "exit 1" TERM
export TOP_PID=$$

export project_name="sonarqube-$(date +'%d%m%Y')"

install() {
  echo "install - $(pwd)"

  oc new-project ${project_name}
  helm upgrade --install sonarqube . --namespace ${project_name}
}

test() {
  echo "test - $(pwd)"

  oc rollout status Deployment/sonarqube-sonarqube -n ${project_name} --watch=true

  timeout 2m bash <<"EOT"
  run() {
    host=$(oc get route/sonarqube -o jsonpath='{.spec.host}' -n ${project_name})
    echo "Attempting $host"

    while [[ $(curl -L -k -s -o /dev/null -w '%{http_code}' http://${host}) != '200' ]]; do
      sleep 10
    done
  }

  run
EOT

  if [[ $? != 0 ]]; then
    echo "CURL timed-out. Failing"

    host=$(oc get route/sonarqube -o jsonpath='{.spec.host}' -n ${project_name})
    curl -L -k -vvv "http://${host}"
    exit 1
  fi

  echo "Test complete"
}

cleanup() {
  echo "cleanup - $(pwd)"
  helm uninstall sonarqube --namespace ${project_name}
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
