<#
.SYNOPSIS
Finds missing numbered file parts in a folder.

.DESCRIPTION
Scans a directory for files with numeric extensions
(e.g. .001, .002, .003) and reports missing parts.

Optionally supports:
- Manual range specification
- Abbreviated output formatting

.PARAMETER TargetFolder
Folder to scan. Defaults to current directory.

.PARAMETER Start
Optional start of range.

.PARAMETER End
Optional end of range.

.PARAMETER Abbreviated
Formats consecutive missing parts as ranges.

Example:
1..5, 8, 10..20

.EXAMPLE
.\LostPartsFinder.ps1

Auto-detects range and scans current folder.

.EXAMPLE
.\LostPartsFinder.ps1 -TargetFolder "./downloads"

Scans a custom folder.

.EXAMPLE
.\LostPartsFinder.ps1 -Start 1 -End 100

Checks for missing parts between 1 and 100.

.EXAMPLE
.\LostPartsFinder.ps1 -Abbreviated

Uses abbreviated range formatting.

.EXAMPLE
Get-Help .\LostPartsFinder.ps1 -Full

Displays complete help.
#>

param(
    [string]$TargetFolder = ".",
    [int]$Start,
    [int]$End,
    [switch]$Abbreviated
)

$files = Get-ChildItem -Path $TargetFolder -File |
    Where-Object Extension -match '^\.\d+$'

if (-not $files) {
    Write-Host "No numeric parts found."
    exit
}

$found = [System.Collections.Generic.HashSet[int]]::new()

foreach ($file in $files) {
    $partNumber = [int]$file.Extension.TrimStart('.')
    $null = $found.Add($partNumber)
}

if (-not $PSBoundParameters.ContainsKey('Start')) {
    $Start = ($found | Measure-Object -Minimum).Minimum
}

if (-not $PSBoundParameters.ContainsKey('End')) {
    $End = ($found | Measure-Object -Maximum).Maximum
}

if ($Start -gt $End) {
    Write-Error "Start cannot be greater than End."
    exit 1
}

$missing = $Start..$End | Where-Object {
    -not $found.Contains($_)
}

if (-not $missing) {
    Write-Host "No missing parts."
    exit
}

function Format-AbbreviatedRanges {
    param(
        [int[]]$Numbers
    )

    if (-not $Numbers) {
        return ""
    }

    $ranges = @()

    $rangeStart = $Numbers[0]
    $previous = $Numbers[0]

    for ($i = 1; $i -lt $Numbers.Count; $i++) {

        $current = $Numbers[$i]

        if ($current -eq ($previous + 1)) {
            $previous = $current
            continue
        }

        if ($rangeStart -eq $previous) {
            $ranges += "$rangeStart"
        }
        else {
            $ranges += "$rangeStart..$previous"
        }

        $rangeStart = $current
        $previous = $current
    }

    if ($rangeStart -eq $previous) {
        $ranges += "$rangeStart"
    }
    else {
        $ranges += "$rangeStart..$previous"
    }

    return $ranges -join ', '
}

if ($Abbreviated) {
    $formatted = Format-AbbreviatedRanges $missing
}
else {
    $formatted = $missing -join ', '
}

Write-Host "Missing parts: $formatted"