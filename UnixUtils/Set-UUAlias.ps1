<#
.SYNOPSIS
    Define or display aliases.
.DESCRIPTION
    The alias utility shall create or redefine alias definitions or
    write the values of existing alias definitions to standard
    output. An alias definition provides a string value that shall
    replace a command name when it is encountered; see Section 2.3.1,
    Alias Substitution.

    An alias definition shall affect the current shell execution
    environment and the execution environments of the subshells of
    the current shell. When used as specified by this volume of
    POSIX.1‐2017, the alias definition shall not affect the parent
    process of the current shell nor any utility environment invoked
    by the shell; see Section 2.12, Shell Execution Environment.
.INPUTS
    System.String[]
.OUTPUTS
    None
.LINK
    https://man7.org/linux/man-pages/man1/alias.1p.html
#>
function Set-UUAlias {
    [CmdletBinding()]
    param(
        [Parameter(
            Position=0,
            ValueFromRemainingArguments = $true
        )]
        [string[]]$Expression
    )

    $alias_prefix = "__alias_"

    if (!$Expression) {
        $aliases = Get-Alias 2>$null | ?{ $_.Definition.StartsWith($alias_prefix) }
        foreach ($a in $aliases) {
            $def = Get-UUAliasDefinition $a $true
            Write-Output "$($a.Name)=$def"
            continue
        }
    }

    foreach ($item in $Expression) {
        if (!$item.Contains('=')) {
            try {
                $a = Get-Alias "$item" 2>$null
            } catch {
                continue
            }
            if (!$a) {
                continue
            }

            $def = Get-UUAliasDefinition $a $true
            Write-Output "$($a.Name)=$def"
            continue
        }

        $splits = $item -split '=', 2
        $key = $splits[0]
        $value = $splits[1]

        if (!$key -or !$value) {
            Write-Error "name is required"
            continue
        }
        if (!($key -match '^[\w-]+$')) {
            Write-Error "name must only contain alphanumeric characters, '-', or '_'"
            continue
        }

        $fn_name = "$alias_prefix$key"
        New-Item -Path function:\ -Name "global:$fn_name" -Value "& $value `@args" -Force | Out-Null
        Set-Alias -Name $key -Value $fn_name -Scope Global -Option AllScope
    }
}
