$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe 'Get-InstalledEpicGamesLauncherEngines' {

	It "Parses an Epic Games Launcher manifest with two engine entries" {

		$ManifestJson =
@"
			{
				"InstallationList": [
					{
						"InstallLocation": "C:\\Program Files\\Epic Games\\RandomGame",
						"AppName": "ThisGameTitle",
						"AppVersion": "1.5.2.3c Win"
					},
					{
						"InstallLocation": "C:\\Program Files\\Epic Games\\UE_4.24",
						"AppName": "UE_4.24",
						"AppVersion": "4.24.1-10757647+++UE4+Release-4.24-Windows"
					},
					{
						"InstallLocation": "C:\\Program Files\\Epic Games\\UE_4.25",
						"AppName": "UE_4.25",
						"AppVersion": "4.25.0-fake-version-number"
					}
				]
			}
"@

		Mock Get-Content -MockWith { $ManifestJson }

		$EngineLocations = Get-InstalledEpicGamesLauncherEngines
		
		$EngineLocations.Length | Should be 2

		$ExpectedLocation0 = [PSCustomObject]@{
			Id = "4.24"
			Path = "C:\Program Files\Epic Games\UE_4.24"
		}

		Assert-Equivalent -Actual $EngineLocations[0] -Expected $ExpectedLocation0

		$ExpectedLocation1 = [PSCustomObject]@{
			Id = "4.25"
			Path = "C:\Program Files\Epic Games\UE_4.25"
		}

		Assert-Equivalent -Actual $EngineLocations[1] -Expected $ExpectedLocation1
	}

	It "rejects an invalid Epic Games Launcher manifest" {
	
		$ManifestJson =
@"
			Random text string
"@

		Mock Get-Content -MockWith { $ManifestJson }

		$EngineLocations = Get-InstalledEpicGamesLauncherEngines
		
		$EngineLocations | Should be $null
	}

	It "ignores a nonexistent Epic Games Launcher manifest" {
	
		Mock Get-Content -MockWith { throw }

		$EngineLocations = Get-InstalledEpicGamesLauncherEngines
		
		$EngineLocations | Should be $null
	}
}

Describe 'Get-InstalledLocallyRegisteredEngines' {

	It "Parses registry key with two engine entries" {

		Mock Get-Item -MockWith { return [PSCustomObject]@{
			Property = "{38624191-4095-2E0F-450E-489B6E235BD9}", "{08B992EC-4BD2-644D-98C2-A194C91586B2}"
			}
		}

		Mock Get-ItemProperty -MockWith { return [PSCustomObject]@{
			"{38624191-4095-2E0F-450E-489B6E235BD9}" = "D:\InstalledEngine0"
			"{08B992EC-4BD2-644D-98C2-A194C91586B2}" = "D:\InstalledEngine1"
			}
		}

		$LocallyRegisteredEngines = Get-InstalledLocallyRegisteredEngines

		$LocallyRegisteredEngines.Length | Should be 2

		$LocallyRegisteredEngine0 = [PSCustomObject]@{
			Id = "{38624191-4095-2E0F-450E-489B6E235BD9}"
			Path = "D:\InstalledEngine0"
		}

		Assert-Equivalent -Actual $LocallyRegisteredEngines[0] -Expected $LocallyRegisteredEngine0

		$LocallyRegisteredEngine1 = [PSCustomObject]@{
			Id = "{08B992EC-4BD2-644D-98C2-A194C91586B2}"
			Path = "D:\InstalledEngine1"
		}

		Assert-Equivalent -Actual $LocallyRegisteredEngines[1] -Expected $LocallyRegisteredEngine1
	}

	It "Ignores nonexistent registry key" {

		Mock Get-Item -MockWith { throw }

		Mock Get-ItemProperty -MockWith { throw }

		$LocallyRegisteredEngines = Get-InstalledLocallyRegisteredEngines

		$LocallyRegisteredEngines | Should be $null
	}
}

