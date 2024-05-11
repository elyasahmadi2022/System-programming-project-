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
# Function to count the number of files with each format and display the table
countFormatsAndDisplay() {
    local dirPath="$1"
    local totalFiles=0
    local totalSize=0
    declare -A formatCounts
    declare -A formatSizes

    if ! cd "$dirPath"; then
        echo "Unable to change directory to '$dirPath'"
        return 1
    fi

    printf "%-30s%-30s%-30s\n" "Total Files:" "File Format:" "Total Size (KB):"
   for file in *; do
        if [[ -f "$file" ]]; then
            format="${file##*.}"
            size="$(du -k "$file" | awk '{print $1}')"
            ((formatCounts[$format]++))
            ((formatSizes[$format] += size))
            ((totalFiles++))
            ((totalSize += size))
        fi
    done

    for format in "${!formatCounts[@]}"; do
        count="${formatCounts[$format]}"
        size="${formatSizes[$format]}"
        printf "%-30s%-30s%-30s\n" "$count" "$format" "$size"
    done

    printf "\------------------------------------------------------\n"
    printf "Total Number of Files:  %2d\n" "$totalFiles"
    printf "Total Size of Files:    %2.2f KB\n" "$totalSize"
    cd ..
}

# Check if user provided the '-r' or '-w' flag
if [[ "$1" == "-r" ]]; then
    readPermissionFlag=true
elif [[ "$1" == "-w" ]]; then   
    writePermissionFlag=true
fi

# Get the directory path from command-line argument
dirPath="$2"

# Validate if the directory path exists
if [[ ! -d "$dirPath" ]]; then
    echo "Directory '$dirPath' does not exist."
    exit 1
fi

fileAndDirCounts=$(countFilesAndDirs "$dirPath")
fileCount=$(echo "$fileAndDirCounts" | awk '{print $1}')
dirCount=$(echo "$fileAndDirCounts" | awk '{print $2}')
executableCount=$(echo "$fileAndDirCounts" | awk '{print $3}')
nonExecutableCount=$(echo "$fileAndDirCounts" | awk '{print $4}')
readPermissionCount=$(echo "$fileAndDirCounts" | awk '{print $5}')
writePermissionCount=$(echo "$fileAndDirCounts" | awk '{print $6}')

printf "Total Directories:                %2d\n" "$dirCount"
printf "Files with execute permission:    %2d\n" "$executableCount"
printf "Files without execute permission: %2d\n" "$nonExecutableCount"

# Display read permission count if the flag is provided
if [[ -n $readPermissionFlag ]]; then
    printf "Files with read permission:       %2d\n" "$readPermissionCount"
fi

# Display write permission count if the flag is provided
if [[ -n $writePermissionFlag ]]; then
    printf "Files with write permission:      %2d\n" "$writePermissionCount"
fi

countFormatsAndDisplay "$dirPath"
