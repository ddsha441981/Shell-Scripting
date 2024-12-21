#!/bin/bash

# Repository details
GITHUB_USERNAME="your_github_username"  # Replace with your GitHub username
PAT="YOUR-PAT-TOKEN"          # Replace with your PAT
REPO_URL="https://${GITHUB_USERNAME}:${PAT}@github.com/CodesByPankaj/cs-stock.git"
BRANCH="master"  # Keep this as master if that's the correct branch
SPARSE_PATH="src/main/java/stock_management/cs_stock/util"  # Ensure this path is correct

# Clone the repository without checking out files
echo "Cloning repository with sparse mode..."
git clone --no-checkout --filter=blob:none --branch "$BRANCH" "$REPO_URL" repo || { echo "Failed to clone repository."; exit 1; }

# Navigate to the cloned repository
cd repo || { echo "Failed to enter repository directory."; exit 1; }

# Initialize sparse-checkout
echo "Initializing sparse-checkout..."
git sparse-checkout init --cone || { echo "Failed to initialize sparse-checkout."; exit 1; }

# Specify the files or directories for sparse-checkout
echo "Configuring sparse-checkout to fetch: $SPARSE_PATH..."
git sparse-checkout set "$SPARSE_PATH" || { echo "Failed to set sparse-checkout paths."; exit 1; }

# Pull the required files
echo "Pulling required files..."
git pull origin "$BRANCH" || { echo "Failed to pull files."; exit 1; }

# Debugging: List fetched files
echo "Listing fetched files..."
ls -R

# All files are now inside the `repo` folder
echo "All fetched files are inside the 'repo' folder."

# Go back to the parent directory
cd ..
echo "Sparse clone and cleanup completed successfully."










# #!/bin/bash

# # Repository details
# REPO_URL="https://github.com/CodesByPankaj/cs-stock.git"
# BRANCH="master"
# SPARSE_PATH="src/main/java/stock_management/cs_stock/util"  # Adjust this path

# # Clone the repository without checking out files
# echo "Cloning repository with sparse mode..."
# git clone --no-checkout --filter=blob:none --branch "$BRANCH" "$REPO_URL" repo || { echo "Failed to clone repository."; exit 1; }

# # Navigate to the cloned repository
# cd repo || { echo "Failed to enter repository directory."; exit 1; }

# # Initialize sparse-checkout
# echo "Initializing sparse-checkout..."
# git sparse-checkout init --cone || { echo "Failed to initialize sparse-checkout."; exit 1; }

# # Specify the files or directories for sparse-checkout
# echo "Configuring sparse-checkout to fetch: $SPARSE_PATH..."
# git sparse-checkout set "$SPARSE_PATH" || { echo "Failed to set sparse-checkout paths."; exit 1; }

# # Pull the required files
# echo "Pulling required files..."
# git pull origin "$BRANCH" || { echo "Failed to pull files."; exit 1; }

# # Debugging: List fetched files
# echo "Listing fetched files..."
# ls -R

# # Remove the .git folder to make the folder standalone
# # echo "Removing .git folder..."
# # rm -rf .git || { echo "Failed to remove .git folder."; exit 1; }

# # All files are now inside the `repo` folder
# echo "All fetched files are inside the 'repo' folder."

# # Go back to the parent directory
# cd ..
# echo "Sparse clone and cleanup completed successfully."














# #!/bin/bash

# # Function to display usage instructions
# usage() {
#     echo "Usage: $0 <sparse_mode>"
#     echo "sparse_mode: empty | files | immediates | infinity"
#     exit 1
# }

# # Check if the correct number of arguments is provided
# if [ "$#" -ne 1 ]; then
#     usage
# fi

# # Repository details
# REPO_OWNER="CodesByPankaj"
# REPO_NAME="cs-stock"
# PAT="YOUR-PAT-TOKEN"  # Your Personal Access Token

# # Set variables
# GITHUB_REPO_URL="https://$PAT@github.com/$REPO_OWNER/$REPO_NAME.git"
# BRANCH="master"
# SPARSE_MODE="$1"  # Accept sparse mode as the first argument
# DOWNLOAD_DIR="./downloaded-files"

# # Clone repo without checkout
# echo "Cloning repository..."
# if ! git clone --no-checkout --filter=blob:none --branch "$BRANCH" "$GITHUB_REPO_URL" repo; then
#     echo "Failed to clone repository."
#     exit 1
# fi

# cd repo || { echo "Failed to enter repository directory."; exit 1; }

# # Initialize sparse-checkout
# echo "Initializing sparse-checkout..."
# if ! git sparse-checkout init --cone; then
#     echo "Failed to initialize sparse-checkout."
#     exit 1
# fi

# # Set sparse-checkout depth based on user input
# case "$SPARSE_MODE" in
#     empty)
#         echo "Setting sparse-checkout mode to 'empty'."
#         git sparse-checkout set '' ;;
#     files)
#         echo "Setting sparse-checkout mode to 'files'."
#         git sparse-checkout set --skip-checks * ;;
#     immediates)
#         echo "Setting sparse-checkout mode to 'immediates'."
#         git sparse-checkout set --skip-checks * */* ;;
#     infinity)
#         echo "Setting sparse-checkout mode to 'infinity'."
#         git sparse-checkout disable ;;
#     *)
#         echo "Invalid mode. Use one of: empty, files, immediates, infinity."
#         exit 1 ;;
# esac

