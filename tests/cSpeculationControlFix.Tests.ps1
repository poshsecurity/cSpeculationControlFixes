$script:ModuleName = 'cSpeculationControlFixes'

# Removes all versions of the module from the session before importing
Get-Module $ModuleName | Remove-Module

$ModuleBase = Split-Path -Parent $MyInvocation.MyCommand.Path

# For tests in .\Tests subdirectory
if ((Split-Path $ModuleBase -Leaf) -eq 'Tests') {
    $ModuleBase = Split-Path $ModuleBase -Parent
}

## this variable is for the VSTS tasks and is to be used for refernecing any mock artifacts
$Env:ModuleBase = $ModuleBase

Import-Module $ModuleBase\$ModuleName.psd1 -PassThru -ErrorAction Stop | Out-Null

Describe "Basic unit tests of cSpeculationControlFix" -Tags Build , Unit {
    $object = New-Object -TypeName cSpeculationControlFix

    Context 'Test()' {
        It 'returns a bool when test() is called' {
            $object.test() | should -BeOfType System.Boolean
        }

        It 'returns $true if status is enabled, and registry keys are set correctly' {
            Mock -CommandName Test-RegistryItem -MockWith {
                return $true
            }

            $object.status = 'Enabled'
            $object.test() | should be $true
        }

        It 'returns $false if status is enabled, and registry keys are set incorrectly' {
            Mock -CommandName Test-RegistryItem -MockWith {
                return $false
            }

            $object.status = 'Enabled'
            $object.test() | should be $false
        }

        It 'returns $true if status is disabled, and registry keys are set correctly' {
            Mock -CommandName Test-RegistryItem -MockWith {
                return $false
            }

            $object.status = 'Disabled'
            $object.test() | should be $true
        }

        It 'returns $false if status is enabled, and registry keys are set incorrectly' {
            Mock -CommandName Test-RegistryItem -MockWith {
                return $true
            }

            $object.status = 'Disabled'
            $object.test() | should be $false
        }
    }

    Context 'Get()' {
        It 'returns a cSpeculationControlFix when get() is called' {
            $object.Get().GetType().Name | should be 'cSpeculationControlFix'
        }

        It 'returns Enabled if registry keys are set to enable the controlls correctly and get() is called' {
            Mock -CommandName Test-RegistryItem -MockWith {
                return $true
            }

            $object.get().status | should be 'Enabled'
        }

        It 'returns Enabled if registry keys are set to disable the controlls correctly and get() is called' {
            Mock -CommandName Test-RegistryItem -MockWith {
                return $false
            }

            $object.get().status | should be 'Disabled'
        }
    }

    Context 'Set()' {
        Mock -CommandName Update-RegistryItem -MockWith {}

        It 'returns Null when set() is called' {
            $object.set() | should be $null
        }

        It 'calls Update-RegistryItem 3 times if it needs to enable the fixes' {
            $Object.Status = 'Enabled'
            $object.set() | Assert-MockCalled -CommandName 'Update-RegistryItem' -Times 3
        }

        It 'calls Update-RegistryItem 2 times if it needs to disable the fixes' {
            $Object.Status = 'Disabled'
            $object.set() | Assert-MockCalled -CommandName 'Update-RegistryItem' -Times 2
        }
    }
}
