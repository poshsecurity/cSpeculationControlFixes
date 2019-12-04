Configuration cSpeculationControlMitigations_SpeculativeStoreSpectreVariant2Meltdown
{
    Import-DscResource -ModuleName cSpeculationControlFixes
    cSpeculationControlMitigations cSpeculationControlMitigations_SpeculativeStoreSpectreVariant2Meltdown
    {
        Status      = 'Enabled'
        Mitigations = 'SpeculativeStoreSpectreVariant2Meltdown'
    }
}

cSpeculationControlMitigations_SpeculativeStoreSpectreVariant2Meltdown -OutputPath C:\DSCConfiguration