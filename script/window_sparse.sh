#!/bin/bash

# Selective Git File Downloader

# Configuration
STATIC_REPO_URL="https://github.com/CodesByPankaj/cs-stock.git"
DEFAULT_BRANCH="master"

# Logging function
log() {
    echo "[${1^^}] $2"
}

# Download specific files
download_specific_files() {
    local BRANCH="${1:-$DEFAULT_BRANCH}"
    local DOWNLOAD_MODE="${2:-specific}"
    local CUSTOM_FILE="${3:-}"

    # Directories
    local DOWNLOAD_DIR="$HOME/downloaded_files"
    local TEMP_CLONE_DIR="$HOME/temp_git_clone"

    # Predefined files to download
    local FILES_TO_DOWNLOAD=(
        "README.md"
        "src/main/resources/application.properties"
        "src/main/resources/stocks.csv"
        "src/test/java/stock_management/cs_stock/CsStockApplicationTests.java"
        "StockRecommendationReport.txt"
        "src/main/java/stock_management/cs_stock/constant/ConstantValue.java"
        "src/main/java/stock_management/cs_stock/interpreter/Dashboard.java"
        "src/main/java/stock_management/cs_stock/patterns/CSVReader.java"
    )

    # Cleanup and prepare directories
    rm -rf "$DOWNLOAD_DIR" "$TEMP_CLONE_DIR"
    mkdir -p "$DOWNLOAD_DIR"
    mkdir -p "$TEMP_CLONE_DIR"
    cd "$TEMP_CLONE_DIR" || exit 1

    # Git clone with sparse checkout
    git init
    git remote add origin "$STATIC_REPO_URL"
    git config core.sparseCheckout true

    # Prepare sparse checkout file
    local SPARSE_CHECKOUT_FILE=".git/info/sparse-checkout"
    : > "$SPARSE_CHECKOUT_FILE"

    # Determine download strategy
    if [[ "$DOWNLOAD_MODE" == "all" ]]; then
        for file in "${FILES_TO_DOWNLOAD[@]}"; do
            echo "$file" >> "$SPARSE_CHECKOUT_FILE"
        done
        log "info" "Downloading predefined files (flattened structure)"
    elif [[ -n "$CUSTOM_FILE" ]]; then
        echo "$CUSTOM_FILE" > "$SPARSE_CHECKOUT_FILE"
        log "info" "Downloading specific file: $CUSTOM_FILE"
    fi

    # Fetch and checkout
    git fetch origin "$BRANCH" --depth 1
    git checkout "$BRANCH"

    # Download files
    if [[ -n "$CUSTOM_FILE" ]]; then
        # For single file, copy directly to download directory
        if [[ -f "$CUSTOM_FILE" ]]; then
            cp "$CUSTOM_FILE" "$DOWNLOAD_DIR/$(basename "$CUSTOM_FILE")" && {
                log "info" "Downloaded: $CUSTOM_FILE"
            } || {
                log "error" "Failed to download: $CUSTOM_FILE"
            }
        else
            log "error" "File not found: $CUSTOM_FILE"
        fi
    else
        # For predefined files, copy them to the download directory with a flattened structure
        for file in "${FILES_TO_DOWNLOAD[@]}"; do
            if [[ -f "$file" ]]; then
                cp "$file" "$DOWNLOAD_DIR/$(basename "$file")" && {
                    log "info" "Downloaded: $file"
                } || {
                    log "error" "Failed to download: $file"
                }
            else
                log "warning" "File not found: $file"
            fi
        done
    fi

    # Cleanup temporary directory
    rm -rf "$TEMP_CLONE_DIR"

    # Summary
    log "info" "Download completed. Files saved in $DOWNLOAD_DIR"
}

# Main execution
main() {
    local BRANCH="$DEFAULT_BRANCH"
    local DOWNLOAD_MODE="specific"
    local CUSTOM_FILE=""

    # Parse arguments
    case $# in
        0)
            # No arguments, download predefined files
            DOWNLOAD_MODE="all"
            ;;
        1)
            if [[ "$1" == "all" ]]; then
                DOWNLOAD_MODE="all"
            else
                CUSTOM_FILE="$1"
            fi
            ;;
        2)
            CUSTOM_FILE="$1"
            BRANCH="$2"
            ;;
    esac

    # Call download function
    download_specific_files "$BRANCH" "$DOWNLOAD_MODE" "$CUSTOM_FILE"
}

# Run script
main "$@"















# #!/bin/bash

# # Selective Git File Downloader

# # Configuration
# STATIC_REPO_URL="https://github.com/CodesByPankaj/cs-stock.git"
# DEFAULT_BRANCH="master"

# # Logging function
# log() {
#     echo "[${1^^}] $2"
# }

# # Download specific files
# download_specific_files() {
#     local BRANCH="${1:-$DEFAULT_BRANCH}"
#     local DOWNLOAD_MODE="${2:-specific}"
#     local CUSTOM_FILE="${3:-}"

#     # Directories
#     local DOWNLOAD_DIR="$HOME/downloaded_files"
#     local TEMP_CLONE_DIR="$HOME/temp_git_clone"

#     # Predefined files to download
#     local FILES_TO_DOWNLOAD=(
#         "README.md"
#         "src/main/resources/application.properties"
#         "src/main/resources/stocks.csv"
#         "src/test/java/stock_management/cs_stock/CsStockApplicationTests.java"
#         "StockRecommendationReport.txt"
#         "src/main/java/stock_management/cs_stock/constant/ConstantValue.java"
#         "src/main/java/stock_management/cs_stock/interpreter/Dashboard.java"
#         "src/main/java/stock_management/cs_stock/patterns/CSVReader.java"
#     )

#     # Cleanup and prepare directories
#     rm -rf "$DOWNLOAD_DIR" "$TEMP_CLONE_DIR"
#     mkdir -p "$DOWNLOAD_DIR"
#     mkdir -p "$TEMP_CLONE_DIR"
#     cd "$TEMP_CLONE_DIR" || exit 1

#     # Git clone with sparse checkout
#     git init
#     git remote add origin "$STATIC_REPO_URL"
#     git config core.sparseCheckout true

#     # Prepare sparse checkout file
#     local SPARSE_CHECKOUT_FILE=".git/info/sparse-checkout"
#     : > "$SPARSE_CHECKOUT_FILE"

#     # Determine download strategy
#     if [[ "$DOWNLOAD_MODE" == "all" ]]; then
#         for file in "${FILES_TO_DOWNLOAD[@]}"; do
#             echo "$file" >> "$SPARSE_CHECKOUT_FILE"
#         done
#         log "info" "Downloading predefined files"
#     elif [[ -n "$CUSTOM_FILE" ]]; then
#         echo "$CUSTOM_FILE" > "$SPARSE_CHECKOUT_FILE"
#         log "info" "Downloading specific file: $CUSTOM_FILE"
#     fi

#     # Fetch and checkout
#     git fetch origin "$BRANCH" --depth 1
#     git checkout "$BRANCH"

