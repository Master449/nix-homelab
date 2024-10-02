#!/run/current-system/sw/bin/bash

# This script runs backups and outputs log files for each drives
# under /dev/sd*

drives=$(lsblk --nodeps -n -o name | grep sd)
diskhealthlog="/home/david/diskhealth.log"

echo "" > /home/david/diskhealth.log

for disk in $drives; do
	# Grab full drive SMART info
	info=$(smartctl -x /dev/$disk)

	# Print it in its own log file named disk.log
	echo "$info" > /home/david/$disk.log

	#Needed for fun
	status=$(echo "$info" | grep "SMART overall-health")

	# Generate drive summary list log
	if [[ $status == *"PASSED"* ]]; then
		echo -e "\033[0;32m" >> $diskhealthlog
	else
		echo -e "\033[0;31m" >> $diskhealthlog
	fi
	echo "------------------------- /dev/$disk --------------------------" >> $diskhealthlog
	echo "$(echo "$info" | grep -A 2 "Model Family")" >> $diskhealthlog
	echo "$(echo "$info" | grep "SMART overall-health")" >> $diskhealthlog
	echo "$(echo "$info" | grep -A 2 "Current Temperature:")" >> $diskhealthlog
	echo "$(echo "$info" | grep "ID#")" >> $diskhealthlog
	echo "$(echo "$info" | grep "Power_On_Hours")" >> $diskhealthlog
	echo "$(echo "$info" | grep "SMART overall-health")" >> $diskhealthlog
	echo "-------------------------------------------------------------" >> $diskhealthlog
	echo -e "\033[0m" >> $diskhealthlog
	printf "\n" >> $diskhealthlog
done
