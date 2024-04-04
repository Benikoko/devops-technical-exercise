#!/bin/bash

# Set paths
current_directory=$(pwd)
added_directory="$current_directory/deployPackage/added"
removed_directory="$current_directory/deployPackage/removed"
file_diff="$current_directory/file_diff.txt"
objects_directory="$current_directory/src/objects"
profiles_directory="$current_directory/src/profiles"
reports_directory="$current_directory/src/reports"


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

     # Determine the directory based on the file name
    directory=""
    case $file_name in
        *.object) directory="$objects_directory" ;;
        *.profile) directory="$profiles_directory" ;;
        *.report) directory="$reports_directory" ;;
        *) echo "Unknown file type: $file_name"; continue ;;
    esac

    # Move/copy files based on status
    if [ "$status" = "M" ] || [ "$status" = "A" ]; then
        if [ -f "${directory}/${file_name}" ]; then
            cp "${directory}/${file_name}" "$added_directory"
            echo "Moved $file_name to added directory."
        fi
    elif [ "$status" = "R" ] || [ "$status" = "D" ]; then
        if [ -f "${directory}/${file_name}" ]; then
            cp "${directory}/${file_name}" "$removed_directory"
            echo "Moved $file_name to removed directory."
        fi
    fi
done < "$file_diff"