#     # Download files
#     if [[ -n "$CUSTOM_FILE" ]]; then
#         # For single file, copy directly to download directory
#         if [[ -f "$CUSTOM_FILE" ]]; then
#             cp "$CUSTOM_FILE" "$DOWNLOAD_DIR/$(basename "$CUSTOM_FILE")" && {
#                 log "info" "Downloaded: $CUSTOM_FILE"
#             } || {
#                 log "error" "Failed to download: $CUSTOM_FILE"
#             }
#         else
#             log "error" "File not found: $CUSTOM_FILE"
#         fi
#     else
#         # For predefined files, copy them while preserving their structure
#         for file in "${FILES_TO_DOWNLOAD[@]}"; do
#             if [[ -f "$file" ]]; then
#                 dest="$DOWNLOAD_DIR/$file"
#                 mkdir -p "$(dirname "$dest")"
#                 cp "$file" "$dest" && {
#                     log "info" "Downloaded: $file"
#                 } || {
#                     log "error" "Failed to download: $file"
#                 }
#             else
#                 log "warning" "File not found: $file"
#             fi
#         done
#     fi

#     # Cleanup temporary directory
#     rm -rf "$TEMP_CLONE_DIR"

#     # Summary
#     log "info" "Download completed. Files saved in $DOWNLOAD_DIR"
# }

# # Main execution
# main() {
#     local BRANCH="$DEFAULT_BRANCH"
#     local DOWNLOAD_MODE="specific"
#     local CUSTOM_FILE=""

#     # Parse arguments
#     case $# in
#         0)
#             # No arguments, download predefined files
#             DOWNLOAD_MODE="all"
#             ;;
#         1)
#             if [[ "$1" == "all" ]]; then
#                 DOWNLOAD_MODE="all"
#             else
#                 CUSTOM_FILE="$1"
#             fi
#             ;;
#         2)
#             CUSTOM_FILE="$1"
#             BRANCH="$2"
#             ;;
#     esac

#     # Call download function
#     download_specific_files "$BRANCH" "$DOWNLOAD_MODE" "$CUSTOM_FILE"
# }

# # Run script
# main "$@"



















# #!/bin/bash

# # Selective Git File Downloader

# # Configuration
# STATIC_REPO_URL="https://github.com/CodesByPankaj/cs-stock.git"
# DEFAULT_BRANCH="master"

# # Simple logging function
# log() {
#     echo "[${1^^}] $2"
# }

# # Download specific files
# download_specific_files() {
#     local BRANCH="${1:-$DEFAULT_BRANCH}"
#     local DOWNLOAD_MODE="${2:-specific}"
#     local CUSTOM_FILE="${3:-}"

#     # Directories
#     local DOWNLOAD_DIR="$HOME/downloaded_files"
#     local TEMP_CLONE_DIR="$HOME/temp_git_clone"

#     # Predefined files to download
#     local FILES_TO_DOWNLOAD=(
#         "README.md:README.md"
#         "src/main/resources/application.properties:application.properties"
#         "src/main/resources/stocks.csv:stocks.csv"
#         "src/test/java/stock_management/cs_stock/CsStockApplicationTests.java"
#         "StockRecommendationReport.txt:StockRecommendationReport.txt"
#         "src/main/java/stock_management/cs_stock/constant/ConstantValue.java:ConstantValue.java"
#         "src/main/java/stock_management/cs_stock/interpreter/Dashboard.java:Dashboard.java"
#         "src/main/java/stock_management/cs_stock/patterns/CSVReader.java:CSVReader.java"
#     )

#     # Cleanup and prepare directories
#     rm -rf "$DOWNLOAD_DIR" "$TEMP_CLONE_DIR"
#     mkdir -p "$DOWNLOAD_DIR" "$TEMP_CLONE_DIR"
#     cd "$TEMP_CLONE_DIR" || exit 1

#     # Git clone with sparse checkout
#     git init
#     git remote add origin "$STATIC_REPO_URL"
#     git config core.sparseCheckout true

#     # Prepare sparse checkout file
#     local SPARSE_CHECKOUT_FILE=".git/info/sparse-checkout"
#     : > "$SPARSE_CHECKOUT_FILE"

#     # Determine download strategy
#     if [[ "$DOWNLOAD_MODE" == "all" ]]; then
#         # Download predefined files
#         for file_mapping in "${FILES_TO_DOWNLOAD[@]}"; do
#             IFS=':' read -r source_path _ <<< "$file_mapping"
#             echo "$source_path" >> "$SPARSE_CHECKOUT_FILE"
#         done
#         log "info" "Preparing to download predefined files."
#     elif [[ -n "$CUSTOM_FILE" ]]; then
#         # Download specific custom file
#         echo "$CUSTOM_FILE" > "$SPARSE_CHECKOUT_FILE"
#         log "info" "Preparing to download specific file: $CUSTOM_FILE"
#     else
#         log "error" "Invalid download mode."
#         exit 1
#     fi

#     # Fetch and checkout
#     git fetch origin "$BRANCH" --depth 1
#     git checkout "$BRANCH"

#     # Download files
#     local downloaded_count=0
#     local failed_count=0

#     if [[ "$DOWNLOAD_MODE" == "all" ]]; then
#         # Download predefined files
#         for file_mapping in "${FILES_TO_DOWNLOAD[@]}"; do
#             IFS=':' read -r source_path dest_path <<< "$file_mapping"
            
#             # Use source path as destination if no custom destination
#             dest_path="${dest_path:-$(basename "$source_path")}"

#             # Create destination directory
#             mkdir -p "$DOWNLOAD_DIR/$(dirname "$dest_path")"

#             # Copy file
#             if [[ -f "$source_path" ]]; then
#                 cp "$source_path" "$DOWNLOAD_DIR/$dest_path" && {
#                     log "info" "Downloaded: $source_path → $dest_path"
#                     ((downloaded_count++))
#                 } || {
#                     log "error" "Failed to download: $source_path"
#                     ((failed_count++))
#                 }
#             else
#                 log "warning" "File not found: $source_path"
#                 ((failed_count++))
#             fi
#         done
#     elif [[ -n "$CUSTOM_FILE" ]]; then
#         # Download specific custom file
#         if [[ -e "$CUSTOM_FILE" ]]; then
#             mkdir -p "$DOWNLOAD_DIR/$(dirname "$CUSTOM_FILE")"
#             cp "$CUSTOM_FILE" "$DOWNLOAD_DIR/$CUSTOM_FILE" && {
#                 log "info" "Downloaded: $CUSTOM_FILE"
#                 ((downloaded_count++))
#             } || {
#                 log "error" "Failed to download: $CUSTOM_FILE"
#                 ((failed_count++))
#             }
#         else
#             log "error" "File not found: $CUSTOM_FILE"
#             ((failed_count++))
#         fi
#     fi

#     # Summary
#     log "info" "Download Summary:"
#     log "info" "Branch: $BRANCH"
#     log "info" "Mode: $DOWNLOAD_MODE"
#     log "info" "Downloaded: $downloaded_count"
#     log "info" "Failed: $failed_count"

#     # Cleanup
#     cd ..
#     rm -rf "$TEMP_CLONE_DIR"
# }

# # Main execution
# main() {
#     local BRANCH="$DEFAULT_BRANCH"
#     local DOWNLOAD_MODE="specific"
#     local CUSTOM_FILE=""

