
. .\Scripts\Windows\Run-UAT.ps1

function BuildGame {

	param (
		[Parameter(Mandatory)] [string] $ProjectLocation,
		[Parameter(Mandatory)] [string] $TargetPlatform,
		[Parameter(Mandatory)] [string] $Configuration,
		[Parameter(Mandatory)] [string] $Target,
		[Parameter(Mandatory)] [string] $ArchiveDir
	)

	Run-UAT -UProjectLocation $ProjectLocation -Arguments "-ScriptsForProject=$(Resolve-Path $ProjectLocation)", "BuildCookRun", "-installed", "-nop4", "-project=$(Resolve-Path $ProjectLocation)", "-cook", "-stage", "-archive", "-archivedirectory=$(Resolve-Path $ArchiveDir)", "-package", "-pak", "-prereqs", "-nodebuginfo", "-targetplatform=$TargetPlatform", "-build", "-target=$Target", "-clientconfig=$Configuration", "-utf8output", "-buildmachine", "-iterativecooking", "-iterativedeploy", "-NoCodeSign"
}
