#
# Diff.psm1
#
# Module providing functions for running fsScan
#

function Start-FsDiff([string]$fsDiff, [string]$dtlFile1, [string]$dtlFile2)
{
		
		$command = "$fsDiff $dtlFile $dtlFile2"

		Invoke-Expression $command
}