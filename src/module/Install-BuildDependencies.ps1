[CmdletBinding()]
param()

try {
    # Get info on PSGallery repository
    "Retrieving info on PSGallery repository" | Write-Host
    Get-PSRepository -Name 'PSGallery' | Format-List -Property * | Out-String | Write-Verbose

    # Install NuGet package provider
    "Checking NuGet version" | Write-Host
    $nugetRequiredVersion = [version]'2.8.5.201'
    $nuget = Get-PackageProvider 'NuGet' -ListAvailable -ErrorAction SilentlyContinue
    if (!$nuget -or !($nuget.Version -gt $nugetRequiredVersion)) {
        "Installing NuGet" | Write-Host
        Install-PackageProvider -Name NuGet -MinimumVersion $nugetRequiredVersion -Force
    }

    # Install PowerShellGet module of the specified version
    "Checking PowerShellGet version" | Write-Host
    $powershellgetRequiredVersion = [version]'2.1.2'
    $powershellget = Get-Module 'PowerShellGet' -ListAvailable
    if (!($powershellget.Version -eq $powershellgetRequiredVersion)) {
        "Installing PowerShellGet" | Write-Host
        Install-Module -Name 'PowershellGet' -Repository 'PSGallery' -RequiredVersion $powershellgetRequiredVersion -Scope CurrentUser -Force
    }

    # Import and get info on PowerShellGet
    "Importing PowerShellGet" | Write-Host
    Import-Module -Name 'PowerShellGet' -RequiredVersion $powershellgetRequiredVersion -Force
    Get-Module -Name 'PowerShellGet' -ListAvailable | Out-String | Write-Verbose

}catch {
    throw
}
