$MemoryManagementPath = 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management'
$VirtualizationPath = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Virtualization'

$SpeculationControlMitigations = @{
    SpectreVariant2Meltdown                                             = @{
        Enabled  = 0
        Disabled = 3
    }
    SpectreVariant2                                                     = @{
        Enabled  = 0
        Disabled = 3
    }
    AMDOnlySpectreVariant2                                              = @{
        Enabled  = 64
        Disabled = 3
    }
    SpeculativeStoreSpectreVariant2Meltdown                             = @{
        Enabled  = 8
        Disabled = 3
    }
    AMDOnlySpeculativeStoreSpectreVariant2                              = @{
        Enabled  = 72
        Disabled = 3
    }
    IntelTSXDataSamplingSpectreMeltdownSpeculativeStoreL1TerminalFaultWithHT = @{
        Enabled  = 72
        Disabled = 3
    }
    IntelTSXDataSamplingSpectreMeltdownSpeculativeStoreL1TerminalFaultWithoutHT = @{
        Enabled  = 8264
        Disabled = 3
    }
}

Function Get-TargetResource {
    [OutputType([System.Collections.Hashtable])]
    [CMDLetBinding()]
    param
    (
        # Status of the fixes (Enabled or Disabled)
        [Parameter(Mandatory = $true)]
        [ValidateSet('Enabled', 'Disabled')]
        [String]
        $Status,

        # Which fixes are to be applied
        [Parameter(Mandatory = $true)]
        [ValidateSet('SpectreVariant2Meltdown',
            'SpectreVariant2',
            'AMDOnlySpectreVariant2',
            'SpeculativeStoreSpectreVariant2Meltdown',
            'AMDOnlySpeculativeStoreSpectreVariant2',
            'IntelTSXDataSamplingSpectreMeltdownSpeculativeStoreL1TerminalFaultWithHT',
            'IntelTSXDataSamplingSpectreMeltdownSpeculativeStoreL1TerminalFaultWithoutHT')]
        [String]
        $Mitigations
    )

    # Test if the fixes are enabled
    $FeatureSettingsOverrideEnabled = Test-RegistryItem -Path $MemoryManagementPath -Name 'FeatureSettingsOverride' -ExpectedValue $SpeculationControlMitigations.$Mitigations.Enabled
    Write-Verbose -Message ('FeatureSettingsOverride is {0}' -f $FeatureSettingsOverrideEnabled)

    $FeatureSettingsOverrideMaskEnabled = Test-RegistryItem -Path $MemoryManagementPath -Name 'FeatureSettingsOverrideMask' -ExpectedValue '3'
    Write-Verbose -Message ('FeatureSettingsOverrideMask is {0}' -f $FeatureSettingsOverrideMaskEnabled)

    $MinVmVersionForCpuBasedMitigationsEnabled = Test-RegistryItem -Path $VirtualizationPath -Name 'MinVmVersionForCpuBasedMitigations' -ExpectedValue '1.0'
    Write-Verbose -Message ('MinVmVersionForCpuBasedMitigations is {0}' -f $MinVmVersionForCpuBasedMitigationsEnabled)

    if ($FeatureSettingsOverrideEnabled -and $FeatureSettingsOverrideMaskEnabled -and $MinVmVersionForCpuBasedMitigationsEnabled) {
        $Status = 'Enabled'
    }
    else {
        $Status = 'Disabled'
    }

    $getTargetResourceResult = @{
        Status = $Status
    }

    $getTargetResourceResult
}

Function Set-TargetResource {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '')]
    [CMDLetBinding(SupportsShouldProcess = $true)]
    param
    (
        # Status of the fixes (Enabled or Disabled)
        [Parameter(Mandatory = $true)]
        [ValidateSet('Enabled', 'Disabled')]
        [String]
        $Status,

        # Which fixes are to be applied
        [Parameter(Mandatory = $true)]
        [ValidateSet('SpectreVariant2Meltdown',
            'SpectreVariant2',
            'AMDOnlySpectreVariant2',
            'SpeculativeStoreSpectreVariant2Meltdown',
            'AMDOnlySpeculativeStoreSpectreVariant2',
            'IntelTSXDataSamplingSpectreMeltdownSpeculativeStoreL1TerminalFaultWithHT',
            'IntelTSXDataSamplingSpectreMeltdownSpeculativeStoreL1TerminalFaultWithoutHT')]
        [String]
        $Mitigations
    )

    Write-Verbose -Message "Setting Protections ($Mitigations) to $Status"
    if ($PSCmdlet.ShouldProcess('Enable cSpeculationControlFix', 'Set-TargetResource')) {
        Update-RegistryItem -Path $MemoryManagementPath -Name 'FeatureSettingsOverride' -Value $SpeculationControlMitigations.$Mitigations.$Status -PropertyType 'DWORD' -Confirm:$false
        Update-RegistryItem -Path $MemoryManagementPath -Name 'FeatureSettingsOverrideMask' -Value '3' -PropertyType 'DWORD' -Confirm:$false
        Update-RegistryItem -Path $VirtualizationPath -Name 'MinVmVersionForCpuBasedMitigations' -Value '1.0' -PropertyType 'STRING' -Confirm:$false
    }

    # Setting the global:DSCMachineStatus = 1 tells DSC that a reboot is required
    $global:DSCMachineStatus = 1
}

Function Test-TargetResource {
    [CMDLetBinding()]
    [OutputType([bool])]
    param
    (
        # Status of the fixes (Enabled or Disabled)
        [Parameter(Mandatory = $true)]
        [ValidateSet('Enabled', 'Disabled')]
        [String]
        $Status,

        # Which fixes are to be applied
        [Parameter(Mandatory = $true)]
        [ValidateSet('SpectreVariant2Meltdown',
            'SpectreVariant2',
            'AMDOnlySpectreVariant2',
            'SpeculativeStoreSpectreVariant2Meltdown',
            'AMDOnlySpeculativeStoreSpectreVariant2',
            'IntelTSXDataSamplingSpectreMeltdownSpeculativeStoreL1TerminalFaultWithHT',
            'IntelTSXDataSamplingSpectreMeltdownSpeculativeStoreL1TerminalFaultWithoutHT')]
        [String]
        $Mitigations
    )

    # Test if the fixes are enabled
    $FeatureSettingsOverrideSet = Test-RegistryItem -Path $MemoryManagementPath -Name 'FeatureSettingsOverride' -ExpectedValue $SpeculationControlMitigations.$Mitigations.Enabled
    Write-Verbose -Message ('FeatureSettingsOverride is {0}' -f $FeatureSettingsOverrideSet)

    $FeatureSettingsOverrideMaskEnabled = Test-RegistryItem -Path $MemoryManagementPath -Name 'FeatureSettingsOverrideMask' -ExpectedValue '3'
    Write-Verbose -Message ('FeatureSettingsOverrideMask is {0}' -f $FeatureSettingsOverrideMaskEnabled)

    $MinVmVersionForCpuBasedMitigationsEnabled = Test-RegistryItem -Path $VirtualizationPath -Name 'MinVmVersionForCpuBasedMitigations' -ExpectedValue '1.0'
    Write-Verbose -Message ('MinVmVersionForCpuBasedMitigations is {0}' -f $MinVmVersionForCpuBasedMitigationsEnabled)

    ($FeatureSettingsOverrideSet -and $FeatureSettingsOverrideMaskEnabled -and $MinVmVersionForCpuBasedMitigationsEnabled)
}
