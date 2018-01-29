Configuration EnableSpeculationControl
{
    Import-DscResource -Module cSpeculationControlFixes
    cSpectreVariant2 enableSpectreVariant2Fix
    {
        Status = 'Enabled'
    }
}

EnableSpeculationControl -OutputPath C:\DSCConfiguration