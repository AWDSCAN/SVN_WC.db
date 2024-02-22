#!/bin/bash

# Bash Script to Download Files Based on SVN Paths
# Usage: script.sh --baseurl <baseurl> --input <input_file> --output <output_dir>

# Initialize variables
baseurl=""
input_file=""
output_dir=""

# Function to display usage information
usage() {
    echo "Usage: $0 --baseurl <baseurl> --input <input_file> --output <output_dir>"
    echo "  --baseurl: Base URL for constructing the download path."
    echo "  --input: Path to the input file containing file paths and SVN bases."
    echo "  --output: Output directory where files will be downloaded, maintaining the original structure."
    exit 1
}

# Parse command line arguments
while [ "$#" -gt 0 ]; do
    case "$1" in
        --baseurl) baseurl="$2"; shift 2;;   # Assign base URL
        --input) input_file="$2"; shift 2;;  # Assign input file path
        --output) output_dir="$2"; shift 2;; # Assign output directory
        *) usage ;; # Display usage if arguments are incorrect
    esac
done

# Validate arguments
if [ -z "$baseurl" ] || [ -z "$input_file" ] || [ -z "$output_dir" ]; then
    echo "Error: Missing arguments."
    usage
fi

# Check if the input file exists
if [ ! -f "$input_file" ]; then
    echo "File not found: $input_file"
    exit 1
fi

# Create the output directory if it doesn't exist
mkdir -p "$output_dir"

# Process each line in the input file
while IFS='|' read -r file_path svn_base; do
    # Skip empty lines
    if [ -z "$file_path" ]; then
        continue
    fi

    # Extract directory from file_path
    directory_path=$(dirname "$file_path")

    # Create corresponding directory structure in the output directory
    mkdir -p "${output_dir}/${directory_path}"

    # Construct the download path using the base URL and svn_base
    if [ -n "$svn_base" ]; then
        curl_downloadpath="${baseurl}/${svn_base}"

        # Define the output file path in the output directory
        output_file="${output_dir}/${file_path}"

        # Download the file using curl
        echo "Downloading $curl_downloadpath to $output_file"
        curl -o "$output_file" "$curl_downloadpath"
    else
        echo "No SVN base for $file_path, skipping download."
    fi
done < "$input_file"

echo "Processing complete. Files downloaded to ${output_dir}"
