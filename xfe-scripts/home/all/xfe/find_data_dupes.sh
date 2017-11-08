#!/bin/bash
now_date=$(date +"%Y%m%d%H%M%S")
if [ "$HOSTNAME" == "masternas" ]; then
	base_folder=""
else
	exit
fi

folder="${base_folder}/"

