
param (
    [Parameter(Mandatory)] [string] $Version
)

. $PSScriptRoot\Upsync.ps1

try {

	$CredentialsFile = "${PSScriptRoot}\service-account-credentials.json"

    $LocalConfigurationLocation = "${PSScriptRoot}\local_configuration.json"
    $LocalConfiguration = Get-Content -Path $LocalConfigurationLocation | ConvertFrom-Json

    $OnlineConfigurationLocation = "${PSScriptRoot}\online_configuration.json"
    $OnlineConfiguration = Get-Content -Path $OnlineConfigurationLocation | ConvertFrom-Json

    $BuiltGameLocation = "${PSScriptRoot}\$($LocalConfiguration.built_game_location)"
    $SourcePath = "\\?\$(Resolve-Path $BuiltGameLocation)"
    $VersionIndexURI = "$($OnlineConfiguration.version_index_uri)/${Version}.lvi"
    $StorageURI = $OnlineConfiguration.storage_uri

    Upsync -SourcePath $SourcePath -VersionIndexURI $VersionIndexURI -StorageURI $StorageURI -CredentialsFile $CredentialsFile

    Write-Host "Uploaded game as ${Version}"

} catch {

    Write-Host "Game upload failed"
    throw

}
