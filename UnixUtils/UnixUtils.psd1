@{

# Script module or binary module file associated with this manifest.
RootModule = 'UnixUtils.psm1'

# Version number of this module.
ModuleVersion = '0.1.0'

# ID used to uniquely identify this module
GUID = '90e245b3-ac30-4f38-a8b8-5f02ead7e5bb'

# Author of this module
Author = 'bwpge'

# Company or vendor of this module
CompanyName = 'Unknown'

# Copyright statement for this module
Copyright = '(c) 2024 bwpge'

# Description of the functionality provided by this module
Description = 'An incomplete PowerShell implementation of various Unix-like utilities and some GNU Coreutils.'

# Minimum version of the PowerShell engine required by this module
PowerShellVersion = '5.1'

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = @()

# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
CmdletsToExport = @()

# Variables to export from this module
# VariablesToExport = '*'

# Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
AliasesToExport = @()

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{
    PSData = @{
        # A URL to the license for this module.
        LicenseUri = 'https://github.com/bwpge/unixutils-pwsh/blob/main/LICENSE'

        # A URL to the main website for this project.
        ProjectUri = 'https://github.com/bwpge/unixutils-pwsh'
    }
}
}
