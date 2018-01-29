$MemoryManagementPath = 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management'
$VirtualizationPath   = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Virtualization'

Function Get-TargetResource
{
    [OutputType([System.Collections.Hashtable])]
    [CMDLetBinding()]
    param
    (
        # Parameter help description
        [Parameter(Mandatory = $true)]
        [ValidateSet('Enabled', 'Disabled')]
        [String]
        $Status
    )

    $getTargetResourceResult = $null

    # Test if the fixes are enabled
    $FeatureSettingsOverrideEnabled = Test-RegistryItem -Path $MemoryManagementPath -Name 'FeatureSettingsOverride' -ExpectedValue 0
    Write-Verbose -Message ('FeatureSettingsOverride is {0}' -f $FeatureSettingsOverrideEnabled)

    $FeatureSettingsOverrideMaskEnabled = Test-RegistryItem -Path $MemoryManagementPath -Name 'FeatureSettingsOverrideMask' -ExpectedValue 1
    Write-Verbose -Message ('FeatureSettingsOverrideMask is {0}' -f $FeatureSettingsOverrideMaskEnabled)

    $MinVmVersionForCpuBasedMitigationsEnabled = Test-RegistryItem -Path $VirtualizationPath -Name 'MinVmVersionForCpuBasedMitigations' -ExpectedValue '1.0'
    Write-Verbose -Message ('MinVmVersionForCpuBasedMitigations is {0}' -f $MinVmVersionForCpuBasedMitigationsEnabled)

    if ($FeatureSettingsOverrideEnabled -and $FeatureSettingsOverrideMaskEnabled -and $MinVmVersionForCpuBasedMitigationsEnabled)
    {
        $Status = 'Enabled'
    }
    else
    {
        $Status = 'Disabled'
    }

    $getTargetResourceResult = @{
        Status = $Status
    }

    $getTargetResourceResult
}

Function Set-TargetResource
{
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '')]
    [CMDLetBinding(SupportsShouldProcess=$true)]
    param
    (
        # Parameter help description
        [Parameter(Mandatory = $true)]
        [ValidateSet('Enabled', 'Disabled')]
        [String]
        $Status
    )

    if ($Status -eq 'Enabled')
    {
        Write-Verbose -Message 'Enabling Protections'
        if ($PSCmdlet.ShouldProcess('Enable cSpeculationControlFix', 'Set-TargetResource')) {
            Update-RegistryItem -Path $MemoryManagementPath -Name 'FeatureSettingsOverride' -Value 0 -PropertyType 'DWORD' -Confirm:$false
            Update-RegistryItem -Path $MemoryManagementPath -Name 'FeatureSettingsOverrideMask' -Value 1 -PropertyType 'DWORD' -Confirm:$false
            Update-RegistryItem -Path $VirtualizationPath -Name 'MinVmVersionForCpuBasedMitigations' -Value '1.0' -PropertyType 'STRING' -Confirm:$false
        }
    }
    else
    {
        Write-Verbose -Message 'Disabling Protections'
        if ($PSCmdlet.ShouldProcess('Disable cSpeculationControlFix', 'Set-TargetResource')) {
            Update-RegistryItem -Path $MemoryManagementPath -Name 'FeatureSettingsOverride' -Value 1 -PropertyType 'DWORD' -Confirm:$false
            Update-RegistryItem -Path $MemoryManagementPath -Name 'FeatureSettingsOverrideMask' -Value 1 -PropertyType 'DWORD' -Confirm:$false
        }
    }

    # Setting the global:DSCMachineStatus = 1 tells DSC that a reboot is required
    $global:DSCMachineStatus = 1
}

Function Test-TargetResource
{
    [CMDLetBinding()]
    [OutputType([bool])]
    param
    (
        # Parameter help description
        [Parameter(Mandatory = $true)]
        [ValidateSet('Enabled', 'Disabled')]
        [String]
        $Status
    )

    if ($Status -eq 'Enabled')
    {
        $FeatureSettingsOverrideEnabled = Test-RegistryItem -Path $MemoryManagementPath -Name 'FeatureSettingsOverride' -ExpectedValue 0
        Write-Verbose -Message ('FeatureSettingsOverride is {0}' -f $FeatureSettingsOverrideEnabled)

        $FeatureSettingsOverrideMaskEnabled = Test-RegistryItem -Path $MemoryManagementPath -Name 'FeatureSettingsOverrideMask' -ExpectedValue 1
        Write-Verbose -Message ('FeatureSettingsOverrideMask is {0}' -f $FeatureSettingsOverrideMaskEnabled)

        $MinVmVersionForCpuBasedMitigationsEnabled = Test-RegistryItem -Path $VirtualizationPath -Name 'MinVmVersionForCpuBasedMitigations' -ExpectedValue '1.0'
        Write-Verbose -Message ('MinVmVersionForCpuBasedMitigations is {0}' -f $MinVmVersionForCpuBasedMitigationsEnabled)

        $FixStatus = $FeatureSettingsOverrideEnabled -and $FeatureSettingsOverrideMaskEnabled -and $MinVmVersionForCpuBasedMitigationsEnabled
    }
    else
    {
        $FeatureSettingsOverrideEnabled = Test-RegistryItem -Path $MemoryManagementPath -Name 'FeatureSettingsOverride' -ExpectedValue 1
        Write-Verbose -Message ('FeatureSettingsOverride is {0}' -f $FeatureSettingsOverrideEnabled)

        $FeatureSettingsOverrideMaskEnabled = Test-RegistryItem -Path $MemoryManagementPath -Name 'FeatureSettingsOverrideMask' -ExpectedValue 1
        Write-Verbose -Message ('FeatureSettingsOverrideMask is {0}' -f $FeatureSettingsOverrideMaskEnabled)

        $FixStatus = $FeatureSettingsOverrideEnabled -and $FeatureSettingsOverrideMaskEnabled
    }

    Write-Verbose -Message ('cSpectreVariant2 should be {0} = {1}' -f $Status, $FixStatus)
    $FixStatus
}
