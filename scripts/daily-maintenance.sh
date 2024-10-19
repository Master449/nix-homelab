#!/run/current-system/sw/bin/bash

# This script collects SMART data into a nice log file
# of all drives that are under /dev/sd*

drives=$(lsblk --nodeps -n -o name | grep sd)
diskhealthlog="/home/david/diskhealth.log"

# Wipe old file
echo "" > $diskhealthlog

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
	
	# Format power on hours
	smartctl_hours=$(echo "$info" | grep "Power_On_Hours")
	raw_value=$(echo "$smartctl_hours" | awk '{print $NF}')
	formatted_value=$(echo "$raw_value" | sed ':a;s/\B[0-9]\{3\}\>/,&/;ta')
	echo "Hours Online:    " $formatted_value " hours">> $diskhealthlog
	
	echo "$(echo "$info" | grep "SMART overall-health")" >> $diskhealthlog
	echo "$(echo "$info" | grep -A 2 "Current Temperature:")" >> $diskhealthlog
	echo "$(echo "$info" | grep "SMART overall-health")" >> $diskhealthlog
	echo "-------------------------------------------------------------" >> $diskhealthlog
	echo -e "\033[0m" >> $diskhealthlog
	printf "\n" >> $diskhealthlog
done
echo "Last ran on:" `date +"%m/%d/%Y %I:%M %p"` >> $diskhealthlog
