#!/bin/bash

# Repository details
REPO_OWNER="CodesByPankaj"
REPO_NAME="cs-stock"
BRANCH="master"
PAT="YOUR-PAT-TOKEN"

# List of files to fetch
FILE_LIST="config-file-list.txt"

# Directory to clone the repository
CLONE_DIR="./temp_repo"

# Check if the file list exists
if [[ ! -f "$FILE_LIST" ]]; then
    echo "File $FILE_LIST does not exist."
    exit 1
fi

# Create a directory for sparse checkout
if [[ -d "$CLONE_DIR" ]]; then
    rm -rf "$CLONE_DIR"
fi
mkdir -p "$CLONE_DIR"

# Initialize the repository
cd "$CLONE_DIR" || exit
git init

# Add the remote repository
git remote add origin "https://$PAT@github.com/$REPO_OWNER/$REPO_NAME.git"

# Configure sparse checkout
git config core.sparseCheckout true

# Add the file paths to the sparse-checkout list
while IFS= read -r file_path || [[ -n "$file_path" ]]; do
    echo "$file_path" >> .git/info/sparse-checkout
done < "../$FILE_LIST"

# Fetch only the specified files
git pull origin "$BRANCH"

# Remove the .git folder to keep only the files
rm -rf .git

# Move back to the parent directory
cd - > /dev/null || exit

# Optional: Display the fetched files
echo "Fetched files are available in: $CLONE_DIR"
ls -l "$CLONE_DIR"













# #!/bin/bash

# # Define your PAT token (consider the security implications)
# PAT="YOUR-PAT-TOKEN"

# # Repository URL with PAT token
# GITHUB_REPO_URL="https://$PAT@github.com/CodesByPankaj/cs-stock.git"

# # Branch to clone
# BRANCH="master"

# # Absolute path to the config file
# CONFIG_FILE_LIST="$(pwd)/config-file-list.txt"

# # Directory to store downloaded files
# DOWNLOAD_DIR="$(pwd)/downloaded-files"

# # Check if the config file exists and is not empty
# if [[ ! -f "$CONFIG_FILE_LIST" || ! -s "$CONFIG_FILE_LIST" ]]; then
#   echo "Error: Config file $CONFIG_FILE_LIST not found or is empty!"
#   exit 1
# fi

# # Clone the repository with sparse-checkout enabled
# git clone --no-checkout --filter=blob:none --branch "$BRANCH" "$GITHUB_REPO_URL" repo || { echo "Failed to clone repository"; exit 1; }

# # Navigate into the cloned repository
# cd repo || { echo "Failed to navigate into the repository directory"; exit 1; }

# # Initialize sparse-checkout
# git sparse-checkout init --cone || { echo "Failed to initialize sparse-checkout"; exit 1; }

# # Clear existing patterns and apply new ones
# echo "Setting up sparse-checkout for the following files:"
# while IFS= read -r line; do
#   line=$(echo "$line" | tr -d '\r') # Remove any '\r' characters
#   echo " - $line"
#   git sparse-checkout set "$line" || { echo "Failed to set sparse-checkout for $line"; exit 1; }
# done < "$CONFIG_FILE_LIST"

# # Pull the specific branch with the selected files
# git pull origin "$BRANCH" || { echo "Failed to pull from repository"; exit 1; }

# # Create the directory to store downloaded files
# mkdir -p "$DOWNLOAD_DIR"

# # Copy downloaded files to the custom directory
# echo "Copying downloaded files to $DOWNLOAD_DIR..."
# while IFS= read -r line; do
#   line=$(echo "$line" | tr -d '\r') # Remove any '\r' characters
#   if [[ -f "$line" ]]; then
#     # Ensure the directory structure is preserved
#     mkdir -p "$DOWNLOAD_DIR/$(dirname "$line")"
#     cp --parents "$line" "$DOWNLOAD_DIR" || { echo "Failed to copy $line"; exit 1; }
#     echo "Copied: $line"
#   else
#     echo "Warning: File $line not found in the repository!"
#   fi
# done < "$CONFIG_FILE_LIST"

