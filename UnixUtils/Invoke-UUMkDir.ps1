<#
.SYNOPSIS
    Make directories
.DESCRIPTION
    Create the DIRECTORY(ies), if they do not already exist
.INPUTS
    System.String[]
.OUTPUTS
    None
.LINK
    https://linux.die.net/man/1/mkdir
#>
function Invoke-UUMkDir {
    [CmdletBinding()]
    param(
        [Parameter(
            Position = 0,
            ValueFromRemainingArguments = $true
        )]
        [string[]]$Directory,
        [Alias('p')]
        [switch]$Parents
    )

    if ($Directory.Count -eq 0) {
        Write-Error 'missing operand'
        continue
    }

    foreach ($item in $Directory) {
        if ([string]::IsNullOrWhiteSpace($item)) {
            Write-Error "cannot create directory '$item': No such file or directory"
            return
        }

        # check if directory already exists, or is a file
        if (Test-Path $item) {
            if (!$Parents -or (Test-Path $item -PathType Leaf)) {
                Write-Error "cannot create directory ‘$item’: File exists"
                return
            } else {
                continue
            }
        }

        # if parent does not exist and no -p switch provided, fail
        $parent = Split-Path $item -Parent
        if (!$Parents -and $parent -and !(Test-Path $parent)) {
            Write-Error "cannot create directory '$item': No such file or directory"
            continue
        }

        # either there is no parent to create, or user supplied -p to create them
        $parts = $parent.split("\\/".ToCharArray())
        $has_err = $false
        if ($parts.Count -gt 0) {
            $p = ""
            foreach ($part in $parts) {
                if ($p) {
                    $p = $p + "/" + $part
                } else {
                    $p = $part
                }

                if (Test-Path $p -PathType Leaf) {
                    Write-Error "cannot create directory ‘$item’: File exists"
                    $has_err = $true
                    break
                } elseif (!(Test-Path $p)) {
                    $null = New-Item -Name $p -ItemType Directory
                    Write-Verbose "created directory '$p'"
                }
            }
        }

        # avoid trying to create final directory if a parent failed
        if ($has_err) {
            continue
        }

        $null = New-Item -Name $item -ItemType Directory
        Write-Verbose "created directory '$item'"
    }
}
