#!/bin/bash
shopt -s extglob
now_date=$(date +"%Y%m%d%H%M%S")
for arg
	do
	td_command="testdisk '${arg}'"
	xfce4-terminal "$td_command"
	done