# # Clean up: Navigate out of the repo directory and delete the cloned repository folder
# cd .. || exit
# rm -rf repo

# echo "Sparse checkout completed. Files downloaded to: $DOWNLOAD_DIR"














# #!/bin/bash

# # Define your PAT token
# PAT="YOUR-PAT-TOKEN"

# # Repository URL with PAT token
# GITHUB_REPO_URL="https://$PAT@github.com/CodesByPankaj/cs-stock.git"

# # Branch to clone
# BRANCH="master"

# # Absolute path to the config file
# CONFIG_FILE_LIST="$(pwd)/config-file-list.txt"

# # Directory to store downloaded files
# DOWNLOAD_DIR="$(pwd)/downloaded-files"

# # Check if the config file exists
# if [[ ! -f "$CONFIG_FILE_LIST" ]]; then
#   echo "Error: Config file $CONFIG_FILE_LIST not found!"
#   exit 1
# fi

# # Clone the repository with sparse-checkout enabled
# git clone --no-checkout --filter=blob:none --branch "$BRANCH" "$GITHUB_REPO_URL" repo

# # Navigate into the cloned repository
# cd repo || exit

# # Initialize sparse-checkout
# git sparse-checkout init --cone

# # Clear existing patterns and apply new ones
# echo "Setting up sparse-checkout for the following files:"
# while IFS= read -r line; do
#   line=$(echo "$line" | tr -d '\r') # Remove any '\r' characters
#   echo " - $line"
#   git sparse-checkout set "$line"
# done < "$CONFIG_FILE_LIST"

# # Pull the specific branch with the selected files
# git pull origin "$BRANCH"

# # Create the directory to store downloaded files
# mkdir -p "$DOWNLOAD_DIR"

# # Copy downloaded files to the custom directory
# echo "Copying downloaded files to $DOWNLOAD_DIR..."
# while IFS= read -r line; do
#   line=$(echo "$line" | tr -d '\r') # Remove any '\r' characters
#   if [[ -f "$line" ]]; then
#     # Ensure the directory structure is preserved
#     mkdir -p "$DOWNLOAD_DIR/$(dirname "$line")"
#     cp --parents "$line" "$DOWNLOAD_DIR"
#     echo "Copied: $line"
#   else
#     echo "Warning: File $line not found in the repository!"
#   fi
# done < "$CONFIG_FILE_LIST"

# # Navigate out of the repo directory
# cd ..

# # Delete the cloned repository folder
# rm -rf repo

# echo "Sparse checkout completed. Files downloaded to: $DOWNLOAD_DIR"















# #!/bin/bash

# # Define your PAT token
# PAT="YOUR-PAT-TOKEN"

# # Repository URL with PAT token
# GITHUB_REPO_URL="https://$PAT@github.com/CodesByPankaj/cs-stock.git"

# # Branch to clone
# BRANCH="master"

# # Absolute path to the config file (adjust as necessary)
# CONFIG_FILE_LIST="$(pwd)/config-file-list.txt"

# # Directory to store downloaded files
# DOWNLOAD_DIR="$(pwd)/downloaded-files"

# # Check if the config file exists
# if [[ ! -f "$CONFIG_FILE_LIST" ]]; then
#   echo "Error: Config file $CONFIG_FILE_LIST not found!"
#   exit 1
# fi

# # Clone the repository with sparse-checkout enabled
# git clone --no-checkout --filter=blob:none --branch "$BRANCH" "$GITHUB_REPO_URL" repo

# # Navigate into the cloned repository
# cd repo || exit

# # Initialize sparse-checkout
# git sparse-checkout init

# # Read the file line by line and add each file to the sparse checkout
# echo "Setting up sparse-checkout for the following files:"
# while IFS= read -r line; do
#   line=$(echo "$line" | tr -d '\r') # Remove any '\r' characters
#   echo " - $line"
#   git sparse-checkout set "$line"
# done < "$CONFIG_FILE_LIST"

# # Pull the specific branch with the selected files
# git pull origin "$BRANCH"

# # Create the directory to store downloaded files
# mkdir -p "$DOWNLOAD_DIR"

