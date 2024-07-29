#!/bin/bash

# Define the directory where your scripts are located
SCRIPT_DIR="$HOME/mkv-snapshot/provider"

# Change directory
cd "$SCRIPT_DIR" || exit

# List of scripts to run
SCRIPTS=(
    "emoney.sh"
    "kava.sh"
    # "kichain.sh"
    "odin.sh"
    # "testodin.sh"
)

# Loop through each script and execute it
for script in "${SCRIPTS[@]}"; do
    if [ -f "$script" ]; then
        # Execute the script
        echo "Executing $script..."
        bash "$script"
        echo "Finished executing $script."
    else
        echo "Error: Script $script not found."
    fi
done

echo "All scripts executed."