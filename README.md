# unixutils-pwsh

An incomplete PowerShell implementation of various Unix-like utilities and some [GNU Coreutils](https://www.gnu.org/software/coreutils/) analogs.

## Requirements

This module requires a minimum version of PowerShell 5.1 (a fresh install of Windows 10/11 should come with 5.1).

## Installation

Clone this repository and add the following to the top of your `$PROFILE` script:

```pwsh
Import-Module path\to\unixutils-pwsh\UnixUtils
```

### Symbolic Link

To avoid using the full path with `Import-Module`, you can create a symbolic link to this module in your PowerShell module directory (usually `$HOME\Documents\PowerShell\Modules`).

You can ensure this directory is created with (be sure to note the path):

```pwsh
New-Item ([System.IO.DirectoryInfo]$env:PSModulePath.Split(';')[0]) -Confirm -ItemType Directory -Force -EA 0
```

To create a symbolic link, you need to use an admin prompt and run:

```pwsh
New-Item -Confirm -ItemType SymbolicLink -Path your\modules\UnixUtils -Target path\to\unixutils-pwsh\UnixUtils
```

Then you can just use `Import-Module UnixUtils` in your `$PROFILE` script.