# # Verify and copy downloaded files to the custom directory
# echo "Copying downloaded files to $DOWNLOAD_DIR..."
# while IFS= read -r line; do
#   line=$(echo "$line" | tr -d '\r') # Remove any '\r' characters
#   if [[ -f "$line" ]]; then
#     echo "Copying: $line"
#     mkdir -p "$DOWNLOAD_DIR/$(dirname "$line")"
#     cp --parents "$line" "$DOWNLOAD_DIR"
#   else
#     echo "Warning: File $line not found in the repository!"
#   fi
# done < "$CONFIG_FILE_LIST"

# # Navigate out of the repo directory
# cd ..

# # Delete the cloned repository folder
# rm -rf repo

# echo "Sparse checkout completed. Files downloaded to: $DOWNLOAD_DIR"
# echo "Temporary repository folder 'repo' has been deleted."












# #!/bin/bash

# # Define your PAT token
# PAT="YOUR-PAT-TOKEN"

# # Repository URL with PAT token
# GITHUB_REPO_URL="https://$PAT@github.com/CodesByPankaj/cs-stock.git"

# # Branch to clone
# BRANCH="master"

# # Absolute path to the config file (adjust as necessary)
# CONFIG_FILE_LIST="$(pwd)/config-file-list.txt"

# # Directory to store downloaded files
# DOWNLOAD_DIR="$(pwd)/downloaded-files"

# # Check if the config file exists
# if [[ ! -f "$CONFIG_FILE_LIST" ]]; then
#   echo "Error: Config file $CONFIG_FILE_LIST not found!"
#   exit 1
# fi

# # Clone the repository with sparse-checkout enabled
# git clone --no-checkout --filter=blob:none --branch "$BRANCH" "$GITHUB_REPO_URL" repo

# # Navigate into the cloned repository
# cd repo || exit

# # Initialize sparse-checkout
# git sparse-checkout init --cone

# # Clear existing patterns
# git sparse-checkout init

# # Read the file line by line and add each file to the sparse checkout
# while IFS= read -r line; do
#   line=$(echo "$line" | tr -d '\r') # Remove any '\r' characters
#   git sparse-checkout set "$line"
# done < "$CONFIG_FILE_LIST"

# # Pull the specific branch with the selected files
# git pull origin "$BRANCH"

# # Create the directory to store downloaded files
# mkdir -p "$DOWNLOAD_DIR"

# # Copy downloaded files to the custom directory
# while IFS= read -r line; do
#   line=$(echo "$line" | tr -d '\r') # Remove any '\r' characters
#   # Ensure the directory structure is preserved
#   mkdir -p "$DOWNLOAD_DIR/$(dirname "$line")"
#   cp --parents "$line" "$DOWNLOAD_DIR"
# done < "$CONFIG_FILE_LIST"

# # Navigate out of the repo directory
# cd ..

# # Delete the cloned repository folder
# rm -rf repo

# echo "Sparse checkout completed. Files downloaded to: $DOWNLOAD_DIR"
# echo "Temporary repository folder 'repo' has been deleted."



















# #!/bin/bash

# # Define your PAT token
# PAT="YOUR-PAT-TOKEN"

# # Repository URL with PAT token
# GITHUB_REPO_URL="https://$PAT@github.com/CodesByPankaj/cs-stock.git"

# # Branch to clone
# BRANCH="master"

# # Absolute path to the config file (adjust as necessary)
# CONFIG_FILE_LIST="$(pwd)/config-file-list.txt"

# # Directory to store downloaded files
# DOWNLOAD_DIR="$(pwd)/downloaded-files"

# # Check if the config file exists
# if [[ ! -f "$CONFIG_FILE_LIST" ]]; then
#   echo "Error: Config file $CONFIG_FILE_LIST not found!"
#   exit 1
# fi

# # Clone the repository with sparse-checkout enabled
# git clone --no-checkout --filter=blob:none --branch "$BRANCH" "$GITHUB_REPO_URL" repo

# # Navigate into the cloned repository
# cd repo || exit

# # Initialize sparse-checkout
# git sparse-checkout init --cone

# # Clear existing patterns
# git sparse-checkout init

