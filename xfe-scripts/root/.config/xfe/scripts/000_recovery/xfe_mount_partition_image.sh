#!/bin/bash
xfe_config_dir="${HOME}/.config/xfe"

export mount_sfp_01="${xfe_config_dir}/scripts/.ext_scripts/mount_partition_image.sh"
export mount_base="/media"

#zenity \
	#--info \
	#--text="$mount_sfp_01" \
	#--timeout=10
# xfce4-terminal -H -e "less '${mount_sfp_01}'" &
# exit
for arg; do

	#zenity \
		#--info \
		#--text="Mounting:\n\n'$arg'\non\n'$mount_base'" \
		#--timeout=10
	#mkdir -pm 777 "$mount_base"
	#if [ ! -w "${output_dir}" ]; then
		#zenity \
			#--info \
			#--text="$(printf "$fmtstr_err" "Could not create output dir '${output_dir}' - Exit")"
		#exit 1
	#fi
	##zenity --info --text="Using as output dir:\n'${output_dir}'"
	cmd="bash -c \"'$mount_sfp_01' -f '$arg' -m '$mount_base'; bash\""
	zenity \
		--info \
		--text="$cmd" \
		--timeout=10
	xfce4-terminal -H -e "${cmd}"
done
