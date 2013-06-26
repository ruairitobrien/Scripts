#
# Main.ps1
#


# The location of this script used to allow derivement of fully qualified path names.
[string]$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition 

#
# Locations for executable and test files. These should be put here at specified intervals
# which is handled seperate to this script.
#
[string]$newFsReports 					# The latest fsReports build that is under test
[string]$newFsScan						# The latest version of fsScan that is under test
[string]$stableFsReports				# The previous stable version of fsReports to test against
[string]$stableFsScan					# The previous stable version of fsScan to test against

$newFsReports = "$scriptPath\Working\New\fsReport.exe"
$newFsScan = "$scriptPath\Working\New\fsScan.exe"
$stableFsReports = "$scriptPath\Working\Stable\fsReport.exe"
$stableFsScan = "$scriptPath\Working\Stable\fsScan.exe"
$newFsDiff = "$scriptPath\Working\New\fsDiff.exe"
$stableFsDiff  = "$scriptPath\Working\Stable\fsDiff.exe"


#
# Input locations. All config files and DTL files are inputs that will be used by fsReports
# to create reports. The primary outputs that are tested by this test applicaiton are the 
# outputs of fsReports.
#
# There is also a location for scan configurations which are inputs.
# DTL files produced by fsScan are not tested directly in scripts so are still considered inputs
# for fsReports and therefore will be stored in the DTL input directory even though they 
# are essentially outputs of fsScan.
#
[string]$inputDirectory 				# Where resources that will be used by fsUtils will go
[string]$dtlFilesDirectory 				# Where DTL files produced by fsScan will go
[string]$stableDtlFilesDirectory		# Where DTL files produced by the stable fsScan build will go
[string]$newDtlFilesDirectory			# Where DTL files produced by the new fsScan build will go
[string]$scanConfigurationDirectory	 	# Where all scan configuration files that may be used by fsScan will go
[string]$reportConfigurationDirectory 	# Where all report configuration files that may be used by fsReports will go

$inputDirectory = "$scriptPath\Inputs"
$dtlFilesDirectory = "$inputDirectory\DtlFiles"
$stableDtlFilesDirectory = "$dtlFilesDirectory\Stable"
$newDtlFilesDirectory = "$dtlFilesDirectory\New"
$scanConfigDirectory = "$inputDirectory\Config\Scan"
$reportConfigDirectory = "$inputDirectory\Config\Report"

#
# Outputs are all generated from fsReports. These outputs will be checked for inconsistencies.
# The current strategy is to generate outputs from an existing stable version of fsReports.
# Then generate outputs for the new version of fsReports. 
# Both outputs are checked to ensure calculations haven't been broken.
# 
# Caveat here is that these tests may have to evolve based on any changes to fsReports output.
#
[string]$outputDirectory 				# Where all outputs that should be validated will go
[string]$reportDirectory 				# Where the final output reports will go
[string]$stableReportDirectory			# Outputs from the previous stable fsReports
[string]$newReportDirectory 			# Outputs from the latest fsReports

$outputDirectory = "$scriptPath\Outputs"
$reportDirectory = "$outputDirectory\Reports"
$stableReportDirectory = "$reportDirectory\Stable"
$newReportDirectory = "$reportDirectory\New"


#
# Names of DTL files in resulting test scans
#
[string]$scanOfUnalteredTestFiles
[string]$scanOfAlteredTestFiles
[string]$scanOfAlteredTestFilesWithIncludes
[string]$scanOfAlteredTestFilesWithExcludes
[string]$scanOfAlteredTestFilesWithIncludesAndExcludes

$scanOfUnalteredTestFiles = "scanOfUnalteredTestFiles.dtl" 
$scanOfAlteredTestFiles = "scanOfAlteredTestFiles.dtl"
$scanOfAlteredTestFilesWithIncludes = "scanOfAlteredTestFilesWithIncludes.dtl"
$scanOfAlteredTestFilesWithExcludes = "scanOfAlteredTestFilesWithExcludes.dtl"
$scanOfAlteredTestFilesWithIncludesAndExcludes = "scanOfAlteredTestFilesWithIncludesAndExcludes.dtl"

#
# Configuration files for running scans
#
[string]$scanWithIncludesConfig
[string]$scanWithExcludesConfig
[string]$scanWithIncludesAndExcludesConfig

$scanConfiguration = "$scanConfigDirectory\scan.cfg"
$scanWithIncludesConfig = "$scanConfigDirectory\include_dirs.cfg"
$scanWithExcludesConfig = "$scanConfigDirectory\exclude_dirs_files.cfg"
$scanWithIncludesAndExcludesConfig = "$scanConfigDirectory\exclude_dirs_include_files.cfg"

#
# Batch file locations used by this script
#
[string]$modifyFileSystemScript
[string]$revertFileSystemScript
$modifyFileSystemScript ="$scriptPath\modifyFileSystem.bat"
$revertFileSystemScript = "$scriptPath\revertFileSystem.bat"