#     # Parse arguments
#     case $# in
#         0)
#             # No arguments, default to predefined files
#             DOWNLOAD_MODE="all"
#             ;;
#         1)
#             # Single argument
#             if [[ "$1" == "all" ]]; then
#                 DOWNLOAD_MODE="all"
#             else
#                 # Treat as custom file
#                 CUSTOM_FILE="$1"
#             fi
#             ;;
#         2)
#             # Two arguments
#             CUSTOM_FILE="$1"
#             BRANCH="$2"
#             ;;
#         *)
#             log "error" "Invalid number of arguments."
#             exit 1
#             ;;
#     esac

#     # Call download function
#     download_specific_files "$BRANCH" "$DOWNLOAD_MODE" "$CUSTOM_FILE"
# }

# # Run script
# main "$@"






















# #!/bin/bash

# # Selective Git File Downloader

# # Configuration
# STATIC_REPO_URL="https://github.com/CodesByPankaj/cs-stock.git"
# DEFAULT_BRANCH="master"

# # Simple logging function
# log() {
#     echo "[${1^^}] $2"
# }

# # Download specific files
# download_specific_files() {
#     local BRANCH="${1:-$DEFAULT_BRANCH}"
#     local DOWNLOAD_MODE="${2:-specific}"
#     local CUSTOM_FILE="${3:-}"

#     # Directories
#     local DOWNLOAD_DIR="$HOME/downloaded_files"
#     local TEMP_CLONE_DIR="$HOME/temp_git_clone"

#     # Predefined files to download
#     local FILES_TO_DOWNLOAD=(
#         "README.md:README.md"
#         "src/main/resources/application.properties:application.properties"
#         "src/main/resources/stocks.csv:stocks.csv"
#         "src/test/java/stock_management/cs_stock/CsStockApplicationTests.java"
#         "StockRecommendationReport.txt:StockRecommendationReport.txt"
#         "src/main/java/stock_management/cs_stock/constant/ConstantValue.java:ConstantValue.java"
#         "src/main/java/stock_management/cs_stock/interpreter/Dashboard.java:Dashboard.java"
#         "src/main/java/stock_management/cs_stock/patterns/CSVReader.java:CSVReader.java"
#     )

#     # Cleanup and prepare directories
#     rm -rf "$DOWNLOAD_DIR" "$TEMP_CLONE_DIR"
#     mkdir -p "$DOWNLOAD_DIR" "$TEMP_CLONE_DIR"
#     cd "$TEMP_CLONE_DIR" || exit 1

#     # Git clone with sparse checkout
#     git init
#     git remote add origin "$STATIC_REPO_URL"
#     git config core.sparseCheckout true

#     # Prepare sparse checkout file
#     local SPARSE_CHECKOUT_FILE=".git/info/sparse-checkout"
#     : > "$SPARSE_CHECKOUT_FILE"

#     # Determine download strategy
#     if [[ "$DOWNLOAD_MODE" == "all" ]]; then
#         # Download entire repository
#         echo "/*" > "$SPARSE_CHECKOUT_FILE"
#         log "info" "Preparing to download entire repository"
#     elif [[ -n "$CUSTOM_FILE" ]]; then
#         # Download specific custom file
#         echo "$CUSTOM_FILE" > "$SPARSE_CHECKOUT_FILE"
#         log "info" "Preparing to download specific file: $CUSTOM_FILE"
#     else
#         # Prepare sparse checkout for predefined files
#         for file_mapping in "${FILES_TO_DOWNLOAD[@]}"; do
#             IFS=':' read -r source_path _ <<< "$file_mapping"
#             echo "$source_path" >> "$SPARSE_CHECKOUT_FILE"
#         done
#     fi

#     # Fetch and checkout
#     git fetch origin "$BRANCH" --depth 1
#     git checkout "$BRANCH"

#     # Download files
#     local downloaded_count=0
#     local failed_count=0

#     if [[ "$DOWNLOAD_MODE" == "all" ]]; then
#         # Copy entire repository contents
#         cp -R . "$DOWNLOAD_DIR"
#         downloaded_count=$(find "$DOWNLOAD_DIR" -type f | wc -l)
#     elif [[ -n "$CUSTOM_FILE" ]]; then
#         # Download specific custom file
#         if [[ -e "$CUSTOM_FILE" ]]; then
#             mkdir -p "$DOWNLOAD_DIR/$(dirname "$CUSTOM_FILE")"
#             cp "$CUSTOM_FILE" "$DOWNLOAD_DIR/$CUSTOM_FILE" && {
#                 log "info" "Downloaded: $CUSTOM_FILE"
#                 ((downloaded_count++))
#             } || {
#                 log "error" "Failed to download: $CUSTOM_FILE"
#                 ((failed_count++))
#             }
#         else
#             log "error" "File not found: $CUSTOM_FILE"
#             ((failed_count++))
#         fi
#     else
#         # Download predefined files
#         for file_mapping in "${FILES_TO_DOWNLOAD[@]}"; do
#             IFS=':' read -r source_path dest_path <<< "$file_mapping"
            
#             # Use source path as destination if no custom destination
#             dest_path="${dest_path:-$(basename "$source_path")}"

#             # Create destination directory
#             mkdir -p "$DOWNLOAD_DIR/$(dirname "$dest_path")"

#             # Copy file
#             if [[ -f "$source_path" ]]; then
#                 cp "$source_path" "$DOWNLOAD_DIR/$dest_path" && {
#                     log "info" "Downloaded: $source_path → $dest_path"
#                     ((downloaded_count++))
#                 } || {
#                     log "error" "Failed to download: $source_path"
#                     ((failed_count++))
#                 }
#             else
#                 log "warning" "File not found: $source_path"
#                 ((failed_count++))
#             fi
#         done
#     fi

#     # Summary
#     log "info" "Download Summary:"
#     log "info" "Branch: $BRANCH"
#     log "info" "Mode: $DOWNLOAD_MODE"
#     log "info" "Downloaded: $downloaded_count"
#     log "info" "Failed: $failed_count"

#     # Cleanup
#     cd ..
#     rm -rf "$TEMP_CLONE_DIR"
# }

# # Main execution
# main() {
#     local BRANCH="$DEFAULT_BRANCH"
#     local DOWNLOAD_MODE="specific"
#     local CUSTOM_FILE=""

#     # Parse arguments
#     case $# in
#         0)
#             # No arguments, use default predefined files
#             ;;
#         1)
#             # Single argument
#             if [[ "$1" == "all" ]]; then
#                 DOWNLOAD_MODE="all"
#             else
#                 # Treat as custom file or branch
#                 if [[ "$1" =~ ^[a-zA-Z0-9_\-\.\/]+$ ]]; then
#                     CUSTOM_FILE="$1"
#                 else
#                     BRANCH="$1"
#                 fi
#             fi
#             ;;
#         2)
#             # Two arguments
#             if [[ "$1" == "all" ]]; then
#                 DOWNLOAD_MODE="all"
#                 BRANCH="$2"
#             else
#                 # Custom file with specific branch
#                 CUSTOM_FILE="$1"
#                 BRANCH="$2"
#             fi
#             ;;
#     esac

#     # Call download function
#     download_specific_files "$BRANCH" "$DOWNLOAD_MODE" "$CUSTOM_FILE"
# }

