Configuration EnableSpeculationControl
{
    Import-DscResource -Module cSpeculationControlFixes
    cSpeculationControlFix enableSpeculationControlFix
    {
        Status = 'Enabled'
    }
}
EnableSpeculationControl -OutputPath C:\DSCConfiguration
#Start-DSCConfiguration -Wait -Force -Verbose -Path C:\DSCConfiguration