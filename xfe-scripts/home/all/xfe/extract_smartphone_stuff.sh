#!/bin/bash
now_date_YYMMDD=$(date +"%Y%m%d")
now_date=$(date +"%Y%m%d%H%M%S")
flag_reset_data="n"

smartphone_mount_path="/smartphone"
smartphone_result_path="/nas-ssh/Private/smartphone/000-results/${now_date_YYMMDD}"
#smartphone_result_path="/smartphone_result_path/000-results/${now_date_YYMMDD}"
mkdir -pm 777 "$smartphone_result_path"
found_executables=""
dex_2_jar=""
odex_2_jar=""

#TODO dialog

cat > "${smartphone_result_path}/temp_disasm_script.sh" << EOF
#!/bin/bash
now_date_YYMMDD=$(date +"%Y%m%d")
now_date=$(date +"%Y%m%d%H%M%S")
filepath="\$1"
destdir="\$2"
filename="\$(basename "\$filepath")"
destpath="\${destdir}/\${filename}"
if [ "${flag_reset_data}" == "y" ]; then
	rm -rfv "\${destpath}"
fi
echo	"filename: \${filename}"
/bin/bash \$scripts_dir/disasm.sh "\$filepath" "\${destpath}"
EOF
disasm_script_path="${smartphone_result_path}/temp_disasm_script.sh"

cat > "${smartphone_result_path}/temp_deapk_script.sh" << EOF
#!/bin/bash
now_date_YYMMDD=$(date +"%Y%m%d")
now_date=$(date +"%Y%m%d%H%M%S")
filepath="\$1"
destdir="\$2"
filename="\$(basename "\$filepath")"
destpath="\${destdir}/\${filename}_apk"
if [ "${flag_reset_data}" == "y" ]; then
	rm -rfv "\${destpath}"
fi
echo	"filename: \${filename}"
unzip -d "$destpath" "$filepath"
#dex to jar
EOF

deapk_script_path="${smartphone_result_path}/temp_deapk_script.sh" #TODO

chmod 755 "${deapk_script_path}"
chmod 755 "${disasm_script_path}"

pattern="*"
printf "\n... executables:\n\n"
find \
	"$smartphone_mount_path" \
	-iname "$pattern" \
	-type f \
	-executable \
	-exec "${disasm_script_path}" \
		{} \
		"${smartphone_result_path}" \;
#	tee "${smartphone_result_path}/list_exe_bins.txt"

printf "\n... modules:\n\n"
pattern="*.so"
#find \
	#"$smartphone_mount_path" \
	#-iname "$pattern" \
	#-type f \
	-exec "${smartphone_result_path}/temp_script.sh" {} ${smartphone_result_path} \;

printf "\n... encryption:\n\n"
iregex_pattern=".*\.\(ssl\|ssh\|encr\|\).*"

printf "\n... wifi/vpn/bluetooth:\n\n"
iregex_pattern=".*\.\(ssl\|ssh\|encr\|gpg\).*"

printf "\n... javascript:\n\n"

printf "\n... apk:\n\n"
iregex_pattern=".*\.\(apk\|dex\)"
find \
	"$smartphone_mount_path" \
	-iregex "$iregex_pattern" \
	-type f \
	-exec "${deapk_script_path}" \
		{} \
		"${smartphone_result_path}" \;
