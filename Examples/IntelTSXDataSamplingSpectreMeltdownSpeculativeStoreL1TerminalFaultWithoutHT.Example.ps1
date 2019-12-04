Configuration cSpeculationControlMitigations_IntelTSXDataSamplingSpectreMeltdownSpeculativeStoreL1TerminalFaultWithoutHT
{
    Import-DscResource -ModuleName cSpeculationControlFixes
    cSpeculationControlMitigations cSpeculationControlMitigations_IntelTSXDataSamplingSpectreMeltdownSpeculativeStoreL1TerminalFaultWithoutHT
    {
        Status      = 'Enabled'
        Mitigations = 'IntelTSXDataSamplingSpectreMeltdownSpeculativeStoreL1TerminalFaultWithoutHT'
    }
}

cSpeculationControlMitigations_IntelTSXDataSamplingSpectreMeltdownSpeculativeStoreL1TerminalFaultWithoutHT -OutputPath C:\DSCConfiguration