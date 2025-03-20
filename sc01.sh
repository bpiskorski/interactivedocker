#!/bin/bash

memory=$(whiptail  --inputbox "enter how much memory you want to alocate for a container" 10 70 --title "Memory" 3>&1 1>&2 2>&3)
cpu=$(whiptail --inputbox "How many cores" 10 70 1 --title "CPU" 3>&1 1>&2 2>&3)

removable=""

if whiptail --title "autoremove" --yesno "remove after use?" 10 70; then
	echo "Container will get removed after use"
	removable="--rm"
else
	echo "container will persist"
fi

echo "$memory $cpu $removable" 

echo docker run -m "$memory" --cpus "$cpu" "$removable" ubuntu:latest bash
docker run -m "memory" --cpus "cpu" "$removable" ubuntu:latest bash
