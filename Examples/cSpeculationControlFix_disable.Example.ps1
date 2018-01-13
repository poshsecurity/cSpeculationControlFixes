Configuration EnableSpeculationControl
{
    Import-DscResource -Module ..\cSpeculationControlFixes
    cSpeculationControlFix enableSpeculationControlFix
    {
        Status = 'Disabled'
    }
}

EnableSpeculationControl -OutputPath C:\DSCConfiguration