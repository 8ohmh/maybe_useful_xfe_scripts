#!/bin/bash
android_cmds_path="/nas-ssh/data/data/data-n/data-w/2backup/daten/000-scrypt/smartphone"
dex_2_jar_01_path="${android_cmds_path}/dex2jar-0.0.9.12/"
dex_2_jar_02_path="${android_cmds_path}/dex2jar-2.0/"
d2j_01_cmd=""
unapk_path="${HOME}/do_unapk.sh"
# TODO DIALOG

#if [ ! -f "${unapk_path}" ]; then
cat > "${HOME}/do_unapk.sh" << EOF
#!/bin/bash
# NAME: 	"do_unapk.sh"
# PURPOSE:	"extracts and reverses (so far) and Android APK"
# by 8ohmh
printf "\$1\n\n"
if [ -z "\$arg" ]; then
	if [ -z "\$1"  ]; then
		printf "ERROR: No apk path given!\n\n"
		exit
	else
		arg="\$1"
	fi
fi
for arg; do
	filename="\$(basename "\$arg")"
	now_date_YYMMDD="$(date +"%Y%m%d")"
	now_date=\$(date +"%Y%m%d%H%M%S")
	dest_dir="\${HOME}/smartphone/un-apk/\${filename}/\${now_date}"
	mkdir -pm 777 "\$dest_dir"
	unzip -d "\${dest_dir}" "\$arg"
	if [ -f "\${dest_dir}/classes.dex" ]; then
		echo yes
	fi
done
EOF

#TODO Check for xfce4-terminal
for arg; do
	echo "/bin/bash \"${unapk_path}\" \"$arg\""
	xfce4-terminal -H -e "/bin/bash \"${unapk_path}\" \"$arg\""
done
