# Taken from http://overpoweredshell.com/Working-with-Plaster/

$functionFolders = @('functions', 'internal', 'classes')
ForEach ($folder in $functionFolders)
{
    $folderPath = Join-Path -Path $PSScriptRoot -ChildPath $folder
    If (Test-Path -Path $folderPath)
    {
        Write-Verbose -Message "Importing from $folder"
        $functions = Get-ChildItem -Path $folderPath -Filter '*.ps1'
        ForEach ($function in $functions)
        {
            Write-Verbose -Message "  Importing $($function.BaseName)"
            . $($function.FullName)
        }
    }
}

$PublicFunctionsPath = Join-Path -path $PSScriptRoot -ChildPath 'functions'
if (Test-Path -Path $PublicFunctionsPath)
{
    $publicFunctions = (Get-ChildItem -Path $PublicFunctionsPath -Filter '*.ps1').BaseName
    Export-ModuleMember -Function $publicFunctions
}