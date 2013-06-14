#
# Scan.psm1
#
# Module providing functions for running fsScan
#

function Invoke-FsScan([string]$fsScan, [string]$dtlFile, [string]$configFile)
{
		
		$command = "$fsScan -cfg $configFile -dtl $dtlFile"
		
		If (Test-Path $dtlFile){
			Remove-Item $dtlFile
		}

		Invoke-Expression $command
}

function Run-TestScans()
{
    # Run stable version of fscan on the target file system
    $dtl = $stableDtlFilesDirectory + "\" + $scanOfUnalteredTestFiles
    Invoke-FsScan $stableFsScan $dtl $scanConfiguration 

    #	Run new version of fscan on the target file system
    $dtl = $newDtlFilesDirectory + "\" + $scanOfUnalteredTestFiles
    Invoke-FsScan $newFsScan $dtl $scanConfiguration

    #   Modify test file system with extra mountpoints, junctionpoints, hard links, symlinks: directories, symlinks: files


    #	Run stable version of fscan on the modified target file system 
    $dtl = $stableDtlFilesDirectory + "\" + $scanOfAlteredTestFiles
    Invoke-FsScan $stableFsScan $dtl $scanConfiguration

    #	Run stable version of fscan on the modified target file system with include filter
    $dtl = $stableDtlFilesDirectory + "\" + $scanOfAlteredTestFilesWithIncludes
    Invoke-FsScan $stableFsScan $dtl $scanWithIncludesConfig

    #	Run stable version of fscan on the modified target file system with exclude filter
    $dtl = $stableDtlFilesDirectory + "\" + $scanOfAlteredTestFilesWithExcludes
    Invoke-FsScan $stableFsScan $dtl $scanWithExcludesConfig

    #	Run stable version of fscan on the modified target file system with include/exclude filter
    $dtl = $stableDtlFilesDirectory + "\" + $scanOfAlteredTestFilesWithIncludesAndExcludes
    Invoke-FsScan $stableFsScan $dtl $scanWithIncludesAndExcludesConfig

    #	Run new version of fscan on the modified target file system 
    $dtl = $newDtlFilesDirectory + "\" + $scanOfUnalteredTestFiles
    Invoke-FsScan $newFsScan $dtl $scanConfiguration 

    #	Run new version of fscan on the modified target file system with include filter
    $dtl = $newDtlFilesDirectory + "\" + $scanOfAlteredTestFilesWithIncludes
    Invoke-FsScan $newFsScan $dtl $scanWithIncludesConfig

    #	Run new version of fscan on the modified target file system with exclude filter
    $dtl = $newDtlFilesDirectory + "\" + $scanOfAlteredTestFilesWithExcludes
    Invoke-FsScan $newFsScan $dtl $scanWithExcludesConfig

    #	Run new version of fscan on the modified target file system with include/exclude filter
    $dtl = $newDtlFilesDirectory + "\" + $scanOfAlteredTestFilesWithIncludesAndExcludes
    Invoke-FsScan $newFsScan $dtl $scanWithIncludesAndExcludesConfig 
}