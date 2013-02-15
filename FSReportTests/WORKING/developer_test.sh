#!/bin/bash -ex

# Author: Ruairí O Brien
# 11/02/2013

# User should be sudo
if [[ $UID != 0 ]]; then
    echo "Please run this script with sudo:"
    echo "sudo $0 $*"
    exit 1
fi

trap 'echo "Something terrible happened. Attempting to clean up the mess...."; CleanUp;' INT TERM EXIT

# Get Parameters
JIRA_NUMBER=$1
CODE_LOCATION=$2
echo $JIRA_NUMBER
echo $CODE_LOCATION

# Variables
OUTPUT_FOLDER=output
ROOT_TEST_SCAN_LOCATION=FSMA_TARGET_SCAN_FOLDER
GENERATED_TEST_FILES=$ROOT_TEST_SCAN_LOCATION/gen
TEST_FILES_DIR=WORKING/test_files
DTL_FILE_DIR=dtl_files
DTL_FILE=$OUTPUT_FOLDER/$DTL_FILE_DIR/fsScan
SCAN_TAG=FSMA_RPT
FSSCAN_APP=fsscan

# Shared folder stuff
NET_LOC_OF_SHARE=//gsshare.isus.emc.com/gssd
MOUNTED_SHARE=/mnt/gsshare
TEST_FILES_LOCATION=tools/FSMA/FSMA_TARGET_SCAN_FOLDER 



# Compile fsScan code and move the executable to the root test folder.
function CompileAndCopyFsScan {
	if [ -f "$FSSCAN_APP" ]; then
		rm $FSSCAN_APP
	fi
	# Compile fsScanLinux
	echo "Compiling fsScan...";
	pushd $CODE_LOCATION/src/fsScanLinuxUnix/fsscan/;
	make clean;
	make;
	popd;
	echo "Compilation complete";
	cp $CODE_LOCATION/src/fsScanLinuxUnix/fsscan/$FSSCAN_APP .;

	if [ -f "$FSSCAN_APP" ]; 
		then

		echo "fsscan file copied to working dir";
	
		else
		
		echo "Error! fsscan file was not copied to working directory";
		exit 1;
	fi
}


# Get test files to run a scan against
function GetTestFiles {
if [ -d "$ROOT_TEST_SCAN_LOCATION" ]; then 
	echo "$ROOT_TEST_SCAN_LOCATION already exists.";
else
	if [ ! -d "$ROOT_TEST_SCAN_LOCATION" ]; then
		mkdir -p $ROOT_TEST_SCAN_LOCATION;
		chmod 777 $ROOT_TEST_SCAN_LOCATION;
	fi
	if grep -q "[[:space:]]$MOUNTED_SHARE[[:space:]]" /proc/mounts; then
		echo "GSSD Shard already mounted.";
	else
		MountShared
		chmod 777 $MOUNTED_SHARE;
	fi
	
	cp -r $MOUNTED_SHARE/$TEST_FILES_LOCATION $ROOT_TEST_SCAN_LOCATION;	
fi

echo "Finished getting test files.";
}

# Mouunt the GSSD Shared folder to allow access and retrieve test data.
function MountShared {
	mkdir -p $MOUNTED_SHARE;
	sudo mount -t cifs $NET_LOC_OF_SHARE  $MOUNTED_SHARE -o username=gsshare,password=pwDgs\$hAr3,domain=gssd;	
}

