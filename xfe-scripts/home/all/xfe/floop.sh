#!/bin/sh
loop_bin="$1"
mount_dir="/smartphone"
mount_name="$(basename "$loop_bin")"
mount_path="/${mount_dir}/${mount_name}"
mkdir -pm 777 "/${mount_path}"

mount \
	-o loop \
	"$loop_bin" \
	"$mount_path"
