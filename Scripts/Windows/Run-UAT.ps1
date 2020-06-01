$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$here\Get-EngineLocationForProject.ps1"

function Run-UAT {

	param (
		[Parameter(Mandatory)] [String] $UProjectLocation,
		[Parameter()] [String[]] $Arguments
	)

	$EngineLocation = Get-EngineLocationForProject -UProjectLocation $UProjectLocation

	$RunUATLocation = Join-Path $EngineLocation -ChildPath "Engine\Build\BatchFiles\RunUAT.bat"
	
	$RunUATArguments = $Arguments | Where { $_ -ne $null }

	Start-Process -FilePath $RunUATLocation -ArgumentList $RunUATArguments -NoNewWindow -Wait
}