# # Run script
# main "$@"







# #!/bin/bash

# # Selective Git File Downloader with Sparse Checkout

# # Configuration
# STATIC_REPO_URL="https://github.com/CodesByPankaj/cs-stock.git"
# DEFAULT_BRANCH="master"

# # Simple logging function
# log() {
#     echo "[${1^^}] $2"
# }

# # Download specific files with custom path mapping
# download_specific_files() {
#     local BRANCH="${1:-$DEFAULT_BRANCH}"
#     shift
#     local FILES_TO_DOWNLOAD=("$@")

#     # Directories
#     local DOWNLOAD_DIR="$HOME/downloaded_files"
#     local TEMP_CLONE_DIR="$HOME/temp_git_clone"

#     # Cleanup and prepare directories
#     rm -rf "$DOWNLOAD_DIR" "$TEMP_CLONE_DIR"
#     mkdir -p "$DOWNLOAD_DIR" "$TEMP_CLONE_DIR"
#     cd "$TEMP_CLONE_DIR" || exit 1

#     # Sparse checkout setup
#     git init
#     git remote add origin "$STATIC_REPO_URL"
#     git config core.sparseCheckout true

#     # Prepare sparse checkout file
#     local SPARSE_CHECKOUT_FILE=".git/info/sparse-checkout"
#     : > "$SPARSE_CHECKOUT_FILE"

#     # Collect files for checkout
#     for file_mapping in "${FILES_TO_DOWNLOAD[@]}"; do
#         [[ "$file_mapping" == \#* ]] && continue
#         IFS=':' read -r source_path _ <<< "$file_mapping"
#         echo "$source_path" >> "$SPARSE_CHECKOUT_FILE"
#     done

#     # Fetch and checkout
#     git fetch origin "$BRANCH" --depth 1
#     git checkout "$BRANCH"

#     # Download files
#     local downloaded_count=0
#     local failed_count=0

#     for file_mapping in "${FILES_TO_DOWNLOAD[@]}"; do
#         [[ "$file_mapping" == \#* ]] && continue
        
#         IFS=':' read -r source_path dest_path <<< "$file_mapping"
#         dest_path="${dest_path:-$(basename "$source_path")}"

#         if [ -f "$source_path" ]; then
#             mkdir -p "$DOWNLOAD_DIR/$(dirname "$dest_path")"
#             cp "$source_path" "$DOWNLOAD_DIR/$dest_path" && {
#                 log "info" "Downloaded: $source_path → $dest_path"
#                 ((downloaded_count++))
#             } || {
#                 log "error" "Failed to download: $source_path"
#                 ((failed_count++))
#             }
#         else
#             log "error" "File not found: $source_path"
#             ((failed_count++))
#         fi
#     done

#     # Summary
#     log "info" "Download Summary:"
#     log "info" "Branch: $BRANCH"
#     log "info" "Total files: ${#FILES_TO_DOWNLOAD[@]}"
#     log "info" "Downloaded: $downloaded_count"
#     log "info" "Failed: $failed_count"

#     # Cleanup
#     cd ..
#     rm -rf "$TEMP_CLONE_DIR"
# }

# # Main execution
# main() {
#     local FILES_TO_DOWNLOAD=(
#         "README.md:README.md"
#         "src/main/resources/application.properties:application.properties"
#         "src/main/resources/stocks.csv:stocks.csv"
#         "src/test/java/stock_management/cs_stock/CsStockApplicationTests.java"
#         "StockRecommendationReport.txt:StockRecommendationReport.txt"
#         "src/main/java/stock_management/cs_stock/constant/ConstantValue.java:ConstantValue.java"
#         "src/main/java/stock_management/cs_stock/interpreter/Dashboard.java:Dashboard.java"
#         "src/main/java/stock_management/cs_stock/patterns/CSVReader.java:CSVReader.java"
#     )

#     local BRANCH="${1:-$DEFAULT_BRANCH}"
#     [[ "$BRANCH" == "all" ]] && BRANCH="$DEFAULT_BRANCH"

#     download_specific_files "$BRANCH" "${FILES_TO_DOWNLOAD[@]}"
# }

# # Run script
# main "$@"














# #!/bin/bash

# # Selective Git File Downloader with Custom Path Mapping and Sparse Checkout

# # Configuration (Modify this section as needed)
# STATIC_REPO_URL="https://github.com/CodesByPankaj/cs-stock.git"
# DEFAULT_BRANCH="master"

# # Color codes for output
# RED='\033[0;31m'
# GREEN='\033[0;32m'
# YELLOW='\033[1;33m'
# BLUE='\033[0;34m'
# NC='\033[0m'

# # Logging function
# log_message() {
#     local type="$1"
#     local message="$2"
#     local color=""

#     case "$type" in
#         "info")    color="${GREEN}" ;;
#         "warning") color="${YELLOW}" ;;
#         "error")   color="${RED}" ;;
#         "debug")   color="${BLUE}" ;;
#         *)         color="${NC}" ;;
#     esac

#     echo -e "${color}[${type^^}]${NC} ${message}"
# }

# # Function to download specific files with custom path mapping
# download_specific_files() {
#     local BRANCH="${1:-$DEFAULT_BRANCH}"
#     shift
#     local FILES_TO_DOWNLOAD=("$@")

#     # Directories with explicit path expansion
#     local USERPROFILE="${USERPROFILE:-$HOME}"
#     local DOWNLOAD_DIR="$USERPROFILE/downloaded_files"

#     # Remove existing download directory
#     rm -rf "$DOWNLOAD_DIR"
#     mkdir -p "$DOWNLOAD_DIR"

#     # Temporary clone directory
#     local TEMP_CLONE_DIR="$USERPROFILE/temp_git_clone"
#     rm -rf "$TEMP_CLONE_DIR"
#     mkdir -p "$TEMP_CLONE_DIR"

#     # Change to temporary clone directory
#     cd "$TEMP_CLONE_DIR" || {
#         log_message "error" "Failed to create temporary directory"
#         return 1
#     }

#     # Extraction process
#     {
#         # Initialize git for sparse checkout
#         git init
#         git remote add origin "$STATIC_REPO_URL"
#         git config core.sparseCheckout true

#         # Prepare sparse checkout configuration
#         local SPARSE_CHECKOUT_FILE=".git/info/sparse-checkout"
#         : > "$SPARSE_CHECKOUT_FILE"  # Clear the file

#         # Process files with custom path mapping
#         local downloaded_count=0
#         local failed_count=0
#         local files_to_checkout=()

#         # Collect files to checkout
#         for file_mapping in "${FILES_TO_DOWNLOAD[@]}"; do
#             # Skip commented lines
#             [[ "$file_mapping" == \#* ]] && continue

#             # Split the mapping into source and destination
#             IFS=':' read -r source_path dest_path <<< "$file_mapping"

#             # Add to sparse checkout list
#             files_to_checkout+=("$source_path")
#             echo "$source_path" >> "$SPARSE_CHECKOUT_FILE"
#         done

#         # Fetch and checkout specific branch
#         git fetch origin "$BRANCH" --depth 1
#         git checkout "$BRANCH"

#         # Download files
#         for file_mapping in "${FILES_TO_DOWNLOAD[@]}"; do
#             # Skip commented lines
#             [[ "$file_mapping" == \#* ]] && continue

