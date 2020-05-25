$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$here\Get-EngineLocationForProject.ps1"

function Run-Editor {

	param (
		[Parameter(Mandatory)] [String] $UProjectLocation,
		[Parameter()] [String[]] $Arguments
	)

	$EngineLocation = Get-EngineLocationForProject -UProjectLocation $UProjectLocation

	$EditorLocation = Join-Path $EngineLocation -ChildPath "Engine\Binaries\Win64\UE4Editor.exe"
	
	$EditorArguments = @($UProjectLocation) + $Arguments | Where { $_ -ne $null }

	Start-Process -FilePath $EditorLocation -ArgumentList $EditorArguments -NoNewWindow
}