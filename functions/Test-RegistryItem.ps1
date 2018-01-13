<#
    .SYNOPSIS
    Tests if the registry entry at the specified path exists and has the specified value.

    .DESCRIPTION
    This CMDLet tests if the registry value at the specified path exists, and is of an expected value.

    .EXAMPLE
    Test-RegistryItem -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management' -Name 'FeatureSettingsOverride' -ExpectedValue 0
    Will check if the registry value FeatureSettingsOverride found at HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management has a value of 0
#>
function Test-RegistryItem
{
    [CMDLetBinding()]
    [OutputType([System.Boolean])]
    Param (
        # Specifies the path of the entry. This parameter identifies the entry to which this cmdlet sets or creates the new property.
        [Parameter(Mandatory = $true)]
        [ValidateNotNullorEmpty()]
        [String]
        $Path,

        # Specifies a name for the entry.
        [Parameter(Mandatory = $true)]
        [ValidateNotNullorEmpty()]
        [String]
        $Name,

        # Specifies the expected property value of the entry.
        [Parameter(Mandatory = $true)]
        [ValidateNotNullorEmpty()]
        [String]
        $ExpectedValue
    )

    # Test if the path exists
    if (-not (Test-Path -Path $Path)) {
        return $false
    }

    $Item = Get-Item -Path $Path

    # Tests if the item exists
    if (-not ($Item.Property.Contains($Name))) {
        return $false
    }

    # Test if the value matches
    return ($Item.getValue($Name) -eq $ExpectedValue)
}