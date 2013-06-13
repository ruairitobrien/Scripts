#
# Report.psm1
#
# Module providing functions for running fsReports and analysing report outputs
#

function Invoke-FsReport([string]$fsReport, [string]$dtlFile, [string]$configFile, [string]$reportDirectory)
{
		$command = "$fsReport -dtl $dtlFile -cfg $configFile -rdir $reportDirectory"	
		
		Invoke-Expression $command
}