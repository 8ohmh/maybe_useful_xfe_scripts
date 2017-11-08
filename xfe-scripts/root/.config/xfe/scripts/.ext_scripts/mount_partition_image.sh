#!/bin/bash
# name		"md_mount_script.sh"
# purpose	"Tool for use in XFE filemanager to mount "
#			"an partition image"
# by 8ohmh
#

partition_image_path="${1//\"\'\;}"
base_mount_path="${2//\"\'\;}"
#partition_image_path="${1//\\"\\'\\;}"
now_date_YYMMDD="$(date +"%Y%m%d")"
now_date="$(date +"%Y%m%d%H%M%S")"
config_dir="${HOME}/.config/mount_partition_image" #TODO

bin_dirname="$(dirname "${partition_image_path}")"
bin_filename="$(basename "${partition_image_path}")"

if [[ -z "$base_mount_path" ]] || [[ ! -d "$base_mount_path" ]]; then
	base_mount_path="/media/${bin_filename}"
fi

mkdir -pvm 777 "${base_mount_path}"
mkdir -pm 755 "${config_dir}"

# IF NO START LOOP & RAID DEVICE NUMBERS,
# SET DEFAULT NUMBERS
if [ ! -f "${config_dir}/current_loop_dev.txt" ]; then
	echo 10 > "${config_dir}/current_loop_dev.txt"
fi

if [ ! -f "${config_dir}/current_md_dev.txt" ]; then
	echo 10 > "${config_dir}/current_md_dev.txt"
fi

# OTHERWISE GET CURRENT LOOP & RAID DEVICE NUMBERS
current_loop_dev="$(cat "${config_dir}/current_loop_dev.txt")"
current_md_dev="$(cat "${config_dir}/current_md_dev.txt")"
loop_dev="/dev/loop${current_loop_dev}"
md_dev="/dev/md/md${current_md_dev}" #TODO
#mkdir "$md_dev"

# NOW SETUP LOOP DEVICE
losetup -d "$loop_dev"
losetup "$loop_dev" "${partition_image_path}"

# NOW SETUP RAID DEVICE
if [ -d "$md_dev" ]; then
	mdadm --fail "$md_dev"
	mdadm --remove "$md_dev"
	mdadm --stop "$md_dev"
fi
# hexdump -C "$loop_dev"
echo	"$md_dev"

mdadm \
	--build \
	--level=0 \
	--force \
	--raid-devices=1 \
	${md_dev} \
	${loop_dev}

sleep 1
# GET PARTTIONS OF IMAGE
files=(${md_dev}p*)
printf	'... found partitions:\n\n"%s"\n\n' "${files[@]}"
disk_parts="$(disktype "${md_dev}")"
printf	'... details:\n\n"%s"\n\n' "${disk_parts}"

#name_disk_parts="$(printf "%s\n\n" "$disk_parts" \
	#| grep -i "Partition Name" \
	#| grep -i -o '".*"' | tr -d '"' )"

#if [ ! -z "${fi
for arg in ${files[@]}; do
	disktype "$arg"
	name_disk_part="$(disktype "$arg" | grep -i "mounted at" | grep -i -o '".*"' | tr -d '"' )"
	printf '... partition name: "%s"\n\n' "$name_disk_part"
	abasename="$(basename "$arg")"
	#echo	"basename $abasename"
	if [ -z "$name_disk_part" ]; then
		mount_path="${base_mount_path}/${abasename}__noname"
	else
		mount_path="${base_mount_path}/${abasename}__${name_disk_parts}"
	fi
	printf 'mount path: "%s"\n\n'	"$mount_path"
	mkdir -pm 777 "${mount_path}"
	mount "$arg" "${mount_path}"
done
bash
#printf "Partiton name %s\n\n" "$disk_parts" | grep -i "Partition Name"

