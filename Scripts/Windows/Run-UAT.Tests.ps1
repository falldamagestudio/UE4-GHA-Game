$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe 'Run-Editor' {

	It "Launches RunUAT with additional arguments" {

		Mock Start-Process { }

		Mock Get-EngineLocationForProject { "C:\UE_4.24" }

		Run-UAT -UProjectLocation "default.uproject" -Arguments "Hello", "World"

		Assert-MockCalled Start-Process -ParameterFilter { ($FilePath -eq "C:\UE_4.24\Engine\Build\BatchFiles\RunUAT.bat") -and ($ArgumentList.Length -eq 3) -and ($ArgumentList[0] -eq "default.uproject") -and ($ArgumentList[1] -eq "Hello") -and ($ArgumentList[2] -eq "World") }
	}
}