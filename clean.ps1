$ErrorActionPreference = "Stop"

Set-Location "easy_sync"

Write-Output "Cleaning up build and test artifacts"
flutter clean
Write-Output "Artifacts cleaned"

Set-Location ..