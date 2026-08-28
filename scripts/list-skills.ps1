$ErrorActionPreference = "Stop"
Get-ChildItem -Path skills -Recurse -Filter SKILL.md | ForEach-Object {
    $_.FullName.Substring((Get-Location).Path.Length + 1)
} | Sort-Object
