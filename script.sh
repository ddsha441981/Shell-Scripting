#!/bin/bash

which git || { echo "Git not found in PATH"; exit 1; }

remove_windows_line_endings() {
  if [[ "$(uname -s)" == *CYGWIN* || "$(uname -s)" == *MINGW* || "$(uname -s)" == *MSYS* ]]; then
    echo "Windows detected, removing Windows-style line endings."
    sed -i 's/\r$//' "$1"
  fi
}

# Method to download all config files
download_all_configs() {
    REPO_URL="https://github.com/CodesByPankaj/cs-stock.git"
    BRANCH="master"
    CLONE_DIR="${HOME}/gitconfigs"

    if [ ! -d "$CLONE_DIR" ]; then
        mkdir -p "$CLONE_DIR"
    fi

    cd "$CLONE_DIR" || exit
    git init

    # Avoid adding origin repeatedly
    if ! git remote | grep -q origin; then
        git remote add origin "$REPO_URL"
    fi

    git config core.sparseCheckout true

    CONFIG_PATHS=(
        "src/main/java/stock_management/cs_stock/constant/ConstantValue.java"
        "src/main/java/stock_management/cs_stock/interpreter/Dashboard.java"
        "src/main/java/stock_management/cs_stock/patterns/CSVReader.java"
        "src/main/resources/application.properties"
        "src/main/resources/stocks.csv"
        "README.md"
        "StockRecommendationReport.txt"
    )

    for PATH in "${CONFIG_PATHS[@]}"; do
        echo "$PATH" >> .git/info/sparse-checkout
    done

    git pull origin "$BRANCH"
    echo "All config files have been downloaded to $CLONE_DIR."
}

# Method to download a specific file
download_single_file() {
    FILE_PATH=$1
    OUTPUT_DIR="${HOME}/gitconfigs"
    REPO_OWNER="CodesByPankaj"
    REPO_NAME="cs-stock"
    BRANCH="main"
    TOKEN="YOUR-PAT-TOKEN"

    API_URL="https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/contents/$FILE_PATH?ref=$BRANCH"
    mkdir -p "$OUTPUT_DIR"

    curl -H "Authorization: token $TOKEN" \
         -H "Accept: application/vnd.github.v3.raw" \
         -o "$OUTPUT_DIR/$(basename "$FILE_PATH")" \
         "$API_URL"

    if [ $? -eq 0 ]; then
        echo "Downloaded: $FILE_PATH"
    else
        echo "Failed to download: $FILE_PATH"
    fi
}

# Main script logic
if [[ $1 == "all" ]]; then
    remove_windows_line_endings "$0"
    download_all_configs
elif [[ $1 == "single" && -n $2 ]]; then
    remove_windows_line_endings "$0"
    download_single_file "$2"
else
    echo "Usage: $0 all | single <file_path>"
    exit 1
fi




































# #!/usr/bin/env bash

# # Function to remove Windows-style line endings
# remove_windows_line_endings() {
#     # Check for Windows-like environments
#     if [[ "$(uname -s)" == *CYGWIN* || "$(uname -s)" == *MINGW* || "$(uname -s)" == *MSYS* ]]; then
#     echo "Windows detected, removing Windows-style line endings."
#     sed -i 's/\r$//' "$1"  # Remove carriage returns (Windows-style line endings)
#   fi
# }

# # Function to download all configuration files
# download_all_configs() {
#     # Debug Git command
#     REPO_URL="https://github.com/CodesByPankaj/cs-stock.git"
#     BRANCH="master"
#     CLONE_DIR="${HOME}/gitconfigs"

#     # Ensure the clone directory exists
#     if [[ ! -d "$CLONE_DIR" ]]; then
#         mkdir -p "$CLONE_DIR"
#     fi

#     # Navigate to the clone directory
#     cd "$CLONE_DIR" || exit

#     # Initialize a Git repository and set sparse checkout
#     git init
#     git remote add origin "$REPO_URL"
#     git config core.sparseCheckout true

#     # List of configuration paths to download
#     CONFIG_PATHS=(
#         "src/main/java/stock_management/cs_stock/constant/ConstantValue.java"
#         "src/main/java/stock_management/cs_stock/interpreter/Dashboard.java"
#         "src/main/java/stock_management/cs_stock/patterns/CSVReader.java"
#         "src/main/resources/application.properties"
#         "src/main/resources/stocks.csv"
#         # "README.md"
#         # "StockRecommendationReport.txt"
#     )

#     # Populate sparse-checkout file with the paths
#     for PATH in "${CONFIG_PATHS[@]}"; do
#         echo "$PATH" >> .git/info/sparse-checkout
#     done

#     # Pull the specified branch
#     git pull origin "$BRANCH"

#     echo "All config files have been downloaded to $CLONE_DIR."
# }

# # Function to download a single file
# download_single_file() {
#     FILE_PATH=$1
#     OUTPUT_DIR="${HOME}/gitconfigs"
#     REPO_OWNER="CodesByPankaj"
#     REPO_NAME="cs-stock"
#     BRANCH="master"
#     TOKEN="YOUR-PAT-TOKEN"

#     API_URL="https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/contents/$FILE_PATH?ref=$BRANCH"
#     mkdir -p "$OUTPUT_DIR"

#     # Use curl to download the specific file
#     curl -H "Authorization: token $TOKEN" \
#          -H "Accept: application/vnd.github.v3.raw" \
#          -o "$OUTPUT_DIR/$(basename "$FILE_PATH")" \
#          "$API_URL"

#     # Check the result of the download
#     if [[ $? -eq 0 ]]; then
#         echo "Downloaded: $FILE_PATH"
#     else
#         echo "Failed to download: $FILE_PATH"
#     fi
# }

# # Main script logic
# case $1 in
#     all)
#         remove_windows_line_endings "$0"
#         download_all_configs
#         ;;
#     single)
#         if [[ -z $2 ]]; then
#             echo "Error: Missing file path. Usage: $0 single <file_path>"
#             exit 1
#         fi
#         remove_windows_line_endings "$0"
#         download_single_file "$2"
#         ;;
#     *)
#         echo "Usage: $0 all | single <file_path>"
#         exit 1
#         ;;
# esac
