#!/bin/bash

# Define the directory where your scripts are located
SCRIPT_DIR="~/mkv-snapshot"

# Check if the directory exists
if [ -d "$SCRIPT_DIR" ]; then
    # Change directory
    cd "$SCRIPT_DIR" || exit
    # Find all .sh files and execute them
    find . -maxdepth 1 -type f -name "*.sh" -exec chmod +x {} \; -exec bash {} \;
    echo "Executed all .sh scripts in $SCRIPT_DIR"
else
    echo "Error: Directory $SCRIPT_DIR does not exist."
fi
