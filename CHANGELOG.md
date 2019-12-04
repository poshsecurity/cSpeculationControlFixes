# cSpeculationControlFixes Release History

## 1.0 - 2019-12-04

* BREAKING CHANGES - Please review your current configurations.
* Added support for additional protections as listed in [https://support.microsoft.com/en-us/help/4072698/windows-server-speculative-execution-side-channel-vulnerabilities-prot](https://support.microsoft.com/en-us/help/4072698/windows-server-speculative-execution-side-channel-vulnerabilities-prot)
* cSpeculationControlMitigations replaces cSpectreVariant2 and cSpeculationControlFix, you will need to specify which mitigations you want to select based upon the above KB article.

## 0.3 - 2018-01-29

* Added support for forcing the AV Compatbility flag

## 0.2 - 2018-01-29

* Added support for disabling Spectre Variant 2 Fixes

## 0.1.1 - 2018-01-29

* Minor non-code fixes

## 0.1 - 2018-01-14

* Initial version supporting enabling and disabling the Speculation Control Fixes in Windows
