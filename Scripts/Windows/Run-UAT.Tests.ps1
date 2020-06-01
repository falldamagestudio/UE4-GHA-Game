$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe 'Run-UAT' {

	It "Launches RunUAT with additional arguments" {

		Mock Start-Process { @{ ExitCode = 0 } }

		Mock Get-EngineLocationForProject { "C:\UE_4.24" }

		Run-UAT -UProjectLocation "default.uproject" -Arguments "Hello", "World"

		Assert-MockCalled Start-Process -ParameterFilter { ($FilePath -eq "C:\UE_4.24\Engine\Build\BatchFiles\RunUAT.bat") -and ($ArgumentList.Length -eq 2) -and ($ArgumentList[0] -eq "Hello") -and ($ArgumentList[1] -eq "World") }
	}

	It "Throws an exception when the editor returns an error" {

		Mock Start-Process { @{ ExitCode = 5 } }

		Mock Get-EngineLocationForProject { "C:\UE_4.24" }

		{ Run-UAT -UProjectLocation "default.uproject" -Arguments "Hello", "World" } |
			Should Throw "Run-UAT exited with code 5"
	}
}