#!/usr/bin/env bash

CHARTS_CHANGED=()
changed=$(ct list-changed --target-branch main)
for chart in ${changed}; do
  echo "Chart has changes: ${chart}"

  hasVersionBumped=$(git --no-pager diff "${chart}/Chart.yaml" | grep "+version" | wc -l)
  if [[ "${hasVersionBumped}" -eq 0 ]]; then
    echo "-> Version has not been bumped. Bumping to:"
    pybump bump --file "${chart}/Chart.yaml" --level patch

    CHARTS_CHANGED+=("${chart}/Chart.yaml")
  fi

  echo
done

echo "CHARTS=$(echo ${CHARTS_CHANGED[*]})" >> $GITHUB_OUTPUT
