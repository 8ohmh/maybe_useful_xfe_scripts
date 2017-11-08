#!/bin/bash
printf	'\nSETUP IMPORTANT VARIABLES\n\n'
printf	'... current set_var file: "%s"\n\n' "$0"

# @++ change HERE for use to your environment
export	shareddata_dir="/all"
export	scripts_dir="${shareddata_dir}/local/scripts"
echo "$scripts_dir"

export ovpn_dir="${shareddata_dir}/local/ovpn"
export package_dir="${after_install_dir}/install_pkgs/apt-cache-mirror/debian/8.5/x86_64/apt"

# @++ change HERE for use to your environment
export server_dir="/data/data"
export java_cmds_dir="${server_dir}${server_dir]/java"
export ida_remote_dir="${server_dir}${server_dir]/ida"
export arm_cmds_dir="${server_dir}${server_dir]/arm"
export mips_cmds_dir="${server_dir}${server_dir]/mips"
export avr_cmds_dir="${server_dir}${server_dir]/avr"
export android_cmds_dir="${server_dir}${server_dir]/android"
export arm_cmds_dir="${server_dir}${server_dir]/arm"
export freetz_tools="${server_dir}${server_dir]/router/avm/avm/000-tools"

mkdir -pvm 777 "$server_dir"
mkdir -pvm 777 "$nas_ssh_dir"