# # Read the file line by line and add each file to the sparse checkout
# while IFS= read -r line; do
#   git sparse-checkout set "$line"
# done < "$CONFIG_FILE_LIST"

# # Pull the specific branch with the selected files
# git pull origin "$BRANCH"

# # Create the directory to store downloaded files
# mkdir -p "$DOWNLOAD_DIR"

# # Copy downloaded files to the custom directory
# while IFS= read -r line; do
#   # Ensure the directory structure is preserved
#   mkdir -p "$DOWNLOAD_DIR/$(dirname "$line")"
#   cp --parents "$line" "$DOWNLOAD_DIR"
# done < "$CONFIG_FILE_LIST"

# # Navigate out of the repo directory
# cd ..

# # Delete the cloned repository folder
# rm -rf repo

# echo "Sparse checkout completed. Files downloaded to: $DOWNLOAD_DIR"
# echo "Temporary repository folder 'repo' has been deleted."








# #!/bin/bash

# # Define your PAT token
# PAT="YOUR-PAT-TOKEN"

# # Repository URL with PAT token
# GITHUB_REPO_URL="https://$PAT@github.com/CodesByPankaj/cs-stock.git"

# # Branch to clone
# BRANCH="master"

# # Absolute path to the config file (adjust as necessary)
# CONFIG_FILE_LIST="$(pwd)/config-file-list.txt"

# # Directory to store downloaded files
# DOWNLOAD_DIR="$(pwd)/downloaded-files"

# # Check if the config file exists
# if [[ ! -f "$CONFIG_FILE_LIST" ]]; then
#   echo "Error: Config file $CONFIG_FILE_LIST not found!"
#   exit 1
# fi

# # Clone the repository with sparse-checkout enabled
# git clone --no-checkout --filter=blob:none --branch "$BRANCH" "$GITHUB_REPO_URL" repo

# # Navigate into the cloned repository
# cd repo || exit

# # Initialize sparse-checkout
# git sparse-checkout init --cone

# # Clear existing patterns
# git sparse-checkout init

# # Read the file line by line and add each file to the sparse checkout
# while IFS= read -r line; do
#   git sparse-checkout set "$line"
# done < "$CONFIG_FILE_LIST"

# # Pull the specific branch with the selected files
# git pull origin "$BRANCH"

# # Create the directory to store downloaded files
# mkdir -p "$DOWNLOAD_DIR"

# # Copy downloaded files to the custom directory
# while IFS= read -r line; do
#   # Ensure the directory structure is preserved
#   mkdir -p "$DOWNLOAD_DIR/$(dirname "$line")"
#   cp --parents "$line" "$DOWNLOAD_DIR"
# done < "$CONFIG_FILE_LIST"

# echo "Sparse checkout completed. Files downloaded to: $DOWNLOAD_DIR"










# #!/bin/bash

# # Define your PAT token
# PAT="YOUR-PAT-TOKEN"

# # Repository URL with PAT token
# GITHUB_REPO_URL="https://$PAT@github.com/CodesByPankaj/cs-stock.git"

# # Branch to clone
# BRANCH="master"

# # Absolute path to the config file (adjust as necessary)
# CONFIG_FILE_LIST="$(pwd)/config-file-list.txt"

# # Check if the config file exists
# if [[ ! -f "$CONFIG_FILE_LIST" ]]; then
#   echo "Error: Config file $CONFIG_FILE_LIST not found!"
#   exit 1
# fi

# # Clone the repository with sparse-checkout enabled
# git clone --no-checkout --filter=blob:none --branch "$BRANCH" "$GITHUB_REPO_URL" repo

# # Navigate into the cloned repository
# cd repo || exit

# # Initialize sparse-checkout
# git sparse-checkout init --cone

# # Clear existing patterns
# git sparse-checkout init

# # Read the file line by line and add each file to the sparse checkout
# while IFS= read -r line; do
#   git sparse-checkout set "$line"
# done < "$CONFIG_FILE_LIST"

# # Pull the specific branch with the selected files
# git pull origin "$BRANCH"

# echo "Sparse checkout completed. Files downloaded:"
# cat "$CONFIG_FILE_LIST"