Describe 'Get-InstalledEngines' {

	It "Handles two Epic Games engines & two locally installed engines" {

		$ManifestJson =
@"
			{
				"InstallationList": [
					{
						"InstallLocation": "C:\\Program Files\\Epic Games\\RandomGame",
						"AppName": "ThisGameTitle",
						"AppVersion": "1.5.2.3c Win"
					},
					{
						"InstallLocation": "C:\\Program Files\\Epic Games\\UE_4.24",
						"AppName": "UE_4.24",
						"AppVersion": "4.24.1-10757647+++UE4+Release-4.24-Windows"
					},
					{
						"InstallLocation": "C:\\Program Files\\Epic Games\\UE_4.25",
						"AppName": "UE_4.25",
						"AppVersion": "4.25.0-fake-version-number"
					}
				]
			}
"@

		Mock Get-Content -MockWith { $ManifestJson }

		Mock Get-Item -MockWith { return [PSCustomObject]@{
			Property = "{38624191-4095-2E0F-450E-489B6E235BD9}", "{08B992EC-4BD2-644D-98C2-A194C91586B2}"
			}
		}

		Mock Get-ItemProperty -MockWith { return [PSCustomObject]@{
			"{38624191-4095-2E0F-450E-489B6E235BD9}" = "D:\InstalledEngine0"
			"{08B992EC-4BD2-644D-98C2-A194C91586B2}" = "D:\InstalledEngine1"
			}
		}

		$InstalledEngines = Get-InstalledEngines

		$ExpectedEngines =
			[PSCustomObject] @{
				Id = "4.24"
				Path = "C:\Program Files\Epic Games\UE_4.24"
			},
			[PSCustomObject] @{
				Id = "4.25"
				Path = "C:\Program Files\Epic Games\UE_4.25"
			},
			[PSCustomObject] @{
				Id = "{38624191-4095-2E0F-450E-489B6E235BD9}"
				Path = "D:\InstalledEngine0"
			},
			[PSCustomObject] @{
				Id = "{08B992EC-4BD2-644D-98C2-A194C91586B2}"
				Path = "D:\InstalledEngine1"
			}

		Assert-Equivalent -Actual $InstalledEngines -Expected $ExpectedEngines
	}

	It "Handles no installed engines" {

		$ManifestJson =
@"
			{
				"InstallationList": [
					{
						"InstallLocation": "C:\\Program Files\\Epic Games\\RandomGame",
						"AppName": "ThisGameTitle",
						"AppVersion": "1.5.2.3c Win"
					}
				]
			}
"@

		Mock Get-Content -MockWith { $ManifestJson }

		Mock Get-Item -MockWith { return [PSCustomObject]@{
			}
		}

		Mock Get-ItemProperty -MockWith { return $null }

		$InstalledEngines = Get-InstalledEngines

		$ExpectedEngines = $null

		Assert-Equivalent -Actual $InstalledEngines -Expected $ExpectedEngines
	}
}


Describe 'Get-EngineAssociationForProject' {

	It "Extracts engine association from a valid .uproject file" {

		$UProjectJson =
@"
		{
			"FileVersion": 3,
			"EngineAssociation": "4.24",
			"Category": "",
			"Description": ""
		}
"@
		Mock Get-Content -MockWith { $UProjectJson }

		$EngineAssociation = Get-EngineAssociationForProject -UProjectLocation "default.uproject"

		$EngineAssociation | Should Be "4.24"
	}

	It "Returns no engine association for invalid .uproject files" {

		Mock Get-Content -MockWith { throw }

		$InstalledEngines = Get-InstalledEngines

		$EngineAssociation = Get-EngineAssociationForProject -UProjectLocation "default.uproject"

		$EngineAssociation | Should Be $null
	}
}

Describe 'Get-EngineLocationForProject' {

	It "Returns the engine location for a local project as absolute path" {

		Mock Get-InstalledEngines -MockWith { $null }

		Mock Get-EngineAssociationForProject -MockWith { "../UE4" }

		Mock Convert-RelativePathToAbsolute -ParameterFilter { $UProjectLocation -eq "default.uproject" -and $EnginePath -eq "../UE4" } -MockWith { "D:\\ProjectDir\\UE4" }

		$EngineLocation = Get-EngineLocationForProject -UProjectLocation "default.uproject"

		$EngineLocation | Should Be "D:\\ProjectDir\\UE4"
	}

	It "Returns no engine location for invalid .uproject files" {

		Mock Get-InstalledEngines -MockWith { @( [PSCustomObject] @{
			Id = "4.24"
			Path = "C:\UE_4.24"
			})
		}

		Mock Get-EngineAssociationForProject -MockWith { $null }

		$EngineLocation = Get-EngineLocationForProject -UProjectLocation "default.uproject"

		$EngineLocation | Should Be $null
	}

	It "Returns no engine location for invalid .uproject/engine combination" {

		Mock Get-InstalledEngines -MockWith { @( [PSCustomObject] @{
			Id = "4.25"
			Path = "C:\UE_4.25"
			})
		}

		Mock Get-EngineAssociationForProject -MockWith { "4.24" }

		$EngineLocation = Get-EngineLocationForProject -UProjectLocation "default.uproject"

		$EngineLocation | Should Be $null
	}

	It "Returns a valid engine location for valid .uproject/engine combination" {

		Mock Get-InstalledEngines -MockWith { @( [PSCustomObject] @{
			Id = "4.24"
			Path = "C:\UE_4.24"
			})
		}

		Mock Get-EngineAssociationForProject -MockWith { "4.24" }

		$EngineLocation = Get-EngineLocationForProject -UProjectLocation "default.uproject"

		$EngineLocation | Should Be "C:\UE_4.24"
	}
}
