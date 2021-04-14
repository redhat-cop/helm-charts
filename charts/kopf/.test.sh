#!/usr/bin/env bash

trap "exit 1" TERM
export TOP_PID=$$

export project_name="kopf-$(date +'%d%m%Y')"

install() {
  echo "install - $(pwd)"

  oc new-project ${project_name}
  helm install kopf .
}

test() {
  echo "test - $(pwd)"


  for i in clusterkopfpeerings.kopf.dev kopfpeerings.kopf.dev; do
	  oc get crd $i
	  if [[ $? != 0 ]]; then
		  echo "CRD: $i not present"
		  exit 1
	 fi
  done

  echo "Test complete"
}

cleanup() {
  echo "cleanup - $(pwd)"
  helm uninstall kopf
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
