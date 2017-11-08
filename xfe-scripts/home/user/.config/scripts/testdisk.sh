#!/bin/bash
shopt -s extglob
now_date_YYMMDD=$(date +"%Y%m%d")
now_date=$(date +"%Y%m%d%H%M%S")
for arg; do
	wd="$(pwd)"
	td_file_dir="$(dirname "${arg}")"
	td_filename="$(basename -sa "${arg}")"
	td_work_dir="${wd}/000-testdisk/${td_filename}_${now_date_YYMMDD}/${now_date}"
	mkdir -pm 777 "${td_work_dir}"
	cd "$td_work_dir"
	td_command="testdisk /log '${arg}'"
	xfce4-terminal -e "$td_command"
done
