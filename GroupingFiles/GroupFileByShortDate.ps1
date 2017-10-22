Get-ChildItem | Select Name, LastWriteTime | Group-Object { $_.LastWriteTime.ToString("yyyy-MM-dd") } | ForEach-Object {
    New-Item -Name $_.Name -ItemType Directory -Force
    foreach($file in $_.Group) {
        Move-Item $file.Name $_.Name -Force
    }
}
