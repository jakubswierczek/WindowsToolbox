function Open-Dev-Chrome {
    $workingDir = Get-Location
    Set-Location -Path 'C:\Program Files (x86)\Google\Chrome\Application\'
    .\chrome.exe --no-default-browser-check --no-first-use --user-data-dir="${env:USERPROFILE}\AppData\Local\Temp\dev-chrome"
    Set-Location $workingDir
}
