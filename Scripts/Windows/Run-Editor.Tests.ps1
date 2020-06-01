$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe 'Run-Editor' {

	It "Launches editor without additional arguments" {

		Mock Start-Process { return @{ ExitCode = 0 } }

		Mock Get-EngineLocationForProject { "C:\UE_4.24" }

		Run-Editor -UProjectLocation "default.uproject"

		Assert-MockCalled Start-Process -ParameterFilter { ($FilePath -eq "C:\UE_4.24\Engine\Binaries\Win64\UE4Editor.exe") -and ($ArgumentList -eq "default.uproject") }
	}

	It "Launches editor with additional arguments" {

		Mock Start-Process { return @{ ExitCode = 0 } }

		Mock Get-EngineLocationForProject { "C:\UE_4.24" }

		Run-Editor -UProjectLocation "default.uproject" -Arguments "Hello", "World"

		Assert-MockCalled Start-Process -ParameterFilter { ($FilePath -eq "C:\UE_4.24\Engine\Binaries\Win64\UE4Editor.exe") -and ($ArgumentList.Length -eq 3) -and ($ArgumentList[0] -eq "default.uproject") -and ($ArgumentList[1] -eq "Hello") -and ($ArgumentList[2] -eq "World") }
	}

	It "Throws an exception when the editor returns an error" {

		Mock Start-Process { return @{ ExitCode = 3 } }

		Mock Get-EngineLocationForProject { "C:\UE_4.24" }

		{ Run-Editor -UProjectLocation "default.uproject" } |
			Should Throw "UE4Editor exited with code 3"
	}

}