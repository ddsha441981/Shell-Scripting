#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 3 ]; then
  echo "Usage: $0 <repository_url> <branch_name> <file_path_to_checkout>"
  exit 1
fi

# Assign arguments to variables
REPO_URL=$1
BRANCH_NAME=$2
FILE_PATH=$3

# Step 1: Initialize a new Git repository
echo "Initializing a new Git repository..."
git init

# Step 2: Add the remote repository URL
echo "Adding remote repository URL: $REPO_URL"
git remote add origin "$REPO_URL"

# Step 3: Enable sparse checkout
echo "Enabling sparse checkout..."
git config core.sparseCheckout true

# Step 4: Create the .git/info/sparse-checkout file and add the specified file path
echo "Setting sparse checkout path for: $FILE_PATH"
echo "$FILE_PATH" >> .git/info/sparse-checkout

# Step 5: Pull the specified branch from the remote repository
echo "Pulling branch $BRANCH_NAME from remote origin..."
git pull origin "$BRANCH_NAME"

# Notify user of success
echo "Sparse checkout completed for file: $FILE_PATH from branch: $BRANCH_NAME"
