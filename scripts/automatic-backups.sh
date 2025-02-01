#!/run/current-system/sw/bin/bash

# Check args
# Check if two arguments are provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <source_directory> <destination_directory>"
    exit 1
fi

# Source directory (first argument)
src="$1"

# Destination directory (second argument)
dst="$2"

# Get todays date
today=$(date +%Y-%m-%d)

backupfile="${dst}/${today}.tar.gz"


echo "Attempting to tar $src"
echo "To directory $dst"
echo "As $(basename $backupfile)"

echo "Creating backup..."
tar -czvf "$backupfile" $src > /dev/null || {
    echo "Backup failed!"
    exit 1
}

if [ $? -eq 0 ]; then
    echo "Backup completed successfully at: $backup_file"
else
    echo "Backup failed!"
fi
