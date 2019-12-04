$QualityCompatPath = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\QualityCompat'

Function Get-TargetResource {
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
    $QualityCompatEnabled = Test-RegistryItem -Path $QualityCompatPath -Name 'cadca5fe-87d3-4b96-b7fb-a231484277cc' -ExpectedValue 0
    Write-Verbose -Message ('AV QualityCompat Flag is {0}' -f $QualityCompatEnabled)

    if ($QualityCompatEnabled) {
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
        # Parameter help description
        [Parameter(Mandatory = $true)]
        [ValidateSet('Enabled', 'Disabled')]
        [String]
        $Status
    )

    if ($Status -eq 'Enabled') {
        Write-Verbose -Message 'Enabling AV Compatibility'
        if ($PSCmdlet.ShouldProcess('Enable cSpeculationControlFix', 'Set-TargetResource')) {
            Update-RegistryItem -Path $QualityCompatPath -Name 'cadca5fe-87d3-4b96-b7fb-a231484277cc' -Value 0 -PropertyType 'DWORD' -Confirm:$false
        }
    }
    else {
        Write-Verbose -Message 'Disabling AV Compatibility'
        if ($PSCmdlet.ShouldProcess('Disable cSpeculationControlFix', 'Set-TargetResource')) {
            Remove-RegistryItem -Path $QualityCompatPath -Name 'cadca5fe-87d3-4b96-b7fb-a231484277cc'
        }
    }

    # Setting the global:DSCMachineStatus = 1 tells DSC that a reboot is required
    $global:DSCMachineStatus = 1
}

Function Test-TargetResource {
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

    $QualityCompatEnabled = Test-RegistryItem -Path $QualityCompatPath -Name 'cadca5fe-87d3-4b96-b7fb-a231484277cc' -ExpectedValue 0
    Write-Verbose -Message ('AV QualityCompat Flag is {0}' -f $QualityCompatEnabled)

    $QualityCompatEnabled
}
