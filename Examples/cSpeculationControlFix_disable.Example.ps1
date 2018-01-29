Configuration DisableSpeculationControl
{
    Import-DscResource -Module cSpeculationControlFixes
    cSpeculationControlFix DisableSpeculationControlFix
    {
        Status = 'Disabled'
    }
}

EnableSpeculationControl -OutputPath C:\DSCConfiguration