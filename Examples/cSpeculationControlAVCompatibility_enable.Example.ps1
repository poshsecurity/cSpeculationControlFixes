Configuration EnablecSpeculationControlAVCompatibility
{
    Import-DscResource -Module cSpeculationControlFixes
    cSpeculationControlAVCompatibility enablecSpeculationControlAVCompatibility
    {
        Status = 'Enabled'
    }
}

EnablecSpeculationControlAVCompatibility -OutputPath C:\DSCConfiguration