#!/bin/bash

# Check if git is installed
/usr/bin/git --version || { echo "Git not found in PATH"; exit 1; }
echo "Current PATH: $PATH"

# Function to download files using sparse checkout
download_files_with_sparse_checkout() {
    REPO_URL="https://github.com/CodesByPankaj/cs-stock.git"
    BRANCH="master"
    CLONE_DIR="${HOME}/gitconfigs"

    # Create the directory if it doesn't exist
    if [ ! -d "$CLONE_DIR" ]; then
        mkdir -p "$CLONE_DIR"
    fi

    # Navigate to the clone directory
    cd "$CLONE_DIR" || exit

    # Initialize a new git repository if it doesn't exist
    if [ ! -d ".git" ]; then
        /usr/bin/git init
    fi

    # Check if the remote already exists
    if ! /usr/bin/git remote get-url origin > /dev/null 2>&1; then
        /usr/bin/git remote add origin "$REPO_URL"
    else
        echo "Remote 'origin' already exists."
    fi

    # Enable sparse checkout
    /usr/bin/git config core.sparseCheckout true

    # If specific files are provided, set CONFIG_PATHS to those files
    if [ $# -gt 0 ]; then
        CONFIG_PATHS=("$@")  # Use all arguments as the paths
    else
        # Specify the files you want to download
        CONFIG_PATHS=(
            "src/main/java/stock_management/cs_stock/constant/ConstantValue.java"
            "src/main/java/stock_management/cs_stock/interpreter/Dashboard.java"
            "src/main/java/stock_management/cs_stock/patterns/CSVReader.java"
            "src/main/resources/application.properties"
            "src/main/resources/stocks.csv"
            "README.md"
            "StockRecommendationReport.txt"
        )
    fi

    # Write the paths to the sparse checkout file
    for PATH in "${CONFIG_PATHS[@]}"; do
        echo "$PATH" >> .git/info/sparse-checkout
    done

    # Pull the specified branch to download the files
    /usr/bin/git pull origin "$BRANCH"

    echo "Downloaded specified files to $CLONE_DIR."
}

# Main script execution
download_files_with_sparse_checkout "$@"












# #!/bin/bash

# # Check if git is installed
# /usr/bin/git --version || { echo "Git not found in PATH"; exit 1; }
# echo "Current PATH: $PATH"

# # Function to download files using sparse checkout
# download_files_with_sparse_checkout() {
#     REPO_URL="https://github.com/CodesByPankaj/cs-stock.git"
#     BRANCH="master"
#     CLONE_DIR="${HOME}/gitconfigs"

#     # Create the directory if it doesn't exist
#     if [ ! -d "$CLONE_DIR" ]; then
#         mkdir -p "$CLONE_DIR"
#     fi

#     # Navigate to the clone directory
#     cd "$CLONE_DIR" || exit

#     # Initialize a new git repository if it doesn't exist
#     if [ ! -d ".git" ]; then
#         /usr/bin/git init
#     fi

#     # Check if the remote already exists
#     if ! /usr/bin/git remote get-url origin > /dev/null 2>&1; then
#         /usr/bin/git remote add origin "$REPO_URL"
#     else
#         echo "Remote 'origin' already exists."
#     fi

#     # Enable sparse checkout
#     /usr/bin/git config core.sparseCheckout true

#     # Specify the files you want to download
#     CONFIG_PATHS=(
#         "src/main/java/stock_management/cs_stock/constant/ConstantValue.java"
#         "src/main/java/stock_management/cs_stock/interpreter/Dashboard.java"
#         "src/main/java/stock_management/cs_stock/patterns/CSVReader.java"
#         "src/main/resources/application.properties"
#         "src/main/resources/stocks.csv"
#         "README.md"
#         "StockRecommendationReport.txt"
#     )

#     # Write the paths to the sparse checkout file
#     for PATH in "${CONFIG_PATHS[@]}"; do
#         echo "$PATH" >> .git/info/sparse-checkout
#     done

#     # Pull the specified branch to download the files
#     /usr/bin/git pull origin "$BRANCH"

#     echo "Downloaded specified files to $CLONE_DIR."
# }

# # Main script execution
# download_files_with_sparse_checkout