#!/bin/bash

# Author: Ruairi O Brien
# 15-February-2013
# Script to launch and hide implementation of other scripts used to automate testign of fsUtils

FSMA_JIRA_NUM=192

TEST=$1

echo $TEST

# The current directory of this script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Where any DTL File, Configurations and Src Code should go
INPUTS_DIR=$DIR/INPUTS
# This is the directory where the fsUtils source code should go 
# i.e. the directory src should be directly beneath this one
CODE_DIR=$INPUTS_DIR/code
# This is where configuration files i.e. *.cfg should go.
# Only used for reporting.
CONFIGS_DIR=$INPUTS_DIR/configs
# This is where DTL files that will have reports generated against 
# them should go.
DTL_FILES_DIR=$INPUTS_DIR/dtl_files

# Where any usable outputs from the test scripts will go
OUTPUT_DIR=$DIR/OUTPUTS
# Where generated reports will go
REPORTS_DIR=$OUTPUT_DIR/reports
# Where text fiel outputs for scan tests will go
TEST_OUTPUT_DIR=$OUTPUT_DIR/test_outputs

function SetUpDirectories() {
	mkdir -p $CODE_DIR;
	mkdir -p $CONFIGS_DIR;
	mkdir -p $DTL_FILES_DIR;
	mkdir -p $REPORTS_DIR;
	mkdir -p $TEST_OUTPUT_DIR;
}
 

echo "This script should be modified with values specific to this current test e.g. the FSMA JIRA Number."
echo "Current values: Jira number = $FSMA_JIRA_NUM."

read -p "Would you like to continue?(y/n)"
[ $REPLY == "y" ] || [ $REPLY == "N" ] || exit

# User should be sudo
if [[ $UID != 0 ]]; then
    echo "Please run this script with sudo:"
    echo "sudo $0 $*"
    exit 1
fi


SetUpDirectories

sudo $DIR/WORKING/developer_test.sh $FSMA_JIRA_NUM $CODE_DIR


exit $?
