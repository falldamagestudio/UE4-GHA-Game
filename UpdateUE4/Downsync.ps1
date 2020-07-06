function Downsync {
    param (
        [Parameter(Mandatory)] [string] $VersionIndexURI,
        [Parameter(Mandatory)] [string] $StorageURI,
        [Parameter(Mandatory)] [string] $CacheLocation,
        [Parameter(Mandatory)] [string] $TargetPath,
        [Parameter(Mandatory)] [string] $CredentialsFile
    )

    $OldCredentialsSetting = $env:GOOGLE_APPLICATION_CREDENTIALS
    $env:GOOGLE_APPLICATION_CREDENTIALS = $CredentialsFile
    & $PSScriptRoot\longtail-win32-x64.exe downsync --source-path $VersionIndexURI --target-path $TargetPath --storage-uri $StorageURI --cache-path $CacheLocation
    $env:GOOGLE_APPLICATION_CREDENTIALS = $OldCredentialsSetting
    if ($LASTEXITCODE -ne 0) {
        throw
    }
}