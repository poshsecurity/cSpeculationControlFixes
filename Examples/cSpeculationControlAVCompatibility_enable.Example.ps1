Configuration EnablecSpeculationControlAVCompatibility
{
    Import-DscResource -ModuleName cSpeculationControlFixes
    cSpeculationControlAVCompatibility enablecSpeculationControlAVCompatibility
    {
        Status = 'Enabled'
    }
}

EnablecSpeculationControlAVCompatibility -OutputPath C:\DSCConfiguration