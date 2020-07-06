function Get-AutomationToolLogLocation {

	param (
		[Parameter(Mandatory)] [string] $UE4Location
	)

	$ApplicationDataLocation = [environment]::GetFolderPath("ApplicationData")
	$MangledUE4Location = $UE4Location -replace "\\","+" -replace ":",""
	$AutomationToolLogLocation = "${ApplicationDataLocation}\Unreal Engine\AutomationTool\Logs\${MangledUE4Location}\Log.txt"
	return $AutomationToolLogLocation
}