#             # Split the mapping into source and destination
#             IFS=':' read -r source_path dest_path <<< "$file_mapping"

#             # If no destination path is provided, use the source path
#             dest_path="${dest_path:-$(basename "$source_path")}"

#             # Check if file exists
#             if [ -f "$source_path" ]; then
#                 # Create destination directory preserving original structure
#                 mkdir -p "$DOWNLOAD_DIR/$(dirname "$dest_path")"
                
#                 # Copy file with custom destination name
#                 cp "$source_path" "$DOWNLOAD_DIR/$dest_path"
                
#                 if [ $? -eq 0 ]; then
#                     log_message "info" "Downloaded: $source_path → $dest_path ✓"
#                     ((downloaded_count++))
#                 else
#                     log_message "warning" "Failed to download: $source_path ✗"
#                     ((failed_count++))
#                 fi
#             else
#                 log_message "error" "File not found: $source_path ✗"
#                 ((failed_count++))
#             fi
#         done

#         # Detailed download summary
#         log_message "info" "Download Summary:"
#         log_message "info" "Repository: $STATIC_REPO_URL"
#         log_message "info" "Branch: $BRANCH"
#         log_message "info" "Total files requested: ${#FILES_TO_DOWNLOAD[@]}"
#         log_message "info" "Successfully downloaded: $downloaded_count"
#         log_message "info" "Failed downloads: $failed_count"

#         # Show downloaded files
#         log_message "debug" "Downloaded Files:"
#         find "$DOWNLOAD_DIR" -type f | sed "s|$DOWNLOAD_DIR/||"

#         # Clean up temporary clone directory
#         cd ..
#         rm -rf "$TEMP_CLONE_DIR"

#     } || {
#         log_message "error" "Download process failed"
#         return 1
#     }
# }

# # Main script execution
# main() {
#     # Define files to download with optional custom destination
#     local FILES_TO_DOWNLOAD=(
#         "README.md:README.md"
#         "src/main/resources/application.properties:application.properties"
#         "src/main/resources/stocks.csv:stocks.csv"
#         "src/test/java/stock_management/cs_stock/CsStockApplicationTests.java"
#         "StockRecommendationReport.txt:StockRecommendationReport.txt"
#         "src/main/java/stock_management/cs_stock/constant/ConstantValue.java:ConstantValue.java"
#         "src/main/java/stock_management/cs_stock/interpreter/Dashboard.java:Dashboard.java"
#         "src/main/java/stock_management/cs_stock/patterns/CSVReader.java:CSVReader.java"
#     )

#     # Determine branch
#     local BRANCH="$DEFAULT_BRANCH"
#     if [[ $# -gt 0 ]]; then
#         if [[ "$1" == "all" ]]; then
#             BRANCH="$DEFAULT_BRANCH"
#         else
#             BRANCH="$1"
#         fi
#     fi

#     # Download specific files
#     download_specific_files "$BRANCH" "${FILES_TO_DOWNLOAD[@]}"
# }

# # Run main function with all arguments
# main "$@"





# Without Sparse working fine but whole repository download
# #!/bin/bash

# # Selective Git File Downloader with Custom Path Mapping

# # Configuration (Modify this section as needed)
# STATIC_REPO_URL="https://github.com/CodesByPankaj/cs-stock.git"
# DEFAULT_BRANCH="master"

# # Color codes for output
# RED='\033[0;31m'
# GREEN='\033[0;32m'
# YELLOW='\033[1;33m'
# BLUE='\033[0;34m'
# NC='\033[0m'

# # Logging function
# log_message() {
#     local type="$1"
#     local message="$2"
#     local color=""

#     case "$type" in
#         "info")    color="${GREEN}" ;;
#         "warning") color="${YELLOW}" ;;
#         "error")   color="${RED}" ;;
#         "debug")   color="${BLUE}" ;;
#         *)         color="${NC}" ;;
#     esac

#     echo -e "${color}[${type^^}]${NC} ${message}"
# }

# # Function to download specific files with custom path mapping
# download_specific_files() {
#     local BRANCH="${1:-$DEFAULT_BRANCH}"
#     shift
#     local FILES_TO_DOWNLOAD=("$@")

#     # Directories with explicit path expansion
#     local USERPROFILE="${USERPROFILE:-$HOME}"
#     local DOWNLOAD_DIR="$USERPROFILE/downloaded_files"

#     # Remove existing download directory
#     rm -rf "$DOWNLOAD_DIR"
#     mkdir -p "$DOWNLOAD_DIR"

#     # Temporary clone directory
#     local TEMP_CLONE_DIR="$USERPROFILE/temp_git_clone"
#     rm -rf "$TEMP_CLONE_DIR"
#     mkdir -p "$TEMP_CLONE_DIR"

#     # Change to temporary clone directory
#     cd "$TEMP_CLONE_DIR" || {
#         log_message "error" "Failed to create temporary directory"
#         return 1
#     }

#     # Extraction process
#     {
#         # Clone the repository with the specified branch
#         git clone -b "$BRANCH" --depth 1 "$STATIC_REPO_URL" .

#         # Process files with custom path mapping
#         local downloaded_count=0
#         local failed_count=0

#         for file_mapping in "${FILES_TO_DOWNLOAD[@]}"; do
#             # Skip commented lines
#             [[ "$file_mapping" == \#* ]] && continue

#             # Split the mapping into source and destination
#             IFS=':' read -r source_path dest_path <<< "$file_mapping"

#             # If no destination path is provided, use the source path
#             dest_path="${dest_path:-$(basename "$source_path")}"

#             # Check if file exists
#             if [ -f "$source_path" ]; then
#                 # Create destination directory preserving original structure
#                 mkdir -p "$DOWNLOAD_DIR/$(dirname "$dest_path")"
                
#                 # Copy file with custom destination name
#                 cp "$source_path" "$DOWNLOAD_DIR/$dest_path"
                
#                 if [ $? -eq 0 ]; then
#                     log_message "info" "Downloaded: $source_path → $dest_path ✓"
#                     ((downloaded_count++))
#                 else
#                     log_message "warning" "Failed to download: $source_path ✗"
#                     ((failed_count++))
#                 fi
#             else
#                 log_message "error" "File not found: $source_path ✗"
#                 ((failed_count++))
#             fi
#         done

#         # Detailed download summary
#         log_message "info" "Download Summary:"
#         log_message "info" "Repository: $STATIC_REPO_URL"
#         log_message "info" "Branch: $BRANCH"
#         log_message "info" "Total files requested: ${#FILES_TO_DOWNLOAD[@]}"
#         log_message "info" "Successfully downloaded: $downloaded_count"
#         log_message "info" "Failed downloads: $failed_count"

#         # Show downloaded files
#         log_message "debug" "Downloaded Files:"
#         find "$DOWNLOAD_DIR" -type f | sed "s|$DOWNLOAD_DIR/||"

#         # Clean up temporary clone directory
#         cd ..
#         rm -rf "$TEMP_CLONE_DIR"

#     } || {
#         log_message "error" "Download process failed"
#         return 1
#     }
# }

