#!/usr/bin/env bash

trap "exit 1" TERM
export TOP_PID=$$

export project_name="stackrox-$(date +'%d%m%Y')"

install() {
  echo "install - $(pwd)"

  oc new-project ${project_name}
  helm template stackrox --skip-tests --set stackrox.namespace=${project_name} . | oc apply -f -
}

test() {
  echo "test - $(pwd)"

  timeout 5m bash <<"EOT"
  run() {
    echo "Checking Central pod deployed ..."
    while test 0 == $(oc -n ${project_name} get pod -l app.kubernetes.io/component=central -o name 2>/dev/null | wc -l); do echo "checking ..." && sleep 10; done
  }

  run
EOT

  if [[ $? != 0 ]]; then
    echo "Failed to find Central pod in ns: ${project_name} - failed, exiting."
    exit 1
  fi

  timeout 2m bash <<"EOT"
  run() {
    echo "Checking a SecuredCluster deployed ..."
    while test 0 == $(oc -n ${project_name} get securedcluster -o name 2>/dev/null | wc -l); do echo "checking ..." && sleep 10; done
  }

  run
EOT

  if [[ $? != 0 ]]; then
    echo "Failed to find a SecuredCluster in ns: ${project_name} - failed, exiting."
    exit 1
  fi

  echo "Test complete"
}

cleanup() {
  echo "cleanup - $(pwd)"
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
