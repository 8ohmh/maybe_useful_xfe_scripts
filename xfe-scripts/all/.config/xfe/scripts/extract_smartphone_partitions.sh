#!/bin/bash
#TODO Dialog
#TODO check for commands
bin_file="/nas-ssh/Private/large_files/mmcblk0"
#bin_file="$1"
file_size(){
	if [ ! -f "$1" ]; then
		return "0"
	fi
	(
	du --apparent-size --block-size=1 "$1" 2>/dev/null ||
	gdu --apparent-size --block-size=1 "$1" 2>/dev/null ||
	find "$1" -printf "%s" 2>/dev/null ||
	gfind "$1" -printf "%s" 2>/dev/null ||
	stat --printf="%s" "$1" 2>/dev/null ||
	stat -f%z "$1" 2>/dev/null ||
	wc -c <"$1" 2>/dev/null
	) | awk '{print $1}'
}

max_md_subdevs=32
flag_do_mount="y"
flag_do_ddrescue="y"
now_date_YYMMDD=$(date +"%Y%m%d")
now_date=$(date +"%Y%m%d%H%M%S")
config_dir="${HOME}/.config/smartphone"
mount_point_path="/smartphone"
last_bin_file="$(cat "${config_dir}/last_bin_file.txt")"

printf "EXTRACTING SMARTPHONE/OTHER IMAGE \"%s\"\n\n" \
	"$bin_file"

mkdir -pm 755 "${config_dir}"
if [ -z "$bin_file" ]; then
	bin_file="$last_bin_file"
	echo "$bin_file" > "${config_dir}/last_bin_file.txt"
fi

if [ -z "$bin_file" ]; then
	echo "ERROR: No bin file given"
	return
else
	echo "$bin_file" > "${config_dir}/last_bin_file.txt"
fi

bin_dirname="$(dirname "${bin_file}")"
bin_filename="$(basename "${bin_file}")"
workdir_path="/nas-ssh/Private/smartphone/${bin_filename}_${now_date_YYMMDD}"
printf "... workdir path: \"%s\"\n\n" \
	"$workdir_path"
# workdir_path="${HOME}/smartphone/${bin_filename}_${now_date_YYMMDD}"
mkdir -pm 777 "$workdir_path"
if [ ! -d "$workdir_path" ]; then
	echo "ERROR: Could not create workdir path!"
	return -1
fi

if [ ! -f "${config_dir}/current_loop_dev.txt" ]; then
	echo 6 > "${config_dir}/current_loop_dev.txt"
else
	current_loop_dev="$(cat "${config_dir}/current_loop_dev.txt" )"
fi

if [ ! -f "${config_dir}/current_md_dev.txt" ]; then
	echo 6 > "${config_dir}/current_md_dev.txt"
else
	current_md_dev="$(cat "${config_dir}/current_md_dev.txt" )"
fi

current_loop_dev="$(cat "${config_dir}/current_loop_dev.txt")"
current_md_dev="$(cat "${config_dir}/current_md_dev.txt")"
loop_dev="/dev/loop${current_loop_dev}"
md_dev="/dev/md${current_md_dev}" #TODO

printf "... using loop device \"%s\"\n\n" \
	"$loop_dev"
losetup -d "$loop_dev"
losetup "$loop_dev" "${bin_file}"
# mdadm --fail "$md_dev"
mdadm --stop "$md_dev"
mdadm --remove "$md_dev"
sleep 2
printf "... creating md device \"%s\"\n\n" \
	"$md_dev"

mdadm \
	--build \
	--level=0 \
	--force \
	--raid-devices=1 \
	"$md_dev" \
	"$loop_dev"

md_devs="$(ls -A1 ${md_dev}* )" #TODO
printf "... using md-devices:\n\n%s\n\n" \
	"$md_devs"

disk_parts="$(disktype ${md_dev})"

printf "... found disk partitions!\n"
name_disk_parts="$(printf "%s\n\n" "$disk_parts" | \
	grep -i "Partition Name" | \
	grep -i -o '".*"' | tr -d '"' )"

counter=1
while IFS='' read -r line || [[ -n "$line" ]]; do
	curr_sub_mddev_part="md${current_md_dev}p${counter}"
	curr_sub_mddev="/dev/${curr_sub_mddev_part}"
	dest_path="${workdir_path}/${curr_sub_mddev_part}"
	printf \
		'... creating directory "%s" for "%s" and "%s"\n\n' \
		"$dest_path" \
		"$line" \
		"$curr_sub_mddev"
	mkdir 	-pm 777 "$dest_path"
	echo	"$line" > "${dest_path}/${line}"
	umount 	-f "$curr_sub_mddev" 2>/dev/null
	extr_bin_filepath="${dest_path}/md${current_md_dev}p${counter}.bin"
	chmod 777 "$extr_bin_filepath"
	printf	\
		'... extracting partition "%s" to "%s":\n\n' \
		"$curr_sub_mddev" \
		"$extr_bin_filepath"
	size_part=$(blockdev --getsize64 "$curr_sub_mddev")
	the_file_size=$(file_size "${extr_bin_filepath}")
	#echo	"fs ${the_file_size}"
	#echo	"ds ${size_part}"
	if [ $the_file_size -lt $size_part ] \
		|| [ "$flag_do_ddrescue" == "y" ]; then
			printf "... creating backup partition image:\n\n"
			ddrescue \
				"$curr_sub_mddev" \
				"$extr_bin_filepath"
	fi

	mkdir \
		-pm 777 \
		"${dest_path}/md${current_md_dev}p${counter}_content"

	if [ "$flag_do_mount" == "y" ]; then
		mount_point="${mount_point_path}/md${current_md_dev}p${counter}"
		printf	"\nmount \"%s\"\n\n" "$mount_point"
		umount -f "$mount_point_path"  \
			2>/dev/null

		mkdir	\
			-pvm 777 \
			"$mount_point"

		mount \
			-o loop \
			-v \
			"$extr_bin_filepath" \
			"$mount_point"
	fi

	counter="$(expr $counter + 1)"
	if [ "$counter" -ge $max_md_subdevs ]; then
		break
	fi
	printf	"\n\n"
done <<< "$name_disk_parts"
