Configuration cSpeculationControlMitigations_SpectreVariant2
{
    Import-DscResource -ModuleName cSpeculationControlFixes
    cSpeculationControlMitigations cSpeculationControlMitigations_SpectreVariant2
    {
        Status      = 'Enabled'
        Mitigations = 'SpectreVariant2'
    }
}

cSpeculationControlMitigations_SpectreVariant2 -OutputPath C:\DSCConfiguration