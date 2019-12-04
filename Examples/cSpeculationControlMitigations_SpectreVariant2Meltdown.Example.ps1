Configuration cSpeculationControlMitigations_SpectreVariant2Meltdown
{
    Import-DscResource -ModuleName cSpeculationControlFixes
    cSpeculationControlMitigations cSpeculationControlMitigations_SpectreVariant2Meltdown
    {
        Status      = 'Enabled'
        Mitigations = 'SpectreVariant2Meltdown'
    }
}

cSpeculationControlMitigations_SpectreVariant2Meltdown -OutputPath C:\DSCConfiguration