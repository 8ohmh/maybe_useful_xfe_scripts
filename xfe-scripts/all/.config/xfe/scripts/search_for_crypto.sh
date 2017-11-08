#!/bin/bash
dirs=(/*)
sdirs="$(echo ${dirs[@]} | grep -Ei "^(dev|sys|proc)")"
echo	${dirs[@]}
echo $sdirs
find_regex=".*\(crypt\|ssh\|ssl\|rsa\|)+.*"
