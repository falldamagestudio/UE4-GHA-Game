
param (
    [Parameter(Mandatory)] [string] $Version,
    [Parameter(Mandatory)] [string] $CloudStorageBucket
)

. $PSScriptRoot\Upsync.ps1

try {

    $CredentialsFile = "${PSScriptRoot}\service-account-credentials.json"

    $LocalConfigurationLocation = "${PSScriptRoot}\local_configuration.json"
    $LocalConfiguration = Get-Content -Path $LocalConfigurationLocation | ConvertFrom-Json

    $BuiltGameLocation = "${PSScriptRoot}\$($LocalConfiguration.built_game_location)"
    $SourcePath = "\\?\$(Resolve-Path $BuiltGameLocation)"
    $VersionIndexURI = "gs://${CloudStorageBucket}/store/index/${Version}.lvi"
    $StorageURI = "gs://${CloudStorageBucket}/store"

    Upsync -SourcePath $SourcePath -VersionIndexURI $VersionIndexURI -StorageURI $StorageURI -CredentialsFile $CredentialsFile

    Write-Host "Uploaded game as ${Version}"

} catch {

    Write-Host "Game upload failed"
    throw

}