# # Main script execution
# main() {
#     # Define files to download with optional custom destination
#     local FILES_TO_DOWNLOAD=(
#         "README.md:README.md"
#         "src/main/resources/application.properties:application.properties"
#         "src/main/resources/stocks.csv:stocks.csv"
#         "src/test/java/stock_management/cs_stock/CsStockApplicationTests.java"
#         "StockRecommendationReport.txt:StockRecommendationReport.txt"
#         "src/main/java/stock_management/cs_stock/constant/ConstantValue.java:ConstantValue.java"
#         "src/main/java/stock_management/cs_stock/interpreter/Dashboard.java:Dashboard.java"
#         "src/main/java/stock_management/cs_stock/patterns/CSVReader.java:CSVReader.java"
#     )

#     # Determine branch
#     local BRANCH="$DEFAULT_BRANCH"
#     if [[ $# -gt 0 ]]; then
#         if [[ "$1" == "all" ]]; then
#             BRANCH="$DEFAULT_BRANCH"
#         else
#             BRANCH="$1"
#         fi
#     fi

#     # Download specific files
#     download_specific_files "$BRANCH" "${FILES_TO_DOWNLOAD[@]}"
# }

# # Run main function with all arguments
# main "$@"






# #!/bin/bash

# # Advanced Git File Extraction Script with Static Repository

# # Configuration (Modify this section as needed)
# STATIC_REPO_URL="https://github.com/CodesByPankaj/cs-stock.git"
# DEFAULT_BRANCH="master"

# # Color codes for output
# RED='\033[0;31m'
# GREEN='\033[0;32m'
# YELLOW='\033[1;33m'
# BLUE='\033[0;34m'
# NC='\033[0m'

# # Logging function
# log_message() {
#     local type="$1"
#     local message="$2"
#     local color=""

#     case "$type" in
#         "info")    color="${GREEN}" ;;
#         "warning") color="${YELLOW}" ;;
#         "error")   color="${RED}" ;;
#         "debug")   color="${BLUE}" ;;
#         *)         color="${NC}" ;;
#     esac

#     echo -e "${color}[${type^^}]${NC} ${message}"
# }

# # Function to extract all files from a repository
# extract_all_files() {
#     local BRANCH="${1:-$DEFAULT_BRANCH}"
    
#     # Directories with explicit path expansion
#     local USERPROFILE="${USERPROFILE:-$HOME}"
#     local CLONE_DIR="$USERPROFILE/temp_git_clone"
#     local EXTRACT_DIR="$USERPROFILE/extracted_files"

#     # Remove existing directories
#     rm -rf "$CLONE_DIR" "$EXTRACT_DIR"
#     mkdir -p "$CLONE_DIR" "$EXTRACT_DIR"

#     # Change to clone directory
#     cd "$CLONE_DIR" || {
#         log_message "error" "Failed to change to clone directory"
#         return 1
#     }

#     # Extraction process
#     {
#         # Clone the entire repository
#         git clone --branch "$BRANCH" --depth 1 "$STATIC_REPO_URL" .

#         # Copy all files, preserving directory structure
#         cp -R . "$EXTRACT_DIR"

#         # Remove .git directory
#         rm -rf "$EXTRACT_DIR/.git"

#         # List extracted files
#         log_message "info" "All files extracted successfully from $STATIC_REPO_URL (Branch: $BRANCH)"
#         log_message "debug" "Extracted Files:"
#         find "$EXTRACT_DIR" -type f | sed "s|$EXTRACT_DIR/||"

#         # Clean up temporary clone directory
#         cd ..
#         rm -rf "$CLONE_DIR"

#     } || {
#         log_message "error" "Extraction process failed"
#         return 1
#     }
# }

# # Function to extract specific files
# extract_specific_files() {
#     local BRANCH="${1:-$DEFAULT_BRANCH}"
#     shift
#     local FILES_TO_EXTRACT=("$@")

#     # Directories with explicit path expansion
#     local USERPROFILE="${USERPROFILE:-$HOME}"
#     local CLONE_DIR="$USERPROFILE/temp_git_clone"
#     local EXTRACT_DIR="$USERPROFILE/extracted_files"

#     # Remove existing directories
#     rm -rf "$CLONE_DIR" "$EXTRACT_DIR"
#     mkdir -p "$CLONE_DIR" "$EXTRACT_DIR"

#     # Change to clone directory
#     cd "$CLONE_DIR" || {
#         log_message "error" "Failed to change to clone directory"
#         return 1
#     }

#     # Extraction process
#     {
#         # Initialize git
#         git init
#         git remote add origin "$STATIC_REPO_URL"
#         git config core.sparseCheckout true

#         # Prepare sparse checkout configuration
#         printf "%s\n" "${FILES_TO_EXTRACT[@]}" > .git/info/sparse-checkout

#         # Fetch and checkout
#         git fetch origin "$BRANCH" --depth 1
#         git checkout "$BRANCH"

#         # Extract and copy files
#         local extracted_count=0
#         local failed_count=0

#         for file in "${FILES_TO_EXTRACT[@]}"; do
#             # Trim potential leading/trailing whitespaces
#             file=$(echo "$file" | xargs)

#             if [ -f "$file" ]; then
#                 # Create destination directory if needed
#                 mkdir -p "$EXTRACT_DIR/$(dirname "$file")"
                
#                 # Copy file, preserving directory structure if needed
#                 cp "$file" "$EXTRACT_DIR/$file"
                
#                 if [ $? -eq 0 ]; then
#                     log_message "info" "Extracted: $file"
#                     ((extracted_count++))
#                 else
#                     log_message "warning" "Failed to extract: $file"
#                     ((failed_count++))
#                 fi
#             else
#                 log_message "warning" "File not found: $file"
#                 ((failed_count++))
#             fi
#         done

#         # Final summary
#         log_message "info" "Extraction Summary:"
#         log_message "info" "Repository: $STATIC_REPO_URL (Branch: $BRANCH)"
#         log_message "info" "Total files attempted: ${#FILES_TO_EXTRACT[@]}"
#         log_message "info" "Successfully extracted: $extracted_count"
#         log_message "info" "Failed extractions: $failed_count"

#         # List extracted files
#         log_message "debug" "Extracted Files:"
#         find "$EXTRACT_DIR" -type f | sed "s|$EXTRACT_DIR/||"

#         # Clean up temporary clone directory
#         cd ..
#         rm -rf "$CLONE_DIR"

#     } || {
#         log_message "error" "Extraction process failed"
#         return 1
#     }
# }

# # Main script execution
# main() {
#     # Check if required arguments are provided
#     if [[ $# -eq 0 ]]; then
#         log_message "error" "Usage: $0 [branch] [all|file1 file2 ...]"
#         log_message "error" "Examples:"
#         log_message "error" "  $0 all"
#         log_message "error" "  $0 master src/main/java/Example.java"
#         log_message "error" "  $0 develop file1.txt file2.txt"
#         exit 1
#     fi

#     # Check if first argument is a branch or an action
#     local BRANCH="$DEFAULT_BRANCH"
#     if [[ "$1" != "all" ]] && [[ ! "$1" == *"/"* ]]; then
#         # If first argument is a valid branch name
#         BRANCH="$1"
#         shift
#     fi

