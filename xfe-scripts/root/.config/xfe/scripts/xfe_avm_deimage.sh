#!/bin/bash
now_date="$(date +"%Y%m%d%H%M%S")"
file_path="${1//\"\'\;}"
dest_path="${2//\"\'\;}"
if [ -z "$file_path" ]; then
	printf "ERROR: No firmware given!\n\n"
	exit
fi

filename="$(basename "$file_path")"
firmware_company="avm"

printf "UNPACKING FIRMWARE IMAGE\n\n"
printf '... type: "%s"\n\n' "$firmware_company"
dest_path="${1:-${HOME}/avm_image/${filename}/${now_date}}"
printf	"$dest_path"
mkdir -pm 777 "$dest_path"
