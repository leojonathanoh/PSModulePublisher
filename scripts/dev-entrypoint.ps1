# This script acts as an entrypoint for executing all relevant scripts. It is designed to be used in development.
# For safety reasons, publishing of the module is designed to fail by default unless a repository is specified

[CmdletBinding()]
param(
    [Parameter(Mandatory=$false)]
    [ValidateNotNullOrEmpty()]
    [string]$PublishRepository
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
# $VerbosePreference = 'Continue'

try {
    Push-Location $PSScriptRoot

    # Run the build entrypoint script
    $manifestPath = & "$PSScriptRoot\build.ps1"

    # Run the test entrypoint script
    & "$PSScriptRoot\test.ps1" -ModuleManifestPath $manifestPath

    # Run the publish entrypoint script
    & "$PSScriptRoot\publish.ps1" -ModuleManifestPath $manifestPath -PublishRepository $PublishRepository

}catch {
    throw
}finally {
    Pop-Location
}
