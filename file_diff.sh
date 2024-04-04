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

    # Move/copy files based on status
    if [ "$status" = "M" ] || [ "$status" = "A" ]; then
      case $status in
        # Move/copy to added directory
        Objects)
        if [ ! -d "${objects_directory}/${file_name}" ]; then
          cp "$objects_directory/$file_name" "$added_directory" 
        else
          :
        fi
        ;;
        
        Profiles)
        if [ ! -d "${profiles_directory}/${file_name}" ]; then
          cp "$profiles_directory/$file_name" "$added_directory"
        else
          :
        fi
        ;;
        
        Reports)
        if [ ! -d "${reports_directory}/${file_name}" ]; then
          cp "$reports_directory/$file_name" "$added_directory"
        else
          :
        fi
        ;;
      
      esac  
      echo "Moved $file_name to added directory."
      
    elif [ "$status" = "R" ] || [ "$status" = "D" ]; then
      case $status in
        # Move/copy to removed directory
        Objects)
        if [ ! -d "${objects_directory}/${file_name}" ]; then
          cp "$objects_directory/$file_name" "$removed_directory"
        else
          :
        fi
        ;;
        
        Profiles)
        if [ ! -d "${profiles_directory}/${file_name}" ]; then
          cp "$profiles_directory/$file_name" "$added_directory"
        else
          :
        fi
        ;;
        
        Reports)
        if [ ! -d "${profiles_directory}/${file_name}" ]; then
          cp "$reports_directory/$file_name" "$added_directory"
        else
          :
        fi
        ;;
        
      esac
      echo "Moved $file_name to removed directory."
      
    fi
    
done < "$file_diff"
