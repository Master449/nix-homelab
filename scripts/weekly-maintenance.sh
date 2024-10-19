#!/run/current-system/sw/bin/bash

# This script runs short smart tests on all drives under /dev/sd*

drives=$(lsblk --nodeps -n -o name | grep sd)

for disk in $drives; do
	smartctl -t short /dev/$disk
done
