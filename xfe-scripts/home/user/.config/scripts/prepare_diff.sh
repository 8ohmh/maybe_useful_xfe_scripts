#!/bin/sh

export
for arg 
	do
	/usr/bin/python  "/home/user/.config/xfe/scripts/prepare_diff.py" "${arg}"
	done	
