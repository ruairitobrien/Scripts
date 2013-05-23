#!/bin/ksh

# Author: Ruairi O Brien
# 19-Marh-2013
# Initializes the HP-UX Korn shell paths for installed software.
# Need to run as root.

PATH=$PATH:/usr/local/bin:/usr/local/bin/X11;
export PATH;
MANPATH=$MANPATH:/usr/local/man;
export MANPATH;
XFILESEARCHPATH=/usr/lib/X11/app-defaults/%N:/usr/local/lib/X11/app-defaults/%N;
export XFILESEARCHPATH;
INFOPATH=$INFOPATH:/usr/local/info;
export INFOPATH;
