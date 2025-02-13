$ErrorActionPreference = "Stop"

Set-Location "easy_sync"

Write-Output "Installing Flutter dependencies..."
flutter config --enable-windows-desktop
flutter pub get

Write-Output "Building Flutter Windows App..."
try {
    flutter build windows
    Write-Output "Build Complete"
} catch {
    Write-Output "Build Failed"
    exit 127
}

Set-Location ..