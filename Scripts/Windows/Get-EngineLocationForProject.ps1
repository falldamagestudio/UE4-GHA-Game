
function Get-InstalledEpicGamesLauncherEngines {

	try {
		$ManifestLocation = Join-Path $env:ProgramData -ChildPath "Epic\UnrealEngineLauncher\LauncherInstalled.dat"

		$Manifest = Get-Content -Raw -Path $ManifestLocation | ConvertFrom-Json

		$InstalledEpicGamesLauncherEngines = $Manifest.InstallationList | Where { $_ -ne $null } | Where { $_.AppName.StartsWith("UE_") } | ForEach-Object { [PSCustomObject] @{
				Id = $_.AppName.Substring(3)
				Path = $_.InstallLocation
			}
		}

		return $InstalledEpicGamesLauncherEngines
	} catch {
		return @()
	}
}

function Get-InstalledLocallyRegisteredEngines {

	try {
		$LocallyRegisteredEnginesRegistryLocation = "Registry::HKEY_CURRENT_USER\SOFTWARE\Epic Games\Unreal Engine\Builds"

		$LocallyRegisteredEngines = (Get-Item -Path $LocallyRegisteredEnginesRegistryLocation).Property | Where { $_ -ne $null } | ForEach-Object { [PSCustomObject] @{
				Id = $_
				Path = (Get-ItemProperty -Path $LocallyRegisteredEnginesRegistryLocation).$_
			}
		}

		return $LocallyRegisteredEngines
	} catch {
		return @()
	}
}

function Get-InstalledEngines {

	$InstalledEpicGamesLauncherEngines = @(Get-InstalledEpicGamesLauncherEngines)
	$InstalledLocallyRegisteredEngines = @(Get-InstalledLocallyRegisteredEngines)

	return $InstalledEpicGamesLauncherEngines + $InstalledLocallyRegisteredEngines
}

function Get-EngineAssociationForProject {

	param (
		[Parameter(Mandatory)] [String] $UProjectLocation
	)

	try {
	
		$UProject = Get-Content -Raw -Path $UProjectLocation | ConvertFrom-Json
		
		return $UProject.EngineAssociation
	
	} catch {
		return $null
	}
}

function Convert-RelativePathToAbsolute {

	param (
		[Parameter(Mandatory)] [String] $UProjectLocation,
		[Parameter(Mandatory)] [String] $EnginePath
	)

	if (Split-Path -Path $EnginePath -IsAbsolute) {
		return $EnginePath
	} else {
		try {
			Push-Location (Split-Path -Path (Resolve-Path $UProjectLocation))
			return Resolve-Path $EnginePath
		} finally {
			Pop-Location
		}
	}
}

function Get-EngineLocationForProject {

	param (
		[Parameter(Mandatory)] [String] $UProjectLocation
	)

	$InstalledEngines = Get-InstalledEngines

	$EngineAssociation = Get-EngineAssociationForProject -UProjectLocation $UProjectLocation

	if (($EngineAssociation -like "*/*") -or ($EngineAssociation -like "*\*"))
	{
		return Convert-RelativePathToAbsolute -UProjectLocation $UProjectLocation -EnginePath $EngineAssociation
	}
	else
	{
		return $InstalledEngines | Where { $_.Id -eq $EngineAssociation } | ForEach-Object { Write-Host $_.Path; Convert-RelativePathToAbsolute -UProjectLocation $UProjectLocation -EnginePath $_.Path }
	}
}