# # Pull files based on sparse-checkout rules
# echo "Pulling files from branch '$BRANCH'..."
# if ! git pull origin "$BRANCH"; then
#     echo "Failed to pull files from repository."
#     exit 1
# fi

# # Move files to download directory
# mkdir -p "$DOWNLOAD_DIR"
# echo "Moving files to $DOWNLOAD_DIR..."
# if ! find . -mindepth 1 -maxdepth 1 ! -name '.git' -exec mv {} "$DOWNLOAD_DIR/" \;; then
#     echo "No files to move or failed to move files."
# else
#     echo "Files moved to: $DOWNLOAD_DIR"
# fi

# # Clean up
# cd ..
# echo "Cleaning up temporary files..."
# rm -rf repo
# echo "Sparse checkout completed successfully."








# #!/bin/bash

# # Function to display usage
# usage() {
#     echo "Usage: $0 <sparse_mode>"
#     echo "sparse_mode: empty | files | immediates | infinity"
#     exit 1
# }



# # Check if the correct number of arguments is provided
# if [ "$#" -ne 1 ]; then
#     usage
# fi

# # Repository details
# REPO_OWNER="CodesByPankaj"
# REPO_NAME="cs-stock"
# PAT="YOUR-PAT-TOKEN"  # Your Personal Access Token

# # Set variables
# GITHUB_REPO_URL="https://$PAT@github.com/$REPO_OWNER/$REPO_NAME.git"
# BRANCH="master"
# SPARSE_MODE="$1"  # Accept sparse mode as the first argument
# DOWNLOAD_DIR="./downloaded-files"

# # Clone repo without checkout
# echo "Cloning repository..."
# if ! git clone --no-checkout --filter=blob:none --branch "$BRANCH" "$GITHUB_REPO_URL" repo; then
#     echo "Failed to clone repository."
#     exit 1
# fi

# cd repo || { echo "Failed to enter repository directory."; exit 1; }

# # Initialize sparse-checkout
# echo "Initializing sparse-checkout..."
# git sparse-checkout init --cone

# # Set sparse-checkout depth based on user input
# case "$SPARSE_MODE" in
#     empty)
#         echo "Setting sparse-checkout mode to 'empty'."
#         git sparse-checkout set '' ;;
#     files)
#         echo "Setting sparse-checkout mode to 'files'."
#         git sparse-checkout set '/*' ;;
#     immediates)
#         echo "Setting sparse-checkout mode to 'immediates'."
#         git sparse-checkout set '/*' '/*/*' ;;
#     infinity)
#         echo "Setting sparse-checkout mode to 'infinity'."
#         git sparse-checkout disable ;;
#     *)
#         echo "Invalid mode. Use one of: empty, files, immediates, infinity."
#         exit 1 ;;
# esac

# # Pull files based on sparse-checkout rules
# echo "Pulling files from branch '$BRANCH'..."
# if ! git pull origin "$BRANCH"; then
#     echo "Failed to pull files from repository."
#     exit 1
# fi

# # Move files to download directory
# mkdir -p "$DOWNLOAD_DIR"
# if ! mv * "$DOWNLOAD_DIR" 2>/dev/null; then
#     echo "No files to move or failed to move files."
# else
#     echo "Files moved to: $DOWNLOAD_DIR"
# fi

# # Clean up
# cd ..
# rm -rf repo
# echo "Sparse checkout completed."







# #!/bin/bash


# # Repository details
# REPO_OWNER="CodesByPankaj"
# REPO_NAME="cs-stock"
# PAT="YOUR-PAT-TOKEN"

# # Set variables
# GITHUB_REPO_URL="https://$PAT@github.com/$REPO_OWNER/$REPO_NAME.git"
# BRANCH="master"
# SPARSE_MODE="$1"  # Accept depth as the first argument
# DOWNLOAD_DIR="./downloaded-files"

# # Clone repo without checkout
# git clone --no-checkout --filter=blob:none --branch $BRANCH $GITHUB_REPO_URL repo
# cd repo || exit

# # Initialize sparse-checkout
# git sparse-checkout init --cone

# # Set sparse-checkout depth based on user input
# case "$SPARSE_MODE" in
#     empty)
#         git sparse-checkout set '' ;;
#     files)
#         git sparse-checkout set '/*' ;;
#     immediates)
#         git sparse-checkout set '/*' '/*/*' ;;
#     infinity)
#         git sparse-checkout disable ;;
#     *)
#         echo "Invalid mode. Use one of: empty, files, immediates, infinity."
#         exit 1 ;;
# esac

# # Pull files based on sparse-checkout rules
# git pull origin $BRANCH

# # Move files to download directory
# mkdir -p "$DOWNLOAD_DIR"
# mv * "$DOWNLOAD_DIR" 2>/dev/null || echo "No files to move."

# # Clean up
# cd ..
# rm -rf repo
# echo "Sparse checkout completed. Files downloaded to: $DOWNLOAD_DIR"
