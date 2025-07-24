#!/usr/bin/env bash
set -e

# Use environment variables
PYTHON_INDEX_URL=${PYTHON_INDEX_URL:-https://pypi.org/simple/}
PYTHON_EXTRA_INDEX_URL=${PYTHON_EXTRA_INDEX_URL:-https://pypi.org/simple/}
IGNORE_SSL_ERRORS=${IGNORE_SSL_ERRORS:-false}

# Extract hostnames
INDEX_HOST=$(echo $PYTHON_INDEX_URL | sed 's|https\?://||' | cut -d'/' -f1)
EXTRA_INDEX_HOST=$(echo $PYTHON_EXTRA_INDEX_URL | sed 's|https\?://||' | cut -d'/' -f1)

echo "PYTHON_INDEX_URL: $PYTHON_INDEX_URL"
echo "PYTHON_EXTRA_INDEX_URL: $PYTHON_EXTRA_INDEX_URL"
echo "TRUST_HOSTS: $TRUST_HOSTS"

# Build trusted-host arguments conditionally
if [ "$TRUST_HOSTS" = "true" ]; then
    TRUSTED_HOST_ARGS="--trusted-host pypi.org --trusted-host pypi.python.org --trusted-host files.pythonhosted.org --trusted-host $INDEX_HOST --trusted-host $EXTRA_INDEX_HOST"
    echo "SSL verification disabled for pip"
else
    TRUSTED_HOST_ARGS=""
    echo "SSL verification enabled for pip"
fi

echo "Creating virtual environment..."
python3 -m venv /tmp/venv

echo "Activating virtual environment and installing packages..."
source /tmp/venv/bin/activate

echo "Upgrading pip..."
python3 -m pip install --upgrade pip $TRUSTED_HOST_ARGS

echo "Installing packages..."
python3 -m pip install openshift-client semver==2.13.0 \
    $TRUSTED_HOST_ARGS \
    --index-url $PYTHON_INDEX_URL \
    --extra-index-url $PYTHON_EXTRA_INDEX_URL

echo "Installation completed successfully!"