$sDtl0 = $stableDtlFilesDirectory + "\" + $scanOfUnalteredTestFiles
$sDtl1 = $stableDtlFilesDirectory + "\" + $scanOfAlteredTestFiles
$sDtl2 = $stableDtlFilesDirectory + "\" + $scanOfAlteredTestFilesWithIncludes
$sDtl3 = $stableDtlFilesDirectory + "\" + $scanOfAlteredTestFilesWithExcludes
$sDtl4 = $stableDtlFilesDirectory + "\" + $scanOfAlteredTestFilesWithIncludesAndExcludes
$nDtl0 = $newDtlFilesDirectory + "\" + $scanOfUnalteredTestFiles
$nDtl1 = $newDtlFilesDirectory + "\" + $scanOfAlteredTestFiles
$nDtl2 = $newDtlFilesDirectory + "\" + $scanOfAlteredTestFilesWithIncludes
$nDtl3 = $newDtlFilesDirectory + "\" + $scanOfAlteredTestFilesWithExcludes
$nDtl4 = $newDtlFilesDirectory + "\" + $scanOfAlteredTestFilesWithIncludesAndExcludes


$stableDtls = $sDtl0, $sDtl1, $sDtl2, $sDtl3, $sDtl4
$newDtls = $nDtl0, $nDtl1, $nDtl2, $nDtl3, $nDtl4

Import-Module "$scriptPath\Report.psm1" -Verbose
Import-Module "$scriptPath\Scan.psm1" -Verbose
Import-Module "$scriptPath\Diff.psm1" -Verbose


function Prepare-Workspace()
{
}

function Modify-Filesystem()
{
    Invoke-Expression $modifyFileSystemScript
}

function Revert-Filesystem()
{
    Invoke-Expression $revertFileSystemScript
}

function Run-Scans()
{
    # Run stable version of fscan on the target file system
    Invoke-FsScan $stableFsScan $stableDtls[0] $scanConfiguration 

    #	Run new version of fscan on the target file system    
    Invoke-FsScan $newFsScan $newDtls[0] $scanConfiguration

    #   Modify test file system with extra mountpoints, junctionpoints, hard links, symlinks: directories, symlinks: files
    Modify-Filesystem

    #	Run stable version of fscan on the modified target file system     
    Start-FsScan $stableFsScan $stableDtls[1] $scanConfiguration

    #	Run stable version of fscan on the modified target file system with include filter    
    Start-FsScan $stableFsScan $stableDtls[2] $scanWithIncludesConfig

    #	Run stable version of fscan on the modified target file system with exclude filter    
    Start-FsScan $stableFsScan $stableDtls[3] $scanWithExcludesConfig

    #	Run stable version of fscan on the modified target file system with include/exclude filter    
    Start-FsScan $stableFsScan $stableDtls[4] $scanWithIncludesAndExcludesConfig

    #	Run new version of fscan on the modified target file system     
    Start-FsScan $newFsScan $newDtls[1] $scanConfiguration 

    #	Run new version of fscan on the modified target file system with include filter    
    Start-FsScan $newFsScan $newDtls[2] $scanWithIncludesConfig

    #	Run new version of fscan on the modified target file system with exclude filter    
    Start-FsScan $newFsScan $newDtls[3] $scanWithExcludesConfig

    #	Run new version of fscan on the modified target file system with include/exclude filter    
    Start-FsScan $newFsScan $newDtls[4] $scanWithIncludesAndExcludesConfig 

    # 	Revert test file system to original state
    Revert-Filesystem
}

function Run-Diffs([string]$fsDiffToUse)
{
    For ($i=0; $i -lt $dtls.Length/2 ; $i++)  
    {
        Start-FsDiff $fsDiff $stableDtls[$i] $newDtls[$i]                        
    }
}

function Run-Reports([string]$fsReportsToUse, [string[]]$dtls)
{
    For ($i=0; $i -lt $dtls.Length/2 ; $i++)  
    {
        Start-FsDiff $fsDiff $stableDtls[$i] $newDtls[$i]                        
    }
}


# Test Steps

# Make sure everything is in the right place
Prepare-Workspace

# Run scans to generate DTL files that will be used to test correctness of programs under test
Run-Scans

#	Run stable version of fsdiff on the dtls produced from scans on the original and modified file system (no filters)
Run-Diffs $stableFsDiff

#	Run stable version of fsreport on all dtls produced by the stable fsScan using all configurations included in a specified configuration directory
Run-FsReports $stableFsReports $stableDtls

#	Run new version of fsdiff on the dtls produced from scans on the original and modified file system (no filters)
Run-Diffs $newFsDiff

#	Run new version of fsreport on all dtls produced by the new fsScan using all configurations included in a specified configuration directory
Run-FsReports $newFsReports $newDtls

# 	Verify Outputs 

#	Compare all reports produced by stable fsReports against all reports produced by new fsReports: 
#       handle expected differences and flag unexpected differences

#      Compare all reports produced by the stable fsDiff and the new fsDiff: 
#      handle expected differences and flag unexpected 

