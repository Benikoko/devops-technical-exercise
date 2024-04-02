#!/bin/bash

# Set paths
current_directory=$(pwd)
added_directory="$current_directory/deployPackage/added"
removed_directory="$current_directory/deployPackage/removed"
file_diff="file_diff.txt"

# Create added and removed directories if they don't exist
mkdir -p "$added_directory"
mkdir -p "$removed_directory"

# Read file_diff.txt line by line
while IFS= read -r line
do
    # Extract status and file name
    status=$(echo "$line" | awk '{print $1}')
    file_name=$(echo "$line" | awk '{print $2}')

    # Extract file name without path
    file_name=$(basename "$file_name")

    # Move/copy files based on status
    if [ "$status" = "M" ] || [ "$status" = "A" ]; then
        # Move/copy to added directory
        cp "$file_name" "$added_directory"
        echo "Moved $file_name to added directory."
    elif [ "$status" = "R" ] || [ "$status" = "D" ]; then
        # Move/copy to removed directory
        cp "$file_name" "$removed_directory"
        echo "Moved $file_name to removed directory."
    fi
done < "$file_diff"IFS
