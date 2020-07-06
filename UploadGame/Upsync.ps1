function Upsync {
    param (
        [Parameter(Mandatory)] [string] $SourcePath,
        [Parameter(Mandatory)] [string] $VersionIndexURI,
        [Parameter(Mandatory)] [string] $StorageURI,
        [Parameter(Mandatory)] [string] $CredentialsFile
    )

    $OldCredentialsSetting = $env:GOOGLE_APPLICATION_CREDENTIALS
    $env:GOOGLE_APPLICATION_CREDENTIALS = $CredentialsFile
    & $PSScriptRoot\longtail-win32-x64.exe upsync --source-path $SourcePath --target-path $VersionIndexURI --storage-uri $StorageURI
    $env:GOOGLE_APPLICATION_CREDENTIALS = $OldCredentialsSetting
    if ($LASTEXITCODE -ne 0) {
        throw
    }
}