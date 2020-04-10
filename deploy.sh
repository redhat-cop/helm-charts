#!/bin/bash


function usage() {
    echo
    echo "Usage:"
    echo " $0 [options]"
    echo " $0 --help"
    echo
    echo "Example:"
    echo " $0 --repo https://your-repo.git"
    echo
    echo "OPTIONS:"
    echo "   --repo       HTTP(s) based URL of your git repository"
    echo "   --branch     Name of branch that should be deployed"
    echo "   --settings       Additional settings you want to pass to the helm chart"
    echo
}

REPO=
BRANCH=master
SETTINGS=


while :; do
    case $1 in
        --repo)
            if [ -n "$2" ]; then
                REPO=$2
                shift
            else
                printf 'Error: "--repo" requires a non-empty value.\n' >&2
                usage
                exit 255
            fi
            ;;
        --branch)
            if [ -n "$2" ]; then
                BRANCH=$2
                shift
            else
                printf 'Error: "--branch" requires a non-empty value.\n' >&2
                usage
                exit 255
            fi
            ;;
        --settings)
            if [ -n "$2" ]; then
                SETTINGS=",$2"
                shift
            fi
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        --)
            shift
            break
            ;;
        -?*)
            printf 'WARN: Unknown option (ignored): %s\n' "$1" >&2
            shift
            ;;
        *) # Default case: If no more options then break out of the loop.
            break
    esac

    shift
done



if [ -z "$REPO" ]; then
    usage
    exit 255
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

SETTINGS_STR=
if [ ! -z "$SETTINGS" ]; then
    SETTINGS_STR=',***'
fi

echo 'Executing helm command: '
echo "    helm $CMD $NAME ./chart --set 'repo.location=$REPO,repo.branch=$BRANCH,repo.revision=$REVISION$SETTINGS_STR'"
helm $CMD $NAME ./chart --set "repo.location=$REPO,repo.branch=$BRANCH,repo.revision=$REVISION$SETTINGS"