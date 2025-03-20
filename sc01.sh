#!/bin/bash

memory=0
#check if value is greater than minimal required container memory
while true
do	
	memory=$(whiptail  --inputbox "enter how much memory you want to alocate for a container" 10 70 --title "Memory" 3>&1 1>&2 2>&3)
	if [ $memory -gt 5 ]
	then
		break
	fi
done

#ask user how many cores to use for a container 
cpu=$(whiptail --inputbox "How many cores" 10 70 1 --title "CPU" 3>&1 1>&2 2>&3)

removable=""
if whiptail --title "autoremove" --yesno "remove after use?" 10 70; then
	echo "Container will get removed after use"
	#assign --rm flag to variable if yes
	removable="--rm"
else
	echo "container will persist"
fi
#updating the image
if whiptail --title "Update" --yesno "Would u like to update ubuntu image" 10 70; then
	echo "updating"
	docker pull ubuntu:latest
fi
#timeout
#extracting container ids itno array
#container_id=$(docker ps -q | head -n 1)

timeframe=$(whiptail --inputbox "Remove all stopped containers older than <input> hours" 10 70 --title "Container remover" 3>&1 1>&2 2>&3)

containers=($(docker ps -aq -f "status=exited"))

for container in "${containers[@]}"; do
	exited=$(docker inspect -f '{{ .State.FinishedAt}}' "$container")
	seconds=$(date --date="$exited" +%s)
	seconds_now=$(date +%s)
	elapsed=$((seconds_now - seconds))
	hours=$((elapsed / 3600))
	if [ $hours -ge $timeframe ]; then
		echo "removing container: $container"
		docker rm "$container"

	fi
done


#test to see if command is correct 
echo docker run -m "$memory" --cpus "$cpu" "$removable" ubuntu:latest bash
docker run -it -m "$memory""mb" --cpus "$cpu" "$removable" ubuntu:latest bash
