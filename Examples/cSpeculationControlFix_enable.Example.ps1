Configuration EnableSpeculationControl
{
    Import-DscResource -Module cSpeculationControlFixes
    cSpeculationControlFix enableSpeculationControlFix
    {
        Status = 'Enabled'
    }
}

EnableSpeculationControl -OutputPath C:\DSCConfiguration