#!/usr/bin/env bash

trap "exit 1" TERM
export TOP_PID=$$

export project_name_cicd="labs-ci-cd-$(date +'%d%m%Y')"
export project_name_dev="labs-dev-$(date +'%d%m%Y')"
export project_name_test="labs-test-$(date +'%d%m%Y')"

install() {
  echo "install - $(pwd)"

  sed -i "0,/labs-ci-cd/s/labs-ci-cd/${project_name_cicd}/" values.yaml
  sed -i "0,/labs-dev/s/labs-dev/${project_name_dev}/" values.yaml
  sed -i "0,/labs-test/s/labs-test/${project_name_test}/" values.yaml

  oc new-project ${project_name}
  helm template bootstrap-project --skip-tests . | oc apply -f -
}

test() {
  echo "test - $(pwd)"

  timeout 2m bash <<"EOT"
  run() {
    echo "Attempting oc get project/${project_name_cicd}"

    while [[ $(oc get project/${project_name_cicd} -o name) != "project.project.openshift.io/${project_name_cicd}" ]]; do
      sleep 10
    done
  }

  run
EOT

  if [[ $? != 0 ]]; then
    echo "OC timed-out. Failing"

    oc get projects
    exit 1
  fi

  echo "Test complete"
}

cleanup() {
  echo "cleanup - $(pwd)"
  oc delete project/${project_name_cicd}
  oc delete project/${project_name_dev}
  oc delete project/${project_name_test}
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
