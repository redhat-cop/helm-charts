#!/usr/bin/env bash
set -e

# Use environment variables instead of positional parameters
PYTHON_INDEX_URL=${PYTHON_INDEX_URL:-https://pypi.org/simple/}
PYTHON_EXTRA_INDEX_URL=${PYTHON_EXTRA_INDEX_URL:-https://pypi.org/simple/}

# Extract hostnames
INDEX_HOST=$(echo $PYTHON_INDEX_URL | sed 's|https\?://||' | cut -d'/' -f1)
EXTRA_INDEX_HOST=$(echo $PYTHON_EXTRA_INDEX_URL | sed 's|https\?://||' | cut -d'/' -f1)

echo "PYTHON_INDEX_URL: $PYTHON_INDEX_URL"
echo "PYTHON_EXTRA_INDEX_URL: $PYTHON_EXTRA_INDEX_URL"
echo "INDEX_HOST: $INDEX_HOST"
echo "EXTRA_INDEX_HOST: $EXTRA_INDEX_HOST"

echo "Creating virtual environment..."
python3 -m venv /tmp/venv

echo "Activating virtual environment and installing packages..."
source /tmp/venv/bin/activate

echo "Upgrading pip..."
python3 -m pip install --upgrade pip \
    --trusted-host pypi.org \
    --trusted-host pypi.python.org \
    --trusted-host files.pythonhosted.org \
    --trusted-host $INDEX_HOST \
    --trusted-host $EXTRA_INDEX_HOST

echo "Installing packages..."
python3 -m pip install openshift-client semver==2.13.0 \
    --trusted-host pypi.org \
    --trusted-host pypi.python.org \
    --trusted-host files.pythonhosted.org \
    --trusted-host $INDEX_HOST \
    --trusted-host $EXTRA_INDEX_HOST \
    --index-url $PYTHON_INDEX_URL \
    --extra-index-url $PYTHON_EXTRA_INDEX_URL

echo "Installation completed successfully!"