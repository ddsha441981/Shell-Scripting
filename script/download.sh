#!/bin/bash

# GitHub repository information
REPO_OWNER="CodesByPankaj"
REPO_NAME="cs-stock"
GITHUB_TOKEN="YOUR-PAT-TOKEN"

# The file path to download (you can modify this as needed)
FILE_PATH="$1"

if [ -z "$FILE_PATH" ]; then
  echo "Usage: $0 <file-path>"
  exit 1
fi

# URL to fetch the file content metadata
API_URL="https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/contents/$FILE_PATH"

# Use curl to fetch file metadata
response=$(curl -s -H "Accept: application/vnd.github+json" \
                 -H "Authorization: Bearer $GITHUB_TOKEN" \
                 -H "X-GitHub-Api-Version: 2022-11-28" \
                 $API_URL)

# Check if the file exists by inspecting the response
if [[ $(echo $response | jq -r '.content') != "null" ]]; then
    # Extract the base64 encoded content from the response
    file_content=$(echo $response | jq -r '.content')

    # Decode and save the content to the specified file
    echo $file_content | base64 --decode > $(basename $FILE_PATH)
    echo "$FILE_PATH has been downloaded successfully."
else
    echo "File not found or unable to retrieve the content."
fi
