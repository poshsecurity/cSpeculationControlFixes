$script:ModuleName = 'cSpeculationControlFixes'
$script:DSCResourceName = 'cSpeculationControlAVCompatibility'

# Removes all versions of the module from the session before importing
Get-Module $ModuleName | Remove-Module

$ModuleBase = Split-Path -Parent $MyInvocation.MyCommand.Path

# For tests in .\Tests subdirectory
if ((Split-Path $ModuleBase -Leaf) -eq 'Tests') {
    $ModuleBase = Split-Path $ModuleBase -Parent
}

## this variable is for the VSTS tasks and is to be used for refernecing any mock artifacts
$Env:ModuleBase = $ModuleBase

# Load the Root module (we have one in this case)
Import-Module $ModuleBase\$ModuleName.psd1 -PassThru -ErrorAction Stop -Force | Out-Null

# Load the Resource
Import-Module "$ModuleBase\DSCResources\$DSCResourceName\$DSCResourceName.psm1" -PassThru -ErrorAction Stop -Force | Out-Null

InModuleScope -ModuleName $DSCResourceName {
    Describe "Basic unit tests of cSpeculationControlAVCompatibility" -Tags Build , Unit {
        Context 'Get-TargetResource' {
            It 'returns a System.Collections.Hashtable (1)' {
                Mock -CommandName Test-RegistryItem -MockWith {
                    return $false
                }
                Get-TargetResource -Status 'Enabled' | should -BeOfType System.Collections.Hashtable
            }

            It 'returns a System.Collections.Hashtable (2)' {
                Mock -CommandName Test-RegistryItem -MockWith {
                    return $true
                }
                Get-TargetResource -Status 'Enabled' | should -BeOfType System.Collections.Hashtable
            }

            It 'returns a System.Collections.Hashtable (3)' {
                Mock -CommandName Test-RegistryItem -MockWith {
                    return $false
                }
                Get-TargetResource -Status 'Disabled' | should -BeOfType System.Collections.Hashtable
            }

            It 'returns a System.Collections.Hashtable (4)' {
                Mock -CommandName Test-RegistryItem -MockWith {
                    return $true
                }
                Get-TargetResource -Status 'Disabled' | should -BeOfType System.Collections.Hashtable
            }

            It 'returns status == Enabled if AVCompatibility Registry keys are enabled' {
                Mock -CommandName Test-RegistryItem -MockWith {
                    return $true
                }
                (Get-TargetResource -Status 'Enabled').status | should be 'Enabled'
            }

            It 'returns status == Disabled if AVCompatibility Registry keys are disabled' {
                Mock -CommandName Test-RegistryItem -MockWith {
                    return $false
                }
                (Get-TargetResource -Status 'Disabled').status | should be 'Disabled'
            }
        }

        Context 'Test-TargetResource' {
            It 'returns a bool (1)' {
                Mock -CommandName Test-RegistryItem -MockWith {
                    return $false
                }
                Test-TargetResource -Status 'Enabled' | should -BeOfType System.Boolean
            }

            It 'returns a bool (2)' {
                Mock -CommandName Test-RegistryItem -MockWith {
                    return $true
                }
                Test-TargetResource -Status 'Enabled' | should -BeOfType System.Boolean
            }

            It 'returns a bool (3)' {
                Mock -CommandName Test-RegistryItem -MockWith {
                    return $false
                }
                Test-TargetResource -Status 'Disabled' | should -BeOfType System.Boolean
            }

            It 'returns a bool (4)' {
                Mock -CommandName Test-RegistryItem -MockWith {
                    return $true
                }
                Test-TargetResource -Status 'Disabled' | should -BeOfType System.Boolean
            }

            It 'returns $true if Status == Enabled and AVCompatibility Registry keys are enabled' {
                Mock -CommandName Test-RegistryItem -MockWith {
                    return $true
                }
                Test-TargetResource -Status 'Enabled' | should be $true
            }

            It 'returns $false if Status == Enabled and AVCompatibility Registry keys are not enabled' {
                Mock -CommandName Test-RegistryItem -MockWith {
                    return $false
                }
                Test-TargetResource -Status 'Enabled' | should be $false
            }

            It 'returns $false if Status == Disabled and AVCompatibility Registry keys are enabled' {
                Mock -CommandName Test-RegistryItem -MockWith {
                    return $true
                }
                Test-TargetResource -Status 'Disabled' | should be $true
            }

            It 'returns $true if Status == Disabled and AVCompatibility Registry keys are not enabled' {
                Mock -CommandName Test-RegistryItem -MockWith {
                    return $false
                }
                Test-TargetResource -Status 'Disabled' | should be $false
            }
        }

        Context 'Set-TargetResource' {
            Mock -CommandName Update-RegistryItem -MockWith {}
            Mock -CommandName Remove-RegistryItem -MockWith {}

            It 'returns Null when set() is called' {
                Set-TargetResource -Status 'Enabled' | should be $null
            }

            It 'calls Update-RegistryItem if it needs to enable the fixes' {
                Set-TargetResource -Status 'Enabled' | Assert-MockCalled -CommandName 'Update-RegistryItem' -Times 1 -Scope It
            }

            It 'calls Remove-RegistryItem if it needs to enable the fixes' {
                Set-TargetResource -Status 'Disabled' | Assert-MockCalled -CommandName 'Remove-RegistryItem' -Times 1 -Scope It
            }
        }
    }
}
