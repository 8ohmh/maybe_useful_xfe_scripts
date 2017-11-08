for arg
do
	md5sum "$arg" > "$arg.md5"
done
