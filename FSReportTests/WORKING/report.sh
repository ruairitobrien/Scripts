#!/bin/bash

# Autho: Ruairí O Brien
# 08/02/2013
# Script to iterate through all dtl files in the DTL_FILE_DIR and create seperate reports for each config file in the CONFIGS_DIR
# The reports will be stored in the REPORTS_DIR in the format REPORTS_DIR/DTL_FILE_NAME/CONFIG_FILE_NAME

DTL_FILE_DIR=dtl_files
CONFIGS_DIR=configs
REPORTS_DIR=reports
FS_REPORT_APP=fsReport


# User should be sudo
if [[ $UID != 0 ]]; then
    echo "Please run this script with sudo:"
    echo "sudo $0 $*"
    exit 1
fi

# Compile fsReport code and move the executable to the root test folder.
function CompileAndCopyFSReport {
	if [ -f $REPORTS_DIR$/FS_REPORT_APP ]; then
		rm $REPORTS_DIR/$FS_REPORT_APP;
	fi

	# Compile fsReportLinux
	echo "Compiling fsReport...";
	pushd ./ff-5/src/fsReportLinux;
	make clean;
	make; 

	popd;
	echo "Compilation complete";
	cp ./ff-5/src/fsReportLinux/$FS_REPORT_APP $REPORTS_DIR;
	chmod 777 $REPORTS_DIR/$FS_REPORT_APP;
}

# Iterate through all DTL files in the dtl_files folder and call GenerateReports to create reports based on the current DTL file.
function IterateDTLFiles {
echo "Iterating through dtl files";

for f in $DTL_FILE_DIR/*
do
GenerateReports ${f##*/}
done

echo "Finished iterating through dtl files";
}

# Iterate through all configurations in the config dir and call CreateAndStoreReport passing the DTL file and current Config file.
function GenerateReports {
echo "Starting report generation for $1";

for f in $CONFIGS_DIR/*
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

if [ -f $REPORTS_DIR/$FS_REPORT_APP ]
then
    chmod 777 $REPORTS_DIR/$FS_REPORT_APP;

	echo "Creating report on $2 using $1";
	./$REPORTS_DIR/$FS_REPORT_APP -dtl "$DTL_FILE_DIR/$2" -cfg "$CONFIGS_DIR/$1" -rdir $REPORTS_DIR/$2/$1;
else
	echo "An error has occured. Please ensure that $FS_REPORT_APP exists in the reports directory.";
fi

}

# Allow this script to prep any required folders.
function CreateFolders {
if [ ! -d "$REPORTS_DIR" ]; then 
	mkdir "$REPORTS_DIR";
fi

if [ ! -d "$CONFIGS_DIR" ]; then 
	mkdir "$CONFIGS_DIR";
fi

if [ ! -d "$DTL_FILE_DIR" ]; then 
	mkdir "$DTL_FILE_DIR";
fi
}

CompileAndCopyFSReport
CreateFolders
IterateDTLFiles

exit $?
