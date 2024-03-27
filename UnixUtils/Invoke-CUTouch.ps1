<#
.SYNOPSIS
    Update the access and modification times of each FILE to the current time.
.DESCRIPTION
    Update the access and modification times of each FILE to the current time.

    A FILE argument that does not exist is created empty, unless -c or -h is supplied.
.INPUTS
    System.String[]
.OUTPUTS
    None
.LINK
    https://www.gnu.org/software/coreutils/manual/html_node/touch-invocation.html
#>
function Invoke-CUTouch {
    [CmdletBinding()]
    param(
        [Parameter(
            Position = 0,
            ValueFromRemainingArguments = $true
        )]
        [string[]]$File,
        [Alias('a')]
        [switch]$AccessOnly,
        [Alias('c')]
        [switch]$NoCreate,
        [ValidateScript(
            { $_ -is [DateTime] -or $_ -is [TimeSpan] },
            ErrorMessage = "Argument must be of type ``System.DateTime`` or ``System.TimeSpan``"
        )]
        [Alias('d')]
        $Date,
        [switch]$f,
        [Alias('h')]
        [switch]$NoDereference,
        [Alias('m')]
        [switch]$ModifyOnly,
        [Alias('r')]
        [System.IO.FileInfo]$Reference,
        [datetime]$t,
        [ValidateSet('access', 'atime', 'use', 'modify', 'mtime')]
        [string]$Time
    )

    if ($File.Count -eq 0) {
        Write-Error 'missing file operand'
        continue
    }

    # validate only one timestamp source is used
    $t_sources = 0
    if ($t) {
        $t_sources += 1
    }
    if ($Date) {
        $t_sources += 1
    }
    if ($Reference) {
        # -d can be used with -r
        if (!$Date) {
            $t_sources += 1
        }
    }
    if ($t_sources -gt 1) {
        Write-Error 'cannot specify times from more than one source'
        continue
    }

    $use_atime = $AccessOnly -or $Time -eq 'atime' -or $Time -eq 'access' -or $Time -eq 'use'
    $use_mtime = $ModifyOnly -or $Time -eq 'mtime' -or $Time -eq 'modify'

    foreach ($item in $File) {
        if ($item -eq '-') {
            Write-Warning 'stdin (-) file argument is not supported'
            continue
        }

        # resolve timestamp based on options
        $atime = Get-Date
        $mtime = $atime
        if ($t) {
            $atime = $t
            $mtime = $t
        }
        elseif ($Date) {
            # if -d is used and is a datetime, -r is ignored
            if ($Date -is [DateTime]) {
                $atime = $Date
                $mtime = $Date
            }
            # resolve relative time based on reference times if provided
            else {
                if ($Reference) {
                    # ensure reference exists
                    $err = $null
                    $attrs = Get-Item $Reference -ErrorVariable err 2>$null
                    if ($err -or !$attrs) {
                        Write-Error (Format-UUError "failed to get attributes of '$Reference'" $err)
                        continue
                    }
                    $atime = $attrs.LastAccessTime
                    $mtime = $attrs.LastWriteTime
                }
                # use -d timespan offset
                $atime += $Date
                $mtime += $Date
            }
        }

        # resolve link if -h not set -- this may result in null/empty path
        $path = $item
        if (!$NoDereference -and (Test-Path $path)) {
            $path = (Get-Item $path 2>$null).ResolvedTarget
        }
        if (!$path) {
            Write-Error "cannot touch '$item': Path is an empty string"
            continue
        }

        if (Test-Path $path) {
            # check which timestamp(s) to modify
            if ($use_atime) {
                (Get-ChildItem $item).LastWriteTime = $ts
            }
            if ($use_mtime) {
                (Get-ChildItem $item).LastAccessTime = $ts
            }
        }
        # create if option not set
        elseif (!$NoCreate) {
            New-Item $path -ItemType File -ErrorVariable err 2>$null | Out-Null
            if ($err) {
                Write-Error (Format-UUError "cannot touch '$item'" $err)
            }
        }
    }
}
