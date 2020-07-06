function Get-AutomationToolLogsLocation {

	param (
		[Parameter(Mandatory)] [string] $UE4Location
	)

	$ApplicationDataLocation = [environment]::GetFolderPath("ApplicationData")
	$MangledUE4Location = $UE4Location -replace "\\","+" -replace ":",""
	$AutomationToolLogsLocation = "${ApplicationDataLocation}\Unreal Engine\AutomationTool\Logs\${MangledUE4Location}\"
	return $AutomationToolLogsLocation
}
