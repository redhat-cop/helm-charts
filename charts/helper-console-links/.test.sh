#!/usr/bin/env bash

trap "exit 1" TERM
export TOP_PID=$$

export argocd_link_name="argocd-server-$(date +'%d%m%Y')"
export nexus_link_name="nexus-$(date +'%d%m%Y')"

install() {
  echo "install - $(pwd)"

  helm template helper-console-links --skip-tests --values values.yaml --set-string section[0].urls[0].name=${argocd_link_name} --set-string section[0].urls[1].name=${nexus_link_name} . | oc apply -f -
}

test() {
  echo "test - $(pwd)"

  timeout 2m bash <<"EOT"
  run() {
    echo "Attempting oc get consolelink/${argocd_link_name}"

    while [[ $(oc get consolelink/${argocd_link_name} -o name) != "consolelink.console.openshift.io/${argocd_link_name}" ]]; do
      sleep 10
    done
  }

  run
EOT

  if [[ $? != 0 ]]; then
    echo "OC timed-out. Failing"

    oc get consolelink
    exit 1
  fi

  echo "Test complete"
}

cleanup() {
  echo "cleanup - $(pwd)"
  oc delete consolelink/${argocd_link_name}
  oc delete consolelink/${nexus_link_name}
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
