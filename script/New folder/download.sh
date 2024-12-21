#!/bin/bash

# Function to download file from GitHub repository
download_file() {
  local file_path="$1"
  local repo_owner="$2"
  local repo_name="$3"
  local branch="$4"
  local github_token="$5"

  # Construct the direct download URL
  local download_url="https://raw.githubusercontent.com/$repo_owner/$repo_name/$branch/$file_path"

  # Use curl to download the file
  curl -L -H "Authorization: Bearer $github_token" -o "$(basename "$file_path")" "$download_url"

  # Check if the file was downloaded successfully
  if [[ $? -eq 0 ]]; then
    echo "$file_path has been downloaded successfully."
  else
    echo "Failed to download the file."
    exit 1
  fi
}

# Main script starts here
main() {
  # Ensure the correct number of arguments are passed (1 or 2 arguments expected)
  if [[ $# -lt 1 || $# -gt 2 ]]; then
    echo "Usage: $0 <file-path> [branch]"
    exit 1
  fi

  # GitHub repository information
  local repo_owner="CodesByPankaj"
  local repo_name="cs-stock"

  # File path to download (first argument passed to the script)
  local file_path="$1"

  # Optional branch argument (default to 'master' if not provided)
  local branch="${2:-master}"

  # GitHub token (hardcoded inside the script)
  local github_token="YOUR-PAT-TOKEN"

  # Call the download function
  download_file "$file_path" "$repo_owner" "$repo_name" "$branch" "$github_token"
}

# Execute the main function
main "$@"
