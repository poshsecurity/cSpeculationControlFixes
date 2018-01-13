enum Status
{
    Enabled
    Disabled
}

#[DscResource()]
class cSpeculationControlFix
{
    [DscProperty(Key)]
    [Status] $Status

    [DscProperty(NotConfigurable)]
    Hidden [string] $MemoryManagementPath = 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management'

    [DscProperty(NotConfigurable)]
    Hidden [string] $VirtualizationPath   = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Virtualization'

    [cSpeculationControlFix] Get()
    {
        # Test if the fixes are enabled
        $FeatureSettingsOverrideEnabled = Test-RegistryItem -Path $this.MemoryManagementPath -Name 'FeatureSettingsOverride' -ExpectedValue 0
        $FeatureSettingsOverrideMaskEnabled = Test-RegistryItem -Path $this.MemoryManagementPath -Name 'FeatureSettingsOverrideMask' -ExpectedValue 3
        $MinVmVersionForCpuBasedMitigationsEnabled = Test-RegistryItem -Path $this.VirtualizationPath -Name 'MinVmVersionForCpuBasedMitigations' -ExpectedValue '1.0'

        if ($FeatureSettingsOverrideEnabled -and $FeatureSettingsOverrideMaskEnabled -and $MinVmVersionForCpuBasedMitigationsEnabled)
        {
            $this.Status = [Status]::Enabled
        }
        else
        {
            $this.Status = [Status]::Disabled
        }
        return $this
    }

    [void] Set()
    {
        if ($this.Status -eq [Status]::Enabled)
        {
            Update-RegistryItem -Path $this.MemoryManagementPath -Name 'FeatureSettingsOverride' -Value 0 -PropertyType 'DWORD' -Confirm:$false
            Update-RegistryItem -Path $this.MemoryManagementPath -Name 'FeatureSettingsOverrideMask' -Value 3 -PropertyType 'DWORD' -Confirm:$false
            Update-RegistryItem -Path $this.VirtualizationPath -Name 'MinVmVersionForCpuBasedMitigations' -Value '1.0' -PropertyType 'STRING' -Confirm:$false
        }
        else
        {
            Update-RegistryItem -Path $this.MemoryManagementPath -Name 'FeatureSettingsOverride' -Value 3 -PropertyType 'DWORD' -Confirm:$false
            Update-RegistryItem -Path $this.MemoryManagementPath -Name 'FeatureSettingsOverrideMask' -Value 3 -PropertyType 'DWORD' -Confirm:$false
        }

        # Setting the global:DSCMachineStatus = 1 tells DSC that a reboot is required
        $global:DSCMachineStatus = 1
    }

    [bool] Test()
    {
        # Test if the fixes are enabled
        $FeatureSettingsOverrideEnabled = Test-RegistryItem -Path $this.MemoryManagementPath -Name 'FeatureSettingsOverride' -ExpectedValue 0
        $FeatureSettingsOverrideMaskEnabled = Test-RegistryItem -Path $this.MemoryManagementPath -Name 'FeatureSettingsOverrideMask' -ExpectedValue 3
        $MinVmVersionForCpuBasedMitigationsEnabled = Test-RegistryItem -Path $this.VirtualizationPath -Name 'MinVmVersionForCpuBasedMitigations' -ExpectedValue '1.0'

        if ($this.Status -eq [Status]::Enabled)
        {
            return ($FeatureSettingsOverrideEnabled -and $FeatureSettingsOverrideMaskEnabled -and $MinVmVersionForCpuBasedMitigationsEnabled)
        }
        else
        {
            return (-not ($FeatureSettingsOverrideEnabled -or $FeatureSettingsOverrideMaskEnabled -or $MinVmVersionForCpuBasedMitigationsEnabled))
        }
    }
}
