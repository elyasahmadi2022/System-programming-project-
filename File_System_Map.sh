#!/usr/bin/bash
echo"Welcome For the First Line of Code in Shell Scripts"
echo My BASH Name is $BASH # This a variable that will shows the Bash Name in Linux
echo My Bash Version is $BASH_VERSION #This is a variable that will shows the Bash Version
echo My Home Directory is $HOME # This is a variable that will shows the Home directory in Linux.
echo "If we want to make a file system map first we should make a directoty"
#here we are going to get input from keyboard 
echo "Hello , please Enter Your name"
read $name
echo "Your Name is $name"
echo "How old are you "
read $age
echo "You are about $age years old"

if [ $# -eq 0 ]; then
    echo "Usage: FileSystemMap <directory>"
    exit 1
fi
directory="$1"

if [ ! -d "$directory" ]; then
    echo "Directory does not exist: $directory"
    exit 1
fi
find "$directory" -type d -print
find "$directory" -type f -print
