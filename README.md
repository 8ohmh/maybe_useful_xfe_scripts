# maybe_useful_xfe_scripts

This GIT repo is containing very basic bash scripts addon for the
Linux XFE Filemanager (like Midnight Commander or EMEL) for easier
reversing issues of binaries (instead of using the shell).

Requirements: bash, Xfe filemanager, Wine, and. IDA free

There is no current Install sripts - so you have to

copy/rsync all files into the root folder, so that

1. e.g. folder "all" is on / and the /root folder of the repository is
copied to /root etc.
2. You have to change manually (sorry) the "set_vars.sh" file in /all to
fit on your environment
3. For some scripts you have to install Wine (!!!) and Hexrays IDA free
An install script is following (as far as I have the time) - as far you
are invited to spend some time for an useful installer script

After that (and after installing XFE) You can use in the Mouse Pop up
menu the menu points for examining, dismantling, disassembling, reversing
binary files just by a click on a file in XFE and by selecting the menu entry



