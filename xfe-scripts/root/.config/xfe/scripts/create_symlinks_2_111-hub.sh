#!/bin/sh
export default_shareddata_dir="/shareddata_b"
if [ -z "${shareddata_dir}" ]
then
	export shareddata_dir="$default_shareddata_dir"
fi

export symlinks_dir="/111-hub/"

if [ ! -d "$symlinks_dir" ]
then
	mkdir -pv -m 777 "$symlinks_dir"
fi

symlink_path="${symlinks_dir}/$(basename "${arg}")"
for arg
do
	ln -s "$arg" "$symlink_path"
done
