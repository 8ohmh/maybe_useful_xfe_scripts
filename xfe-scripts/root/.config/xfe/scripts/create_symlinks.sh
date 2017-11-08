#!/bin/sh
default_shareddata_dir="/shareddata_b"
if [ -z "${shareddata_dir}" ]
then
	shareddata_dir="$default_shareddata_dir"
fi
symlinks_dir="${shareddata_dir}/symlinks"

if [ ! -d "$symlinks_dir" ]
then
	mkdir -pv -m 777 "$symlinks_dir"
fi
for arg
do
	ln -sf "$arg" "${symlinks_dir}/$(basename "${arg}")"
done
