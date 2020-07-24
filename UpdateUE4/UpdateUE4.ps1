param (
    [Parameter(Mandatory)] [string] $CloudStorageBucket
)

. $PSScriptRoot\Downsync.ps1

try {

    $CredentialsFile = "${PSScriptRoot}\service-account-credentials.json"

    $LocalConfigurationLocation = "${PSScriptRoot}\local_configuration.json"
    $LocalConfiguration = Get-Content -Path $LocalConfigurationLocation | ConvertFrom-Json

    $DesiredVersionLocation = "${PSScriptRoot}\desired_version.json"
    if (Test-Path $DesiredVersionLocation) {
        $DesiredVersion = Get-Content -Path $DesiredVersionLocation | ConvertFrom-Json
    } else {
        $DesiredVersion = @{ "version" = "" }
    }

    $InstalledVersionLocation = "${PSScriptRoot}\installed_version.json"
    if (Test-Path $InstalledVersionLocation) {
        $InstalledVersion = Get-Content -Path $InstalledVersionLocation | ConvertFrom-Json
    } else {
        $InstalledVersion = @{ "version" = "" }
    }

    if ($DesiredVersion.version -ne $InstalledVersion.version) {

        $UE4Location = "${PSScriptRoot}\$($LocalConfiguration.ue4_location)"
        if (!(Test-Path $UE4Location)) {
            New-Item $UE4Location -ItemType Directory | Out-Null
        }

        $CacheLocation = "${PSScriptRoot}\$($LocalConfiguration.cache_location)"
        if (!(Test-Path $CacheLocation)) {
            New-Item $CacheLocation -ItemType Directory | Out-Null
        }

        $VersionIndexURI = "gs://${CloudStorageBucket}/store/index/$($DesiredVersion.version).lvi"
        $StorageURI = "gs://${CloudStorageBucket}/store"
        $CacheLocation = $CacheLocation
        $TargetPath = "\\?\$(Resolve-Path $UE4Location)"

        Downsync -VersionIndexURI $VersionIndexURI -StorageURI $StorageURI -CacheLocation $CacheLocation -TargetPath $TargetPath -CredentialsFile $CredentialsFile

        Write-Host "Updated to UE4 version $($DesiredVersion.version)"

        $DesiredVersion | ConvertTo-Json | Out-File -FilePath $InstalledVersionLocation

    } else {

        Write-Host "UE4 version $($DesiredVersion.version) is already installed"

    }

} catch {

    Write-Host "UE4 version update failed"
    throw

}
