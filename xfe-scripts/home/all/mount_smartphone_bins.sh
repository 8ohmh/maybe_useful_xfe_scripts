#!/bin/bash
bin_path="$1"
echo "${1%%.*}"
bin_filename="$(basename "${bin_path}")"
echo "$bin_filename"
exit
bin_dirname="$(dirname "${bin_path}")"
now_date_YYMMDD=$(date +"%Y%m%d")
now_date=$(date +"%Y%m%d%H%M%S")
config_dir="${HOME}/.config/smartphone"
mount_path="${workdir_path}/mount"
mkdir -pm 755 "${config_dir}"
mkdir -pm 777 "$workdir_path"

if [ ! -d "/home/workdir" ]; then
	workdir_path="/home/workdir/smartphone/${bin_filename}_${now_date_YYMMDD}"
else
	workdir_path=""
fi

printf	'\n\nMOUNTING PARTITION IMAGE: \n"%s"\n\n' "$bin_path"

if [ -z "$bin_path" ] || [ ! -f "$bin_path" ]; then
	printf "ERROR: No partition image given!\n\n"
	exit
fi

if [ ! -f "${config_dir}/current_loop_dev.txt" ]; then
	echo 6 > "${config_dir}/current_loop_dev.txt"
fi

current_loop_dev="$(cat "${config_dir}/current_loop_dev.txt")"
current_md_dev="$(cat "${config_dir}/current_md_dev.txt")"
loop_dev="/dev/loop${current_loop_dev}"

losetup -d "$loop_dev"
losetup \
	"$loop_dev" \
	"${bin_path}"

mkdir -pm 777 "$mount_path"
mount ${loop_dev} "$mount_path"
printf 	'... binary mounted at "%s":\n\n' "$mount_path"

#TODO Test whether whole partition or not

## arg= /nas-ssh/Private/large_files/memcpy.bin
#mdadm --fail "$md_dev"
#mdadm --stop "$md_dev"
#mdadm --remove "$md_dev"
#mdadm --build --level=0 --force --raid-devices=1 "$md_dev" "$loop_dev"
## xfce4-terminal -e "ls -A1 '${md_dev}'" &
#md_devs="$(ls -A1 "${md_dev}")"
#disk_parts="$(disktype ${md_dev})"
## printf "%s\n\n" "$disk_parts" | grep -i "Partition Name"
#name_disk_parts="$(printf "%s\n\n" "$disk_parts" | \
	#grep -i "Partition Name" | \
	#grep -i -o '".*"' | tr -d '"' )"
#while IFS='' read -r line || [[ -n "$line" ]]; do
	#printf "%s\n\n" "$line"
	#mkdir -pm 777 "${workdir_path}/${line}"
#done <<< "$name_disk_parts"