# Create some test file types i.e. symbolic links, hard links, empty directories and files.
function CreateTestFiles {
	mkdir -p $GENERATED_TEST_FILES
	cp -r $TEST_FILES_DIR/* $GENERATED_TEST_FILES;

	ln $GENERATED_TEST_FILES/Pictures/Desert.jpg $GENERATED_TEST_FILES/Pic2/A.jpg;
	ln -s $GENERATED_TEST_FILES/Pictures/Jellyfish.jpg $GENERATED_TEST_FILES/Pic2/B.jpg ;
	ln $GENERATED_TEST_FILES/Pictures/Lighthouse.jpg $GENERATED_TEST_FILES/Pic2/C.jpg ;
	ln $GENERATED_TEST_FILES/Pictures/Desert.jpg $GENERATED_TEST_FILES/Pic2/D.jpg;
	ln -s $GENERATED_TEST_FILES/Pictures/Lighthouse.jpg $GENERATED_TEST_FILES/Pic2/E.jpg;

	ln -s $GENERATED_TEST_FILES/Pictures $GENERATED_TEST_FILES/Junctions/Pic_Sym;
	ln -s $GENERATED_TEST_FILES/Texts $GENERATED_TEST_FILES/Junctions/Texts_Junc;
	ln -s $GENERATED_TEST_FILES/Pic2 $GENERATED_TEST_FILES/Junctions/Pic2_Junc;
	mkdir $GENERATED_TEST_FILES/fsReportTest2;

	cp -r $TEST_FILES_DIR/* $GENERATED_TEST_FILES/fsReportTest2;

	ln $GENERATED_TEST_FILES/fsReportTest2/Pictures/Desert.jpg $GENERATED_TEST_FILES/fsReportTest2/Pic2/A.jpg;
	ln -s $GENERATED_TEST_FILES/fsReportTest2/Pictures/Jellyfish.jpg $GENERATED_TEST_FILES/fsReportTest2/Pic2/B.jpg;
	ln $GENERATED_TEST_FILES/fsReportTest2/Pictures/Lighthouse.jpg $GENERATED_TEST_FILES/fsReportTest2/Pic2/C.jpg;
	ln $GENERATED_TEST_FILES/fsReportTest2/Pictures/Desert.jpg $GENERATED_TEST_FILES/fsReportTest2/Pic2/D.jpg;
	ln -s $GENERATED_TEST_FILES/fsReportTest2/Pictures/Lighthouse.jpg $GENERATED_TEST_FILES/fsReportTest2/Pic2/E.jpg;

	ln -s $GENERATED_TEST_FILES/fsReportTest2/Pictures $GENERATED_TEST_FILES/fsReportTest2/Junctions/Pic_Sym;
	ln -s $GENERATED_TEST_FILES/fsReportTest2/Texts $GENERATED_TEST_FILES/fsReportTest2/Junctions/Texts_Junc;

	mkdir $GENERATED_TEST_FILES/fsReportTest2/Pic3;
	cp $GENERATED_TEST_FILES/fsReportTest2/Pictures/Desert.jpg $GENERATED_TEST_FILES/fsReportTest2/Pic3/B.jpg;
	ln -s $GENERATED_TEST_FILES/fsReportTest2/Pictures $GENERATED_TEST_FILES/fsReportTest2/Pic3/Pic_Sym;
	ln $GENERATED_TEST_FILES/fsReportTest2/Pictures/Lighthouse.jpg $GENERATED_TEST_FILES/fsReportTest2/Pic3/C.jpg;
	ln $GENERATED_TEST_FILES/fsReportTest2/Pictures/Lighthouse.jpg $GENERATED_TEST_FILES/fsReportTest2/Pic3/D.jpg;
	mkdir "$GENERATED_TEST_FILES/empty1";
	mkdir "$GENERATED_TEST_FILES/empty2";

echo "Finished ceating test files.";
}

# Delete all test data. Unmount shared drive. 
function CleanUp {
	rm -rf $GENERATED_TEST_FILES;
}

# Checks the fsScan application can be run. Creates an output folder for DTTL files. Runs multiple scans based
# on how the RunMultipleScansWithFlags function is implemented.
function RunScans {
	
	if [ -f ./$FSSCAN_APP ];
	then
    		chmod +x ./$FSSCAN_APP;
		if [ ! -d "$OUTPUT_FOLDER" ]; then
			mkdir $OUTPUT_FOLDER;
			chmod 777 $OUTPUT_FOLDER;
		fi
		if [ -d "$OUTPUT_FOLDER/$DTL_FILE_DIR" ]; then
			rm -rf "$OUTPUT_FOLDER/$DTL_FILE_DIR"; 	
		fi
		mkdir "$OUTPUT_FOLDER/$DTL_FILE_DIR";
		chmod 777 $OUTPUT_FOLDER;
		RunMultipleScansWithFlags	
	else
		echo "An eror has occured. Please ensure that $FSSCAN_APP exists in the same directory as this script.";
	fi

}

# Run a series of scans, output to a folder and zip that folder up.
function RunMultipleScansWithFlags {
	echo "Starting first test scan";
	echo "Test";
	echo "$ROOT_TEST_SCAN_LOCATION -dtl ${DTL_FILE}_test1.dtl -tag $SCAN_TAG > $OUTPUT_FOLDER/JIRA_FSMA-${JIRA_NUMBER}_TEST_1_FSSCAN_OUTPUT.txt";
		
	./$FSSCAN_APP "$ROOT_TEST_SCAN_LOCATION" -dtl "${DTL_FILE}_test1.dtl" -tag "$SCAN_TAG" > "$OUTPUT_FOLDER/JIRA_FSMA-${JIRA_NUMBER}_TEST_1_FSSCAN_OUTPUT.txt";

	echo "Starting second test scan";
	./$FSSCAN_APP -cfg "test3.cfg" -dtl "${DTL_FILE}_test3.dtl" -tag "$SCAN_TAG" > "$OUTPUT_FOLDER/JIRA_FSMA-${JIRA_NUMBER}_TEST_3_FSSCAN_OUTPUT.txt";

	echo "Starting third test scan";
	./$FSSCAN_APP -cfg "test4.cfg" -dtl "${DTL_FILE}_test4.dtl" -tag "$SCAN_TAG" > "$OUTPUT_FOLDER/JIRA_FSMA-${JIRA_NUMBER}_TEST_4_FSSCAN_OUTPUT.txt";

	echo "Starting fourth test scan";
	./$FSSCAN_APP -cfg "test5.cfg" -dtl "${DTL_FILE}_test5.dtl" -tag "$SCAN_TAG" > "$OUTPUT_FOLDER/JIRA_FSMA-${JIRA_NUMBER}_TEST_5_FSSCAN_OUTPUT.txt";

	CreateTestFiles

	echo "Starting sixth test scan";
	./$FSSCAN_APP "$ROOT_TEST_SCAN_LOCATION" -dtl "${DTL_FILE}_test2.dtl" -tag "$SCAN_TAG" > "$OUTPUT_FOLDER/JIRA_FSMA-${JIRA_NUMBER}_TEST_2_FSSCAN_OUTPUT.txt";

	zip -r $OUTPUT_FOLDER/JIRA_FSMA-${JIRA_NUMBER}_DTLS.zip $OUTPUT_FOLDER/$DTL_FILE_DIR/*
}

CompileAndCopyFsScan
GetTestFiles
RunScans
CleanUp

exit $?
