#!/bin/bash -ex

# Author: Ruairí O Brien
# 20/02/2013

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

