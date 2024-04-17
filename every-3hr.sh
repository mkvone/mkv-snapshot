#!/bin/bash

# Define the directory where your scripts are located
SCRIPT_DIR="/home/ubuntu/mkv-snapshot"

# Log file path
LOG_FILE="/home/ubuntu/mkv-snapshot/logs/every-3hr_log.txt"

# Check if the directory exists
if [ -d "$SCRIPT_DIR" ]; then
    # Change directory
    cd "$SCRIPT_DIR" || exit
    
    # Loop through each script and execute it
    for script in "${SCRIPTS[@]}"; do
        if [ -f "$script" ]; then
            # Execute the script
            echo "Executing $script..."
            ./"$script" >> "$LOG_FILE" 2>&1
            echo "Finished executing $script."
        else
            echo "Error: Script $script not found."
        fi
    done

    echo "All scripts executed."
else
    echo "Error: Directory $SCRIPT_DIR does not exist."
fi