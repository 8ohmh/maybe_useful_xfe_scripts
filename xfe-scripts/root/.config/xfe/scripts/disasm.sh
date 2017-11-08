#!/bin/sh
# export
set
if [ -z "$scripts_dir" ]; then
	if [ ! -f "${HOME}/.exported-vars.sh" ]; then
		source "${HOME}/.exported-vars.sh"
	else
		export scripts_dir="/shareddata_b/locaL/scripts"
	fi
fi

for arg; do
	bash "${scripts_dir}/disasm.sh" "${arg}"
done
