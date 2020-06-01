
function UploadGame {

	param (
		[Parameter(Mandatory)] [string] $Folder,
		[Parameter(Mandatory)] [string] $Version
	)

	$AbsoluteFolder = (Resolve-Path $Folder)

	cd FetchPrebuiltUE4
	& .\FetchPrebuiltUE4 upload-package "--folder" "$AbsoluteFolder" "--package" "Game-$Version"
	if ($LASTEXITCODE -ne 0) { throw }
}
