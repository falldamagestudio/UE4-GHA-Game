$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$here\Get-EngineLocationForProject.ps1"

class UE4EditorException : Exception {
	$ExitCode

	UE4EditorException([int] $exitCode) : base("UE4Editor exited with code ${exitCode}") { $this.ExitCode = $exitCode }
}

function Run-Editor {

	param (
		[Parameter(Mandatory)] [String] $UProjectLocation,
		[Parameter()] [String[]] $Arguments
	)

	$EngineLocation = Get-EngineLocationForProject -UProjectLocation $UProjectLocation

	$EditorLocation = Join-Path $EngineLocation -ChildPath "Engine\Binaries\Win64\UE4Editor.exe"
	
	$EditorArguments = @($UProjectLocation) + $Arguments | Where { $_ -ne $null }

	$Process = Start-Process -FilePath $EditorLocation -ArgumentList $EditorArguments -NoNewWindow -Wait -PassThru

	if ($Process.ExitCode -ne 0) {
		throw [UE4EditorException]::new($Process.ExitCode)
	}
}