#     # Check if first argument is 'all'
#     if [[ "$1" == "all" ]]; then
#         # Extract all files
#         extract_all_files "$BRANCH"
#     else
#         # Remaining arguments are files to extract
#         local FILES_TO_EXTRACT=("$@")
        
#         # Extract specific files
#         extract_specific_files "$BRANCH" "${FILES_TO_EXTRACT[@]}"
#     fi
# }

# # Run main function with all arguments
# main "$@"







# #!/bin/bash

# # Git File Extraction and Cleanup Script for Windows

# # Color codes for output
# RED='\033[0;31m'
# GREEN='\033[0;32m'
# YELLOW='\033[1;33m'
# NC='\033[0m'

# # Logging function
# log_message() {
#     local type="$1"
#     local message="$2"
#     local color=""

#     case "$type" in
#         "info")    color="${GREEN}" ;;
#         "warning") color="${YELLOW}" ;;
#         "error")   color="${RED}" ;;
#         *)         color="${NC}" ;;
#     esac

#     echo -e "${color}[${type^^}]${NC} ${message}"
# }

# # Validate Git installation
# validate_git() {
#     if ! command -v git &> /dev/null; then
#         log_message "error" "Git is not installed. Please install Git."
#         exit 1
#     fi
# }

# # Extract and manage files
# extract_and_cleanup() {
#     # Repository Configuration
#     local REPO_URL="https://github.com/CodesByPankaj/cs-stock.git"
#     local BRANCH="master"
    
#     # Directories with explicit path expansion
#     local USERPROFILE="${USERPROFILE:-$HOME}"
#     local CLONE_DIR="$USERPROFILE/temp_git_clone"
#     local EXTRACT_DIR="$USERPROFILE/extracted_files"

#     # Validate Git
#     validate_git

#     # Remove existing directories if they exist
#     rm -rf "$CLONE_DIR" "$EXTRACT_DIR"

#     # Create new directories with full path
#     mkdir -p "$CLONE_DIR" "$EXTRACT_DIR"
#     cd "$CLONE_DIR" || {
#         log_message "error" "Failed to change to clone directory"
#         exit 1
#     }

#     # Files to extract (with simplified destination paths)
#     local FILES_TO_EXTRACT=(
#         "README.md:README.md"
#         "src/main/resources/application.properties:application.properties"
#         "src/main/resources/stocks.csv:stocks.csv"
#         "src/test/java/stock_management/cs_stock/CsStockApplicationTests.java"
#         "StockRecommendationReport.txt:StockRecommendationReport.txt"
#         "src/main/java/stock_management/cs_stock/constant/ConstantValue.java:ConstantValue.java"
#         "src/main/java/stock_management/cs_stock/interpreter/Dashboard.java:Dashboard.java"
#         "src/main/java/stock_management/cs_stock/patterns/CSVReader.java:CSVReader.java"
#     )

#     # Perform sparse checkout
#     {
#         # Initialize and configure git
#         git init
#         git remote add origin "$REPO_URL"
#         git config core.sparseCheckout true

#         # Extract source paths
#         local CHECKOUT_PATHS=()
#         for entry in "${FILES_TO_EXTRACT[@]}"; do
#             CHECKOUT_PATHS+=("${entry%%:*}")
#         done

#         # Write sparse checkout configuration
#         printf "%s\n" "${CHECKOUT_PATHS[@]}" > .git/info/sparse-checkout

#         # Fetch and checkout
#         git fetch origin "$BRANCH" --depth 1
#         git checkout "$BRANCH"

#         # Copy extracted files to destination
#         for entry in "${FILES_TO_EXTRACT[@]}"; do
#             # Split source and destination
#             local source_path="${entry%%:*}"
#             local dest_path="${entry#*:}"

#             if [ -f "$source_path" ]; then
#                 # Copy directly to extraction directory with simplified name
#                 cp "$source_path" "$EXTRACT_DIR/$dest_path"
#                 log_message "info" "Extracted: $dest_path"
#             else
#                 log_message "warning" "File not found: $source_path"
#             fi
#         done

#         # Verify extraction
#         log_message "info" "Extraction directory contents:"
#         ls -1 "$EXTRACT_DIR"

#         # Remove temporary clone directory
#         cd ..
#         rm -rf "$CLONE_DIR"

#         # Verify extraction directory exists and is not empty
#         if [ -d "$EXTRACT_DIR" ] && [ "$(ls -A "$EXTRACT_DIR")" ]; then
#             log_message "info" "Files successfully extracted to $EXTRACT_DIR"
#         else
#             log_message "error" "Extraction failed or directory is empty"
#             exit 1
#         fi
#     } || {
#         log_message "error" "Failed to extract files"
#         exit 1
#     }
# }

# # Main script execution
# main() {
#     # Execute extraction
#     extract_and_cleanup
# }

# # Run main function
# main





















# #!/bin/bash

# # Git File Extraction and Cleanup Script for Windows

# # Color codes for output
# RED='\033[0;31m'
# GREEN='\033[0;32m'
# YELLOW='\033[1;33m'
# NC='\033[0m'

# # Logging function
# log_message() {
#     local type="$1"
#     local message="$2"
#     local color=""

#     case "$type" in
#         "info")    color="${GREEN}" ;;
#         "warning") color="${YELLOW}" ;;
#         "error")   color="${RED}" ;;
#         *)         color="${NC}" ;;
#     esac

#     echo -e "${color}[${type^^}]${NC} ${message}"
# }

# # Validate Git installation
# validate_git() {
#     if ! command -v git &> /dev/null; then
#         log_message "error" "Git is not installed. Please install Git."
#         exit 1
#     fi
# }

# # Convert Windows path to POSIX path
# convert_to_posix_path() {
#     local windows_path="$1"
#     # Remove drive letter and convert backslashes to forward slashes
#     local posix_path=$(echo "$windows_path" | sed -e 's/^[A-Za-z]://' -e 's|\\|/|g')
#     echo "$posix_path"
# }

# # Extract and manage files
# extract_and_cleanup() {
#     # Repository Configuration
#     local REPO_URL="https://github.com/CodesByPankaj/cs-stock.git"
#     local BRANCH="master"
    
#     # Directories with explicit path expansion
#     local USERPROFILE="${USERPROFILE:-$HOME}"
#     local CLONE_DIR="$USERPROFILE/temp_git_clone"
#     local EXTRACT_DIR="$USERPROFILE/extracted_files"

#     # Validate Git
#     validate_git

#     # Remove existing directories if they exist
#     rm -rf "$CLONE_DIR" "$EXTRACT_DIR"

#     # Create new directories with full path
#     mkdir -p "$CLONE_DIR" "$EXTRACT_DIR"
#     cd "$CLONE_DIR" || {
#         log_message "error" "Failed to change to clone directory"
#         exit 1
#     }

#     # Files to extract (can be modified as needed)
#     local FILES_TO_EXTRACT=(
#         "README.md"
#         "src/main/resources/application.properties"
#         "src/main/resources/stocks.csv"
#         "StockRecommendationReport.txt"
#         "src/main/java/stock_management/cs_stock/constant/ConstantValue.java"
#         "src/main/java/stock_management/cs_stock/interpreter/Dashboard.java"
#         "src/main/java/stock_management/cs_stock/patterns/CSVReader.java"
#     )

