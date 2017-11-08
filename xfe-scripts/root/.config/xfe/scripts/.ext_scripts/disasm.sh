#!/bin/sh
now_date_YMD=$(date +"%Y%m%d")
now_date_HMS=$(date +"%H%M%S")
now_date=$(date +"%Y%m%d_%H%M%S")
fmtstr_path='\n... %ls:\n\n\t"%ls"\n\n'
fmtstr_msg='\n... %ls\n\n'
fmtstr_err='\n\nERROR: "%ls!!!"\n\n'
term_cmd='xfce4-terminal -H -e "most ''%ls''" -T "%ls" '

file_path="${1//\"\'\;}"
dest_dir="${2//\"\'\;}"
objdump_options="${3//\"\'\;}"
workdir="${HOME}/disasm"
echo $file_path


#export opt_temp="$(getopt -o kdt -- "$@")"
#eval set -- "$opt_temp"
#while true ; do
	#case "$1" in
		#-o) flag_use_own_keys=1 ; shift ;;
		#-d) flag_show_config_dialog=1 ; shift ;;
		#--) shif	t ; break ;;
		#*) echo	 "Internal error!" ; exit 1 ;;
	#esac
#done

printf	'DISASM %ls' "$file_path\n"
if [ -z "$file_path" ]; then
	printf "$fmtstr_err" "Can't find '$file_path'"
	exit
fi

filename="$(basename "$file_path")"

if [[ -z "$dest_dir" ]] \
	|| [[ ! -d "$dest_dir" ]]; then
	dest_dir="${workdir}/${filename}/${now_date}"
fi
printf "$fmtstr_path" "output dir" "$dest_dir"
mkdir -pm 777 "${dest_dir}"

readelf -a "${file_path}" > "${dest_dir}/readelf.txt"

objdump_options="-SwdstzxFhgGw"
objdump ${objdump_options} "${file_path}" > "${dest_dir}/objdump.txt"

nm -al --special-syms --synthetic "${file_path}" > "${dest_dir}/nm.txt"

hexdump -C "${file_path}" > "${dest_dir}/hexdump.txt"

#cat >> "$dest_path" << EOF
## BEGIN ################################################################
#@+ filepath: "${file_path}"

#@+ readelf:
#$(cat "${dest_dir}/readelf.txt")

#@+ objdump:
#$(cat "${dest_dir}/objdump.txt")

#@+nm:
#$(cat "${dest_dir}/nm.txt")

#@+ hexdump:
#$(cat "${dest_dir}/hexdump.txt")
#EOF
#echo >> "${destdir}/readelf.txt"

printf	'ls\t"%ls"\n\n' "${dest_dir}"
cmd="$(printf "$term_cmd" "${dest_dir}/readelf.txt" "${dest_dir}/readelf.txt")"
echo $cmd
eval $cmd &> /dev/null &

cmd="$(printf "$term_cmd" "${dest_dir}/objdump.txt" "${dest_dir}/objdump.txt")"
eval $cmd &> /dev/null &

cmd="$(printf "$term_cmd" "${dest_dir}/nm.txt" "${dest_dir}/nm.txt")"
eval $cmd &> /dev/null

#printf	'less\t"%ls"\n\n' "${dest_dir}"
#bash

# most "$dest_path"
