<#
    .SYNOPSIS
    Sets or creates the value for the specified registry entry.

    .DESCRIPTION
    Update-RegistryItem tests if the specified registry entry exists, if it does, then it calls Set-ItemProperty to set the value. If the entry doesn't exist, it calls New-ItemProperty.

    The reason for me to create this was to simplify DSC resources.

    .EXAMPLE
    Update-RegistryItem -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management' -Name 'FeatureSettingsOverride' -Value 0 -PropertyType 'DWORD'
    Sets or creates the registry value FeatureSettingsOverride at HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management to 0.

    .PARAMETER confirm
    Prompts you for confirmation before running the cmdlet.

    .PARAMETER whatif
    Shows what would happen if the cmdlet runs. The cmdlet is not run.
#>
function Update-RegistryItem
{
    [CMDLetBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
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

        # Specifies the property value of the entry.
        [Parameter(Mandatory = $true)]
        [ValidateNotNullorEmpty()]
        [String]
        $Value,

        # Specifies the type of property that this cmdlet adds (if needed). The acceptable values for this parameter are: String. Specifies a null-terminated string. Equivalent to REG_SZ.  - ExpandString. Specifies a null-terminated string that contains unexpanded references to environment variables that are expanded when the value is retrieved. Equivalent to REG_EXPAND_SZ.  - Binary. Specifies binary data in any form. Equivalent to REG_BINARY.  - DWord. Specifies a 32-bit binary number. Equivalent to REG_DWORD.  - MultiString. Specifies an array of null-terminated strings terminated by two null characters. Equivalent to REG_MULTI_SZ.  - Qword. Specifies a 64-bit binary number. Equivalent to REG_QWORD.  - Unknown. Indicates an unsupported registry data type, such as REG_RESOURCE_LIST.
        [Parameter(Mandatory = $true)]
        [ValidateNotNullorEmpty()]
        [String]
        $PropertyType
    )
    # Test if the path exists
    if (-not (Test-Path -Path $Path)) {
        Write-Verbose -Message 'Path does not exist, Calling New-Item'
        if ($PSCmdlet.ShouldProcess($Name, 'New-Item')) {
            $null = New-Item $Path -ItemType Directory
        }
    }

    $Item = Get-Item -Path $Path

    # Test to see if the item exists, if it does, then we set the value, if it does not, we call new-value
    if ($Item.Property.Contains($Name)) {
        Write-Verbose -Message 'Item Exists, Calling Set-ItemProperty'
        if ($PSCmdlet.ShouldProcess($Name, 'Set-ItemProperty')) {
            $null = Set-ItemProperty -Path $Path -Name $Name -Value $Value
        }
    } else {
        Write-Verbose -Message 'Item Does not Exist, Calling New-ItemProperty'
        if ($PSCmdlet.ShouldProcess($Name, 'New-ItemProperty')) {
            $null = New-ItemProperty -Path $Path -Name $Name -PropertyType $PropertyType -Value $Value
        }
    }

}