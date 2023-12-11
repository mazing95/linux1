#!/bin/bash

# This checks if the number of arguments is correct
# If the number of arguments is incorrect ( $# != 2) print error message and exit
if [[ $# != 2 ]]
then
  echo "backup.sh target_directory_name destination_directory_name"
  exit
fi

# This checks if argument 1 and argument 2 are valid directory paths
if [[ ! -d $1 ]] || [[ ! -d $2 ]]
then
  echo "Invalid directory path provided"
  exit
fi

# [TASK 1]
# Set two variables equal to the values of the first and second command line arguments
targetDirectory=$1
destinationDirectory=$2

# [TASK 2]
# Display the values of the two command line arguments in the terminal
echo "Target Directory: $targetDirectory"
echo "Destination Directory: $destinationDirectory"

# [TASK 3]
# Define a variable called currentTS as the current timestamp, expressed in seconds
currentTS=$(date +%s)

# [TASK 4]
# Define a variable called backupFileName to store the name of the archived and compressed backup file
# The variable backupFileName should have the value "backup-[$currentTS].tar.gz"
backupFileName="backup-$currentTS.tar.gz"

# We're going to:
# 1: Go into the target directory
# 2: Create the backup file
# 3: Move the backup file to the destination directory

# we will define some useful variables

# [TASK 5]
# Define a variable called origAbsPath with the absolute path of the current directory as the variable's value
origAbsPath=$(pwd)

# [TASK 6]
# Define a variable called destAbsPath whose value equals the absolute path of the destination directory
# First use cd to go to destinationDirectory, then use the same method you used in Task 5
cd $destinationDirectory
destDirAbsPath=$(pwd)

# [TASK 7]
# Change directories from the current working directory to the target directory targetDirectory
cd $origAbsPath
cd $targetDirectory

# [TASK 8]
# Define a numerical variable called yesterdayTS as the timestamp (in seconds) 24 hours prior to the current timestamp, currentTS
yesterdayTS=$(($currentTS - 24 * 60 * 60))

declare -a toBackup

for file in $(ls)
do
  # [TASK 10]
  # Inside the for loop, check whether the $file was modified within the last 24 hours
  if [ $(date -r $file +%s) -gt $yesterdayTS ]
  then
    # [TASK 11]
    # Add the $file that was updated in the past 24 hours to the toBackup array
    toBackup+=("$file")
  fi
done

# [TASK 12]
# After the for loop, compress and archive the files, using the $toBackup array of filenames, to a file with the name backupFileName
tar -czvf $backupFileName "${toBackup[@]}"

# [TASK 13]
# Move the file $backupFileName to the destination directory located at destDirAbsPath
mv $backupFileName $destDirAbsPath
