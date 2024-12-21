#!/bin/bash

# Define the repository URL and branch name
REPO_URL="https://github.com/CodesByPankaj/cs-stock.git"
BRANCH="test1"
REPO_DIR="repo"
SPARSE_PATH="src/main/java/stock_management/cs_stock"

# Clone the repository with no checkout and filtering
git clone --no-checkout --filter=blob:none --branch $BRANCH $REPO_URL $REPO_DIR

# Navigate into the repository directory
cd $REPO_DIR || exit 1

# Checkout the specified branch
git checkout $BRANCH

# Initialize sparse-checkout in cone mode
git sparse-checkout init --cone

# Set the sparse-checkout path
git sparse-checkout set $SPARSE_PATH

# Pull the latest changes from the specified branch
git pull origin $BRANCH

# Navigate into the sparse-checked-out path
cd $SPARSE_PATH || exit 1

# Adjust sparse-checkout settings with --skip-checks
git sparse-checkout set $SPARSE_PATH --skip-checks

# List the contents of the directory
ls -la



















# main() {
#     # Check if the number of arguments is less than 1 or greater than 2
#     if [[ $# -lt 1 || $# -gt 2 ]]; then
#         echo "Usage: $0 [BRANCH] <SUBSYSTEM>"
#         exit 1
#     fi

#     # Assign arguments to variables
#     local BRANCH=$1
#     local SUBSYSTEM=$2

#     # GitHub Personal Access Token (replace with your token)
#     local PAT="YOUR-PAT-TOKEN"

#     # GitHub repository URL with PAT for authentication
#     GITHUB_REPO_URL="https://$PAT@github.com/CodesByPankaj/cs-stock.git"
#     TEMP_DIR=$(mktemp -d)  # Create a temporary directory for cloning

#     # Enable sparse checkout
#     git clone --filter=blob:none --no-checkout "$GITHUB_REPO_URL" "$TEMP_DIR"
#     cd "$TEMP_DIR" || exit

#     # Enable sparse checkout
#     git sparse-checkout init --cone
#     git sparse-checkout set \
#         "src/main/java/stock_management/cs_stock/CsStockApplication.java" \
#         "src/main/java/stock_management/cs_stock/abc.tx" \
#         "src/main/java/stock_management/cs_stock/Create abc.tx" \
#         "src/main/java/stock_management/cs_stock/javaPs.config" \
#         "src/main/java/stock_management/cs_stock/token.jks" \
#         "src/main/java/stock_management/cs_stock/case study"

#     # Checkout the specified branch
#     git checkout "$BRANCH"

#     # Move the files to the desired location
#     TARGET_DIR="${HOME}/gitconfigs"
#     mkdir -p "$TARGET_DIR"
#     mv src/main/java/stock_management/cs_stock/* "$TARGET_DIR"

#     # Clean up the temporary clone
#     cd "$TARGET_DIR" || exit
#     rm -rf "$TEMP_DIR"

#     # Verify that all files are present
#     if [ -f "$TARGET_DIR/CsStockApplication.java" ] &&
#        [ -f "$TARGET_DIR/abc.tx" ] &&
#        [ -f "$TARGET_DIR/Create abc.tx" ] &&
#        [ -f "$TARGET_DIR/javaPs.config" ] &&
#        [ -f "$TARGET_DIR/token.jks" ] &&
#        [ -d "$TARGET_DIR/case study" ]; then
#         echo "All specified files and directories downloaded successfully."
#     else
#         echo "Error: One or more files or directories not found after checkout."
#         exit 1
#     fi
# }

# # Call the main function and pass all script arguments
# main "$@"










# main() {
#     # Check if the number of arguments is less than 1 or greater than 2
#     if [[ $# -lt 1 || $# -gt 2 ]]; then
#         echo "Usage: $0 [BRANCH] <SUBSYSTEM>"
#         exit 1
#     fi

#     # Assign arguments to variables
#     local BRANCH=$1
#     local SUBSYSTEM=$2

#     # GitHub Personal Access Token (replace with your token)
#     local PAT="YOUR-PAT-TOKEN"

