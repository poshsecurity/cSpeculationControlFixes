# cSpeculationControlFixes

![Build Status](https://poshsecurity.visualstudio.com/_apis/public/build/definitions/3d8291e9-888c-4ff2-8223-f7eefdabecb7/30/badge)

## Description

PowerShell DSC for enabling Speculation Control fixes on Windows. This has been tested on Windows 10 and Windows Server 2016.

Authored by Kieran Jacobsen

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
