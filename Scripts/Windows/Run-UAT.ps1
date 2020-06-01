$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$here\Get-EngineLocationForProject.ps1"

class UATException : Exception {
	$ExitCode

	UATException([int] $exitCode) : base("Run-UAT exited with code ${exitCode}") { $this.ExitCode = $exitCode }
}

function Run-UAT {

	param (
		[Parameter(Mandatory)] [String] $UProjectLocation,
		[Parameter()] [String[]] $Arguments
	)

	$EngineLocation = Get-EngineLocationForProject -UProjectLocation $UProjectLocation

	$RunUATLocation = Join-Path $EngineLocation -ChildPath "Engine\Build\BatchFiles\RunUAT.bat"
	
	$RunUATArguments = $Arguments | Where { $_ -ne $null }

	$Process = Start-Process -FilePath $RunUATLocation -ArgumentList $RunUATArguments -NoNewWindow -Wait -PassThru
	
	if ($Process.ExitCode -ne 0) {
		throw [UATException]::new($Process.ExitCode)
	}
}