function Get-UUAliasDefinition($item, $escape) {
    if (!$item) {
        return
    }

    $def = $item.Definition
    if ($def.StartsWith("__alias_")) {
        $def = (Get-Item -Path "Function:\$def").Definition
    }

    $def = $def -replace "^& " -replace ' @args$'
    if ($escape) {
        $def = $def -replace "'", "''"
        if ($def.Contains(" ")) {
            $def = "'$def'"
        }
    }
    $def
}

function Write-UnsupportedOption($name, $alias) {
    $s = "-$name"
    if ($alias) {
        $s += " (-$alias)"
    }
    Write-Warning "Option $s is not supported. This argument is only identified to warn about compatibility issues."
}

function Format-UUError ($msg, $e) {
    $s = "$msg"
    if ($e.Count) {
        $e = $e[0]
    }
    if ($e) {
        $errstr = if ($e.Exception) {
            $e.Exception.Message
        } else {
            $e
        }
    }
    if ($errstr) {
        $s += ": $errstr"
    }
    $s
}
