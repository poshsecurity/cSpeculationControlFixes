Configuration DisableSpeculationControl
{
    Import-DscResource -Module cSpeculationControlFixes
    cSpectreVariant2 disableSpectreVariant2
    {
        Status = 'Disabled'
    }
}

EnableSpeculationControl -OutputPath C:\DSCConfiguration