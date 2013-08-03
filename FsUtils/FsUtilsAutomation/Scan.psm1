#
# Scan.psm1
#
# Module providing functions for running fsScan
#

function Start-FsScan([string]$fsScan, [string]$dtlFile, [string]$configFile)
{
		
		$command = "$fsScan -cfg $configFile -dtl $dtlFile"
		
		If (Test-Path $dtlFile){
			Remove-Item $dtlFile
		}

		Invoke-Expression $command
}