#     # Perform sparse checkout
#     {
#         # Initialize and configure git
#         git init
#         git remote add origin "$REPO_URL"
#         git config core.sparseCheckout true

#         # Write sparse checkout configuration
#         printf "%s\n" "${FILES_TO_EXTRACT[@]}" > .git/info/sparse-checkout

#         # Fetch and checkout
#         git fetch origin "$BRANCH" --depth 1
#         git checkout "$BRANCH"

#         # Copy extracted files to destination
#         for file in "${FILES_TO_EXTRACT[@]}"; do
#             if [ -f "$file" ]; then
#                 # Ensure directory structure exists
#                 mkdir -p "$EXTRACT_DIR/$(dirname "$file")"
#                 cp "$file" "$EXTRACT_DIR/$file"
#                 log_message "info" "Extracted: $file"
#             else
#                 log_message "warning" "File not found: $file"
#             fi
#         done

#         # Verify extraction
#         log_message "info" "Extraction directory contents:"
#         find "$EXTRACT_DIR" -type f | sed "s|$EXTRACT_DIR/||"

#         # Remove temporary clone directory
#         cd ..
#         rm -rf "$CLONE_DIR"

#         # Verify extraction directory exists and is not empty
#         if [ -d "$EXTRACT_DIR" ] && [ "$(ls -A "$EXTRACT_DIR")" ]; then
#             log_message "info" "Files successfully extracted to $EXTRACT_DIR"
#         else
#             log_message "error" "Extraction failed or directory is empty"
#             exit 1
#         fi
#     } || {
#         log_message "error" "Failed to extract files"
#         exit 1
#     }
# }

# # Main script execution
# main() {
#     # Execute extraction
#     extract_and_cleanup
# }

# # Run main function
# main





















# #!/bin/bash

# # Git File Extraction and Cleanup Script

# # Color codes for output
# RED='\033[0;31m'
# GREEN='\033[0;32m'
# YELLOW='\033[1;33m'
# NC='\033[0m'

# # Logging function
# log_message() {
#     local type="$1"
#     local message="$2"
#     local color=""

#     case "$type" in
#         "info")    color="${GREEN}" ;;
#         "warning") color="${YELLOW}" ;;
#         "error")   color="${RED}" ;;
#         *)         color="${NC}" ;;
#     esac

#     echo -e "${color}[${type^^}]${NC} ${message}"
# }

# # Validate Git installation
# validate_git() {
#     if ! command -v git &> /dev/null; then
#         log_message "error" "Git is not installed. Please install Git."
#         exit 1
#     fi
# }

# # Extract and manage files
# extract_and_cleanup() {
#     # Repository Configuration
#     local REPO_URL="https://github.com/CodesByPankaj/cs-stock.git"
#     local BRANCH="master"
    
#     # Directories
#     local CLONE_DIR="${USERPROFILE:-$HOME}/temp_git_clone"
#     local EXTRACT_DIR="${USERPROFILE:-$HOME}/extracted_files"

#     # Validate Git
#     validate_git

#     # Remove existing directories if they exist
#     rm -rf "$CLONE_DIR" "$EXTRACT_DIR"

#     # Create new directories
#     mkdir -p "$CLONE_DIR" "$EXTRACT_DIR"
#     cd "$CLONE_DIR" || exit 1

#     # Files to extract (can be modified as needed)
#     local FILES_TO_EXTRACT=(
#         "README.md"
#         "src/main/resources/application.properties"
#         "src/main/resources/stocks.csv"
#         "StockRecommendationReport.txt"
#         "src/main/java/stock_management/cs_stock/constant/ConstantValue.java"
#         "src/main/java/stock_management/cs_stock/interpreter/Dashboard.java"
#         "src/main/java/stock_management/cs_stock/patterns/CSVReader.java"
#     )

#     # Perform sparse checkout
#     {
#         # Initialize and configure git
#         git init
#         git remote add origin "$REPO_URL"
#         git config core.sparseCheckout true

#         # Write sparse checkout configuration
#         printf "%s\n" "${FILES_TO_EXTRACT[@]}" > .git/info/sparse-checkout

#         # Fetch and checkout
#         git fetch origin "$BRANCH" --depth 1
#         git checkout "$BRANCH"

#         # Copy extracted files to destination
#         for file in "${FILES_TO_EXTRACT[@]}"; do
#             if [ -f "$file" ]; then
#                 # Ensure directory structure exists
#                 mkdir -p "$EXTRACT_DIR/$(dirname "$file")"
#                 cp "$file" "$EXTRACT_DIR/$file"
#                 log_message "info" "Extracted: $file"
#             else
#                 log_message "warning" "File not found: $file"
#             fi
#         done

#         # Remove temporary clone directory
#         cd ..
#         rm -rf "$CLONE_DIR"

#         log_message "info" "Files extracted to $EXTRACT_DIR"
#     } || {
#         log_message "error" "Failed to extract files"
#         exit 1
#     }
# }

# # Main script execution
# main() {
#     # Execute extraction
#     extract_and_cleanup
# }

# # Run main function
# main


















# #!/bin/bash

# # Check if git is installed
# git --version || { echo "Git not found in PATH"; exit 1; }
# echo "Current PATH: $PATH"

# # Function to download files using sparse checkout
# download_files_with_sparse_checkout() {
#     REPO_URL="https://github.com/CodesByPankaj/cs-stock.git"
#     BRANCH="master"
#     # Use Windows-specific home directory
#     CLONE_DIR="${USERPROFILE}/gitconfigs"

#     # Create the directory if it doesn't exist
#     if [ ! -d "$CLONE_DIR" ]; then
#         mkdir -p "$CLONE_DIR"
#     fi

#     # Navigate to the clone directory
#     cd "$CLONE_DIR" || exit

#     # Initialize a new git repository if it doesn't exist
#     if [ ! -d ".git" ]; then
#         git init
#     fi

#     # Check if the remote already exists
#     if ! git remote get-url origin > /dev/null 2>&1; then
#         git remote add origin "$REPO_URL"
#     else
#         echo "Remote 'origin' already exists."
#     fi

#     # Clear previous sparse-checkout configuration
#     git sparse-checkout init --cone

#     # If specific files are provided, set CONFIG_PATHS to those files
#     if [ $# -gt 0 ]; then
#         CONFIG_PATHS=("$@")  # Use all arguments as the paths
#     else
#         # Specify the files you want to download
#         CONFIG_PATHS=(
#             "src/main/java/stock_management/cs_stock/constant/ConstantValue.java"
#             "src/main/java/stock_management/cs_stock/interpreter/Dashboard.java"
#             "src/main/java/stock_management/cs_stock/patterns/CSVReader.java"
#             "src/main/resources/application.properties"
#             "src/main/resources/stocks.csv"
#             "README.md"
#             "StockRecommendationReport.txt"
#         )
#     fi

#     # Set sparse-checkout paths
#     git sparse-checkout set "${CONFIG_PATHS[@]}"

#     # Fetch and checkout
#     git fetch origin "$BRANCH"
#     git checkout "$BRANCH"

#     echo "Downloaded specified files to $CLONE_DIR."
# }

# # Main script execution
# download_files_with_sparse_checkout "$@"