$ErrorActionPreference = "Stop"

Set-Location "easy_sync"

Write-Output "Running all Flutter tests designated in the test/ directory..."
try {
    flutter test
    Write-Output "Tests complete."
} catch {
    Write-Output "Tests failed."
    exit 127
}

Set-Location ..