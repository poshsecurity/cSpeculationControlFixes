# cSpeculationControlFixes

![Build Status](https://poshsecurity.visualstudio.com/_apis/public/build/definitions/3d8291e9-888c-4ff2-8223-f7eefdabecb7/30/badge)

## Description

PowerShell DSC for enabling Speculation Control fixes on Windows. Authored by Kieran Jacobsen

The Microsoft KB [Windows Server guidance to protect against speculative execution side-channel vulnerabilities](https://support.microsoft.com/en-us/help/4072698/windows-server-speculative-execution-side-channel-vulnerabilities-prot) provides a number of options on what speculative controls you can implement, use the table below to map the titles of each mitgation in the KB with the mitigation names in the DSC module.

| Title in KB | Mitigation in DSC |
| --- | --- |
| Manage mitigations for CVE-2017-5715 (Spectre Variant 2) and CVE-2017-5754 (Meltdown) |SpectreVariant2Meltdown |
| Manage the mitigation for CVE-2017-5715 (Spectre Variant 2) | SpectreVariant2 |
| AMD processors only: Enable the full mitigation for CVE-2017-5715 (Spectre Variant 2) | AMDOnlySpectreVariant2 |
| Manage mitigations for CVE-2018-3639 (Speculative Store Bypass), CVE-2017-5715 (Spectre Variant 2), and CVE-2017-5754 (Meltdown) | SpeculativeStoreSpectreVariant2Meltdown |
| AMD processors only: Enable the full mitigation for CVE-2017-5715 (Spectre Variant 2) and CVE 2018-3639 (Speculative Store Bypass) | AMDOnlySpeculativeStoreSpectreVariant2 |
|Manage Intel® Transactional Synchronization Extensions (Intel® TSX) Transaction Asynchronous Abort vulnerability (CVE-2019-11135) and Microarchitectural Data Sampling (CVE-2018-11091, CVE-2018-12126, CVE-2018-12127, CVE-2018-12130) along with Spectre [ CVE-2017-5753 & CVE-2017-5715 ] and Meltdown [ CVE-2017-5754 ] variants, including Speculative Store Bypass Disable (SSBD) [ CVE-2018-3639 ] as well as L1 Terminal Fault (L1TF) [ CVE-2018-3615, CVE-2018-3620, and CVE-2018-3646 ] **without disabling Hyper-Threading**  | IntelTSXDataSamplingSpectreMeltdownSpeculativeStoreL1TerminalFaultWithHT |
|Manage Intel® Transactional Synchronization Extensions (Intel® TSX) Transaction Asynchronous Abort vulnerability (CVE-2019-11135) and Microarchitectural Data Sampling (CVE-2018-11091, CVE-2018-12126, CVE-2018-12127, CVE-2018-12130) along with Spectre [ CVE-2017-5753 & CVE-2017-5715 ] and Meltdown [ CVE-2017-5754 ] variants, including Speculative Store Bypass Disable (SSBD) [ CVE-2018-3639 ] as well as L1 Terminal Fault (L1TF) [ CVE-2018-3615, CVE-2018-3620, and CVE-2018-3646 ] **with Hyper-Threading disabled**| IntelTSXDataSamplingSpectreMeltdownSpeculativeStoreL1TerminalFaultWithoutHT |

## Installing

The easiest way to get cSpeculationControlFixes is using the [PowerShell Gallery](https://powershellgallery.com/packages/cSpeculationControlFixes/)!

### Inspecting the module

Best practice is that you inspect modules prior to installing them. You can do this by saving the module to a local path:

``` PowerShell
PS> Save-Module -Name cSpeculationControlFixes -Path <path>
```

### Installing the module

Once you trust a module, you can install it using:

``` PowerShell
PS> Install-Module -Name cSpeculationControlFixes
```

### Updating cSpeculationControlFixes

Once installed from the PowerShell Gallery, you can update it using:

``` PowerShell
PS> Update-Module -Name cSpeculationControlFixes
```

### Removing cSpeculationControlFixes

To remove cSpeculationControlFixes:

``` PowerShell
PS> Uninstall-Module -Name cSpeculationControlFixes
```

## Contributing to cSpeculationControlFixes

Interested in contributing? Read how you can [Contribute](contributing.md) to cSpeculationControlFixes

This project is maintains a [Code of Conduct](code-of-conduct.md) that establishes how the project is governed and how everyone involved is expected to behave. You can report unacceptable behavior to [code@poshsecurity.com](mailto:code@poshsecurity.com).

## Release History

A detailed release history is contained in the [Change Log](CHANGELOG.md).

## License

cSpeculationControlFixes is provided under the [MIT license](LICENSE.md).
