#!/bin/bash

# Autho: Ruairí O Brien
# 08/02/2013
# Scipt to create some test directories and run an fsscan against them. The fsscan executable should be in the same directory as this script 
# unless the scipt is edited to point to a different location when searching for the fsscan applicaiton.

# User should be sudo
if [[ $UID != 0 ]]; then
    echo "Please run this script with sudo:"
    echo "sudo $0 $*"
    exit 1
fi


# Get Parameters
JIRA_NUMBER=$1
echo $JIRA_NUMBER

# Variables
OUTPUT_FOLDER=output
ROOT_TEST_SCAN_LOCATION=FSMA_TARGET_SCAN_FOLDER
TEST_FILES_DIR=test_files
DTL_FILE_DIR=dtl_files
DTL_FILE=$OUTPUT_FOLDER/$DTL_FILE_DIR/fsScan
SCAN_TAG=FSMA_RPT
FSSCAN_APP=fsscan
TEST_FILES_DIR=test_files




function RunScan {
	if [ ! -d "$DTL_FILE_DIR" ]; then
		mkdir "$DTL_FILE_DIR";
	fi
	if [ -f ./$FSSCAN_APP ];
	then
    		chmod +x ./$FSSCAN_APP;
	
		./$FSSCAN_APP "$ROOT_TEST_SCAN_LOCATION" -dtl $DTL_FILE -tag $SCAN_TAG;
	else
		echo "An eror has occured. Please ensure that $FSSCAN_APP exists in the same directory as this script.";
	fi
}

RunScan

exit $?
