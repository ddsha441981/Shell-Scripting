#!/bin/bash

# Set variables
GITHUB_REPO_URL="https://<your-token>@github.com/<username>/<repo>.git"
BRANCH="master"
SPARSE_MODE="$1"  # Accept depth as the first argument
DOWNLOAD_DIR="./downloaded-files"

# Clone repo without checkout
git clone --no-checkout --filter=blob:none --branch $BRANCH $GITHUB_REPO_URL repo
cd repo || exit

# Initialize sparse-checkout
git sparse-checkout init --cone

# Set sparse-checkout depth based on user input
case "$SPARSE_MODE" in
    empty)
        git sparse-checkout set '' ;;
    files)
        git sparse-checkout set '/*' ;;
    immediates)
        git sparse-checkout set '/*' '/*/*' ;;
    infinity)
        git sparse-checkout disable ;;
    *)
        echo "Invalid mode. Use one of: empty, files, immediates, infinity."
        exit 1 ;;
esac

# Pull files based on sparse-checkout rules
git pull origin $BRANCH

# Move files to download directory
mkdir -p "$DOWNLOAD_DIR"
mv * "$DOWNLOAD_DIR" 2>/dev/null || echo "No files to move."

# Clean up
cd ..
rm -rf repo
echo "Sparse checkout completed. Files downloaded to: $DOWNLOAD_DIR"
