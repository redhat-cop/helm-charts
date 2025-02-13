#!/usr/bin/env bash

run() {
  echo "Running helm for all..."

  for file in $(find . -name ".test.sh" -type f | sort | xargs); do
    pushd $(dirname $file) > /dev/null

    echo ""
    echo "## $(pwd)"
    echo ""

    ./.test.sh install || exit $?
    ./.test.sh test || exit $?
    ./.test.sh cleanup || exit $?

    popd > /dev/null
  done

  echo "Done testing all charts."
}

run
