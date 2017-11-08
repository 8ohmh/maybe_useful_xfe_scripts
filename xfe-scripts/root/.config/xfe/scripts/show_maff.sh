#!/bin/sh
#html_viewer="iceweasel"
html_viewer="/111-hub/tor/tor-browser_en-US/start-tor-browser.desktop"
now_date="$(date +"%Y%m%d%H%M%S")"
c_wd=""
for arg 
	do
	maff_file="${arg}"
	maff_filename="$(basename "${maff_file}")"
	zip_dir="/temp/${maff_filename}-${now_date}"
	echo	"$zip_dir"
	mkdir -pv -m 777 "${zip_dir}"
	unzip "$maff_file" -d "${zip_dir}"
	chmod 777 -R "${zip_dir}"
	#TODO!!!
	index_file="$(find "${zip_dir}" -iname "index.html")"
	echo	"$index_file"
	"$html_viewer" "file://${index_file}"
	rm -rfv "${zip_dir}"
	done	


