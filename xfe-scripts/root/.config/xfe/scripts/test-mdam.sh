#!/bin/bash
now_date_YYMMDD=$(date +"%Y%m%d")
now_date=$(date +"%Y%m%d%H%M%S")
loop_dev="/dev/loop6"
md_dev="/dev/md6"
for arg; do
	losetup -d "$loop_dev"
	losetup "$loop_dev" "${arg}"
# arg= /nas-ssh/Private/large_files/memcpy.bin
	mdadm --fail "$md_dev"
	mdadm --stop "$md_dev"
	mdadm --remove "$md_dev"
	mdadm --build --level=0 --force --raid-devices=1 "$md_dev" "$loop_dev"
	xfce4-terminal -e "ls -A1 '$md_dev'"
	md_devs="$(ls -A1 "$md_dev")"
fi
