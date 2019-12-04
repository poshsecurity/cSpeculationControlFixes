Configuration cSpeculationControlMitigations_AMDOnlySpectreVariant2
{
    Import-DscResource -ModuleName cSpeculationControlFixes
    cSpeculationControlMitigations cSpeculationControlMitigations_AMDOnlySpectreVariant2
    {
        Status      = 'Enabled'
        Mitigations = 'AMDOnlySpectreVariant2'
    }
}

cSpeculationControlMitigations_AMDOnlySpectreVariant2 -OutputPath C:\DSCConfiguration