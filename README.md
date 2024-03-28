# unixutils-pwsh

An incomplete PowerShell implementation of various Unix-like utilities and some [GNU Coreutils](https://www.gnu.org/software/coreutils/) analogs.

## Requirements

This module requires a minimum version of PowerShell 5.1 (a fresh install of Windows 10/11 should come with 5.1).

## Installation

Clone this repository and add the following to the top of your `$PROFILE` script:

```powershell
Import-Module path\to\unixutils-pwsh\UnixUtils
```

See [Usage](#usage) for functions and recommended aliases.

### Symbolic Link

To avoid using the full path with `Import-Module`, you can create a symbolic link to this module in your PowerShell module directory (usually `$HOME\Documents\PowerShell\Modules`).

You can ensure this directory is created with (be sure to note the path):

```powershell
New-Item ([System.IO.DirectoryInfo]$env:PSModulePath.Split(';')[0]) -Confirm -ItemType Directory -Force -EA 0
```

To create a symbolic link, you need to use an admin prompt and run:

```powershell
New-Item -Confirm -ItemType SymbolicLink -Path your\modules\UnixUtils -Target path\to\unixutils-pwsh\UnixUtils
```

Then you can just use `Import-Module UnixUtils` in your `$PROFILE` script.

## Usage

The following functions are exported by this module:

| Name | Utility |
| --- | --- |
| `Invoke-UUTouch` | `touch` |
| `Invoke-UUWhich` | `which` |
| `Set-UUAlias` | `alias` |

It is recommended to set aliases for these commands in your profile script:

```powershell
Set-Alias -Name touch -Value Invoke-UUTouch
Set-Alias -Name which -Value Invoke-UUWhich
Set-Alias -Name alias -Value Set-UUAlias
```

You can then call these functions like any other command line utility. Options and flags are implemented to be as close as possible to the original commands:

```powershell
touch -c foo.txt  # touch foo.txt if it exists, but don't create
touch foo.txt  # touch/create foo.txt
which foo  # find `foo` command
which -a where  # find all `where` commands
alias foo='bar baz'  # alias `foo` to `bar baz`
alias foo  # print `foo` alias if set
```
