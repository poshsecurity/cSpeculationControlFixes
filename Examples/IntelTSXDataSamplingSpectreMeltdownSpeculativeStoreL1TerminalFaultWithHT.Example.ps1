Configuration cSpeculationControlMitigations_IntelTSXDataSamplingSpectreMeltdownSpeculativeStoreL1TerminalFaultWithHT
{
    Import-DscResource -ModuleName cSpeculationControlFixes
    cSpeculationControlMitigations cSpeculationControlMitigations_IntelTSXDataSamplingSpectreMeltdownSpeculativeStoreL1TerminalFaultWithHT
    {
        Status      = 'Enabled'
        Mitigations = 'IntelTSXDataSamplingSpectreMeltdownSpeculativeStoreL1TerminalFaultWithHT'
    }
}

cSpeculationControlMitigations_IntelTSXDataSamplingSpectreMeltdownSpeculativeStoreL1TerminalFaultWithHT -OutputPath C:\DSCConfiguration