#     # GitHub repository URL with PAT for authentication
#     GITHUB_REPO_URL="https://$PAT@github.com/CodesByPankaj/cs-stock.git"
#     CLONE_DIR="${HOME}/gitconfigs"

#     # Check if the clone directory exists, if not create it
#     if [ ! -d "$CLONE_DIR" ]; then 
#         mkdir -p "$CLONE_DIR"
#     fi

#     # Change to the clone directory
#     cd "$CLONE_DIR"

#     # Initialize git repository and set remote origin
#     git init
#     git remote add origin "$GITHUB_REPO_URL"

#     # Enable sparse checkout and configure proxy (if needed)
#     git config core.sparseCheckout true
#     # git config --global http.proxy http://zproxy.schwab.com:9400

#     # Set up sparse checkout to include files from the subdirectory, but exclude directories
#     echo "$SUBSYSTEM/*" > .git/info/sparse-checkout   # Includes all files
#     echo "!$SUBSYSTEM/*/" >> .git/info/sparse-checkout  # Exclude all directories

#     # Pull the branch from the origin, downloading only the sparse files
#     git pull origin "$BRANCH"

#     # Now, ensure that the directory structure for the SUBSYSTEM exists
#     if [ -d "$SUBSYSTEM" ]; then
#         # Remove all directories that may have been downloaded
#         find "$SUBSYSTEM" -type d -exec rm -rf {} +

#         # Ensure that only files are kept in the subdirectory
#         echo "Files from '$SUBSYSTEM' downloaded successfully."
#     else
#         echo "Error: Directory '$SUBSYSTEM' not found after checkout."
#         exit 1
#     fi

#     # Clean up by removing the .git folder (optional)
#     rm -rf .git

#     # Optional: You can remove all files that aren't part of the sparse checkout
#     # rm -rf ./*

#     # You can also clean up by removing the clone directory if you want
#     # rmdir "$CLONE_DIR"
# }

# # Call the main function and pass all script arguments
# main "$@"

















# Original Script
# main() {

#     # Check if the number of arguments is less than 1 or greater than 2
#     if [[ $# -lt 1 || $# -gt 2 ]]; then
#         echo "Usage: $0 [BRANCH] <SUBSYSTEM>"
#         exit 1
#     fi

#     # Assign arguments to variables
#     local  =$1
#     local SUBSYSTEM=$2

#     # GitHub Personal Access Token (replace with your token)
#     local PAT="YOUR-PAT-TOKEN"

#     # GitHub repository URL with PAT for authentication
#     GITHUB_REPO_URL="https://$PAT@github.com/CodesByPankaj/cs-stock.git"
#     CLONE_DIR="${HOME}/gitconfigs"

#     # Check if the clone directory exists, if not create it
#     if [ ! -d "$CLONE_DIR" ]; then 
#         mkdir -p "$CLONE_DIR"
#     fi

#     # Change to the clone directory
#     cd "$CLONE_DIR"

#     # Initialize git repository and set remote origin
#     git init
#     git remote add origin "$GITHUB_REPO_URL"

#     # Enable sparse checkout and configure proxy (if needed)
#     git config core.sparseCheckout true
#    # git config --global http.proxy http://zproxy.schwab.com:9400

#     # Set up sparse checkout to only checkout the specified SUBSYSTEM (file or directory)
#     echo "$SUBSYSTEM" > .git/info/sparse-checkout

#     # Pull the branch from the origin, downloading only the sparse files
#     git pull origin "$BRANCH"

#     # Now, ensure that the directory structure for the SUBSYSTEM exists
#     if [ -f "$SUBSYSTEM" ]; then
#         echo "File '$SUBSYSTEM' downloaded successfully."
#     else
#         echo "Error: File '$SUBSYSTEM' not found after checkout."
#         exit 1
#     fi

#     # Clean up by removing the .git folder (optional)
#     rm -rf .git

#     # Optional: You can remove all files that aren't part of the sparse checkout
#     # rm -rf ./*

#     # You can also clean up by removing the clone directory if you want
#     # rmdir "$CLONE_DIR"
# }

# # Call the main function and pass all script arguments
# main "$@"

