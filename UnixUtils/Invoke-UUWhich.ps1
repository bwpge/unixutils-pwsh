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

        # find command that will be executed by shell first
        $cmd = Get-Command $f -ErrorAction SilentlyContinue
        if ($cmd -eq $null) {
            continue
        }

        $s = $cmd.Name
        if ($cmd.CommandType -eq 'Alias') {
            $s = "${f}: aliased to $(Get-UUAliasDefinition $cmd)"
        } elseif ($cmd.CommandType -eq 'Application') {
            $s = "$($cmd.Source)"
        } elseif ($cmd.CommandType -eq 'Function') {
            $s = "function $($cmd.Name) {`n$($cmd.Definition)`n}"
        } else {
            $s = "$($cmd.Name) ($($cmd.CommandType))"
        }
        $output.Add("$s")

        # handle -a option
        if ($All) {
            $exts = $env:PATHEXT.Split(";", [System.StringSplitOptions]::RemoveEmptyEntries) | %{ $_.ToLower() }
            $paths = $env:PATH.Split(";", [System.StringSplitOptions]::RemoveEmptyEntries)
            foreach ($p in $paths) {
                if (!(Test-Path "$p" -PathType Container)) {
                    continue
                }
                $entries = Get-ChildItem -Filter "$f.*" -File "$p" | ?{ $_.Extension -in $exts }
                foreach ($entry in $entries) {
                    $ext = $entry.Extension.ToLower()
                    if (!$output.Contains($entry.FullName)) {
                        $output.Add($entry.FullName)
                    }
                }
            }
        }

        return ,$output
    }
}
