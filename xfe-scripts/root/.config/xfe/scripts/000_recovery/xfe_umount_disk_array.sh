#!/bin/bash
#xfe_config_dir="${HOME}/.config/xfe"
#export mount_sfp_01="/root/.config/xfe/scripts/.ext_scripts/mount_partition_image.sh"
#export mount_base="/media"

# zenity --info --text="USE '${mount_sfp_01}'"

for arg; do
	do_in_xfe() {
		t_arg="$0"
		#mdadm --fail "$md_dev"
		#mdadm --stop "$md_dev"
		#mdadm --remove "$md_dev"
		t_result="$(umount -Rd "$t_arg" 3>&1 2>&1 )"
		zenity --info --text="$t_result"
	}

	export -f do_in_xfe
	xfce4-terminal \
		-H \
		-e "'/bin/bash' -c 'do_in_xfe' '$arg'"
done



