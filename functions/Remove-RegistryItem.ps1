<#
    .SYNOPSIS
    Removes value for the specified registry entry.

    .DESCRIPTION
    Removes the registry entry.

    The reason for me to create this was to simplify DSC resources.

    .EXAMPLE
    Update-RegistryItem -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management' -Name 'FeatureSettingsOverride'
    Removes registry value FeatureSettingsOverride at HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management

    .PARAMETER confirm
    Prompts you for confirmation before running the cmdlet.

    .PARAMETER whatif
    Shows what would happen if the cmdlet runs. The cmdlet is not run.
#>
function Remove-RegistryItem
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
        $Name
    )
    # Test if the path exists
    if (-not (Test-Path -Path $Path)) {
        Write-Verbose -Message 'Path does not exist, Calling New-Item'
        if ($PSCmdlet.ShouldProcess($Name, 'New-Item')) {
            $null = New-Item $Path -ItemType Directory
        }
    }

    Write-Verbose -Message 'Removing Item'
    if ($PSCmdlet.ShouldProcess($Name, 'Remove-ItemProperty')) {
        $null = Remove-ItemProperty -Path $Path -Name $Name
    }
}