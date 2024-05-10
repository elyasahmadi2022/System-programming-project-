#!/usr/bin/env bash

# Function to count the number of files and directories in a directory
countFilesAndDirs() {
    local dirPath="$1"
    local fileCount=0
    local dirCount=0
    local executableCount=0
    local nonExecutableCount=0
    local readPermissionCount=0
    local writePermissionCount=0

    if ! cd "$dirPath"; then
        echo "Unable to change directory to '$dirPath'"
        return 1
    fi

    while IFS= read -r -d '' entry; do
        if [[ -f "$entry" ]]; then
            if [[ -x "$entry" ]]; then
                executableCount=$((executableCount + 1))
            else
                nonExecutableCount=$((nonExecutableCount + 1))
            fi

            if [[ -r "$entry" ]]; then
                readPermissionCount=$((readPermissionCount + 1))
            fi

            if [[ -w "$entry" ]]; then
                writePermissionCount=$((writePermissionCount + 1))
            fi
        elif [[ -d "$entry" ]]; then
            dirCount=$((dirCount + 1))
        fi
    done < <(find . -maxdepth 1 -print0)

    cd ..
    echo "$fileCount $dirCount $executableCount $nonExecutableCount $readPermissionCount $writePermissionCount"
}