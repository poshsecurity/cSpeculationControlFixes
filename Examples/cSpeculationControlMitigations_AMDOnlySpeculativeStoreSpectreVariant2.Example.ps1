Configuration cSpeculationControlMitigations_AMDOnlySpeculativeStoreSpectreVariant2
{
    Import-DscResource -ModuleName cSpeculationControlFixes
    cSpeculationControlMitigations cSpeculationControlMitigations_AMDOnlySpeculativeStoreSpectreVariant2
    {
        Status      = 'Enabled'
        Mitigations = 'AMDOnlySpeculativeStoreSpectreVariant2'
    }
}

cSpeculationControlMitigations_AMDOnlySpeculativeStoreSpectreVariant2 -OutputPath C:\DSCConfiguration