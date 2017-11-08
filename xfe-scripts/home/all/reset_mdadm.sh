#!/bin/bash
now_date_YYMMDD=$(date +"%Y%m%d")
now_date=$(date +"%Y%m%d%H%M%S")
config_dir="${HOME}/.config/smartphone"
mount_point_path="/smartphone"
last_bin_file="$(cat "${config_dir}/last_bin_file.txt")"

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
