#!/bin/bash

# Configuration Variables
GITHUB_API="https://api.github.com"
REPO_OWNER="CodesByPankaj"
REPO_NAME="cs-stock.git"
BRANCH_NAME="master"
BASE_PATH="https://github.com/$REPO_OWNER/$REPO_NAME"
#https://github.com/CodesByPankaj/cs-stock.git

# Personal Access Token (PAT) - replace with your actual GitHub PAT
GITHUB_TOKEN="YOUR-PAT-TOKEN"  # **Replace this with your actual PAT**

# Function to search for a file in the repository
# Function to search for a file in the repository
search_file() {
    local file_name="$1"
    local branch="$2"
    
    echo "============================"
    echo "Searching for file '$file_name' in repository '$REPO_NAME' on branch '$branch'..."
    
    # Search just by the file name (basename)
    response=$(curl -s -H "Authorization: token $GITHUB_TOKEN" \
           "$GITHUB_API/search/code?q=$(basename "$file_name")+repo:$REPO_OWNER/$REPO_NAME+branch:$branch")
    
    # Debugging output
    echo "API Response: $response"

    # Check if file is found in the search results
    if echo "$response" | jq -e '.items | length > 0' > /dev/null; then
        echo "File found in repository."
        file_url=$(echo "$response" | jq -r '.items[0].html_url')
        raw_url="https://raw.githubusercontent.com/$REPO_OWNER/$REPO_NAME/$branch/$(echo "$file_url" | sed 's|https://github.com/||g' | sed 's|blob/|raw/|')"
        
        echo "File URL: $file_url"
        echo "Downloading file from: $raw_url"
        curl -s -L -o "$file_name" "$raw_url"
        
        if [ $? -eq 0 ]; then
            echo "File '$file_name' downloaded successfully."
        else
            echo "Error downloading the file."
        fi
    else
        echo "File '$file_name' not found in repository '$REPO_NAME' on branch '$branch'."
    fi
    echo "============================"
}

# Main script execution
if [ -z "$1" ]; then
    echo "Usage: $0 <file-name>"
    exit 1
fi

file_name="$1"

# If a branch is passed, use that; otherwise default to 'master'
if [ ! -z "$2" ]; then
    branch_name="$2"
    echo "Using branch: $branch_name"
else
    branch_name="$BRANCH_NAME"
    echo "Using default branch: $branch_name"
fi

# Call the function to search and download the file
search_file "$file_name" "$branch_name"