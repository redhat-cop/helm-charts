#!/bin/bash

REPO=$1
BRANCH=$2

if [ -z "$REPO" ]; then
    echo 'Please specify the URL for the git repository to deploy!'
    exit 10
fi

if [ -z "$BRANCH" ]; then
    BRANCH=master
fi

NAME=$(echo $REPO | rev | cut -d '/' -f 1 | rev | cut -d '.' -f 1 | tr '[:upper:]' '[:lower:]')
REVISION=$(git ls-remote $REPO | grep refs/heads/$BRANCH | awk '{print $1}')

CMD=install
EXISTING=$(helm list --short --filter $NAME)
if [ ! -z "$EXISTING" ]; then
    CMD=upgrade
fi

# echo "deploying with options: helm $CMD $NAME ./chart --set repo.location=$REPO,repo.branch=$BRANCH,repo.revision=$REVISION"
helm $CMD $NAME ./chart --set "repo.location=$REPO,repo.branch=$BRANCH,repo.revision=$REVISION"