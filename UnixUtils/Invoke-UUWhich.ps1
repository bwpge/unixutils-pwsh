<#
.SYNOPSIS
    Locate a command.
.DESCRIPTION
    Returns the pathnames of the files (or links) which would be executed in
    the current environment, had its arguments been given as commands in a
    strictly POSIX-conformant shell. It does this by searching the PATH for
    executable files matching the names of the arguments. It does not
    canonicalize path names.
.INPUTS
    System.String[]
.OUTPUTS
    System.String[]
#>
function Invoke-UUWhich {
    [CmdletBinding()]
    param(
        [Parameter(
            Position = 0,
            ValueFromRemainingArguments = $true
        )]
        [string[]]$File,
        [Alias('a')]
        [switch]$All
    )

    foreach ($f in $File) {
        $output = [System.Collections.Generic.List[string]]::new()
        foreach ($cmd in (Get-Command $f -All:$All -EA 0)) {
            $s = ""

            switch ($cmd.CommandType) {
                'Alias'{
                    $s = "${f}: aliased to $(Get-UUAliasDefinition $cmd)"
                }
                {$_ -eq 'Application' -or $_ -eq 'ExternalScript'} {
                    $s = "$($cmd.Source)"
                }
                'Function' {
                    $s = "function $($cmd.Name) {`n$($cmd.Definition)`n}"
                }
                'Cmdlet'  {
                    $s = "${f}: cmdlet"
                    if ($cmd.Source) {
                        $s += " in $($cmd.Source)"
                    }
                }
                default {
                    $s = "$($cmd.Name) ($($cmd.CommandType))"
                }
            }

            $output.Add("$s")
        }

        return ,$output
    }
}
