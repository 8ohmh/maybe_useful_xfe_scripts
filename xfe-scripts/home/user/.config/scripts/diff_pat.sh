#!/bin/sh
export
for arg 
	do
	/usr/bin/python  "/home/user/.config/xfe/scripts/diff_pat.py" "${arg}"
	done	
