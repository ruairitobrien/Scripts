#!/bin/bash

# Autho: Ruairí O Brien
# 08/02/2013
# Script to iterate through all dtl files in the DTL_FILE_DIR and create seperate reports for each config file in the CONFIGS_DIR
# The reports will be stored in the REPORTS_DIR in the format REPORTS_DIR/DTL_FILE_NAME/CONFIG_FILE_NAME

# User should be sudo
if [[ $UID != 0 ]]; then
    echo "Please run this script with sudo:"
    echo "sudo $0 $*"
    exit 1
fi

source "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"/definitions.sh



# Compile fsReport code and move the executable to the root test folder.
function CompileAndCopyFSReport {
	if [ -f $FSREPORT_APP ]; then
		rm $FSREPORT_APP;
	fi

	# Compile fsReportLinux
	echo "Compiling fsReport...";
	pushd $CODE_DIR/src/fsReportLinux;
	make clean;
	make; 

	popd;
	echo "Compilation complete";
	cp $CODE_DIR/src/fsReportLinux/fsReport $FSREPORT_APP;
	chmod 777 $FSREPORT_APP;

	if [ -f "$FSREPORT_APP" ]; 
		then

		echo "fsReport file copied to working dir";
	
		else
		
		echo "Error! fsReport file was not copied to working directory";
		exit 1;
	fi
}

# Iterate through all DTL files in the dtl_files folder and call GenerateReports to create reports based on the current DTL file.
function IterateDTLFiles {
echo "Iterating through dtl files";

# Look for DTL files placed in the DTL inputs folder
for f in $DTL_FILE_INPUT_DIR/*
do
GenerateReports ${f##*/}
done

echo "Finished iterating through dtl files";
}

# Iterate through all configurations in the config dir and call CreateAndStoreReport passing the DTL file and current Config file.
function GenerateReports {
echo "Starting report generation for $1";

for f in $REPORT_CONFIGS_DIR/*
do
CreateAndStoreReport ${f##*/} $1
done

echo "Finished generating reports";
}

# Create a report from a DTL file using a Config file and store it in the reports directory.
function CreateAndStoreReport {

if [ -d $REPORTS_DIR/$2/$1 ]; then
	# Get rid of any old reports based on the same DTL file and Configuration
	rm -rf "$REPORTS_DIR/$2/$1";
fi
# Make the folder to store the new report
mkdir -p "$REPORTS_DIR/$2/$1";

if [ -f $FSREPORT_APP ]
then
    chmod 777 $FSREPORT_APP;

	echo "Creating report on $2 using $1";
	$FSREPORT_APP -dtl "$DTL_FILE_INPUT_DIR/$2" -cfg "$REPORT_CONFIGS_DIR/$1" -rdir $REPORTS_DIR/$2/$1;
else
	echo "An error has occured. Please ensure that $FSREPORT_APP exists in the working directory.";
fi

}

# Allow this script to prep any required folders.
function CreateFolders {
if [ ! -d "$REPORTS_DIR" ]; then 
	mkdir -p "$REPORTS_DIR";
fi

if [ ! -d "$REPORT_CONFIGS_DIR" ]; then 
	mkdir -p "$REPORT_CONFIGS_DIR";
fi

if [ ! -d "$DTL_FILE_INPUT_DIR" ]; then 
	mkdir -p "$DTL_FILE_INPUT_DIR";
fi
}

CompileAndCopyFSReport
CreateFolders
IterateDTLFiles
chmod 777 -R $REPORTS_DIR

exit $?
