#!/bin/bash

# Change to directory where your 4chan-downloader. By default, this will cd to the parent directory of the bash script
cd $(dirname $0)/


# Prompt the user for the thread URL
echo -n "Enter the thread URL: "
read thread
# echo "Thread URL entered: $thread"

# Prompt the user for the additional folder name
echo -n "Enter the name for the folder: "
read additional_folder_name
# echo "Additional folder name entered: $additional_folder_name"

# Inform the user that the Python script is about to run
# echo "Running the Python script with the provided thread URL..."
python3 inb4404.py -c -n $thread
echo -e "\nThread $(basename $thread) downloaded."

# Wait for a short period to ensure the Python script has created the folder
# echo "Waiting for the folder to be created by the script..."
# sleep 2
# echo "Wait complete."

# Determine the original folder name (assumed to be the last part of the URL)
original_folder_name=$(basename $thread)
# echo "Original folder name determined as: $original_folder_name"

# Rename the folder to include both the original and additional names
final_folder_name="${original_folder_name} - ${additional_folder_name}"

# Search for existing folders containing the original folder name, excluding the exact match
matching_folders=$(find "./downloads/gif/" -type d -name "*$original_folder_name*" ! -name "$original_folder_name")

if [ ! -z "$matching_folders" ]; then
    echo "One or more folders containing '$original_folder_name' already exist:"
    echo "$matching_folders"
    read -p "Do you want to merge contents into the first matching folder? (y/n): " confirm
    if [ "$confirm" = "y" ]; then
        first_matching_folder=$(echo "$matching_folders" | head -n 1)
        # Merge contents from the original folder to the first existing folder found
        cp -rn "./downloads/gif/$original_folder_name/"* "$first_matching_folder/"
        echo "Contents merged successfully into $first_matching_folder."

        # Optionally, remove the original folder after merging
        rm -r "./downloads/gif/$original_folder_name"
        echo "Original folder removed after merging."
    else
        echo "Exiting without merging files."
        exit 1
    fi
else
    # Proceed with renaming if no matching folder exists
    mv "./downloads/gif/$original_folder_name" "./downloads/gif/$final_folder_name"
    echo "Folder renamed to: \"$final_folder_name\""
fi

# echo "Script execution completed successfully."
