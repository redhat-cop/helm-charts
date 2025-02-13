#!/usr/bin/env bash

trap "exit 1" TERM
export TOP_PID=$$

export project_name="network-policy-$(date +'%d%m%Y')"

install() {
  echo "install - $(pwd)"

  oc new-project ${project_name}
  helm template network-policy --skip-tests . | oc apply -f -
}

test() {
  echo "test - $(pwd)"

  timeout 2m bash <<"EOT"
  run() {
    echo "Attempting oc get networkpolicy/deny-all-by-default -n ${project_name}"

    while [[ $(oc get networkpolicy/deny-all-by-default -o name -n ${project_name}) != "networkpolicy.networking.k8s.io/deny-all-by-default" ]]; do
      sleep 10
    done
  }

  run
EOT

  if [[ $? != 0 ]]; then
    echo "OC timed-out. Failing"

    oc get networkpolicy -n ${project_name}
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
