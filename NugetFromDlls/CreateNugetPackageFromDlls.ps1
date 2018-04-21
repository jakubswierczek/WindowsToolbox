$targetDirectory = ""

$dlls = Get-ChildItem -Path ("*.dll") | Select-Object Name, BaseName
ForEach ($dll in $dlls) {
    nuget spec -a $dll.Name -Force
    $spec_name = $dll.BaseName + ".nuspec"
    $new_spec_name = $dll.BaseName + "\" + $spec_name
    $lib_folder = $dll.BaseName + "\lib"
    $xml = [xml](Get-Content $spec_name)
    $DeleteNames = "licenseUrl","projectUrl", "iconUrl", "tags", "releaseNotes", "dependencies"
    ($xml.package.metadata.ChildNodes |Where-Object { $DeleteNames -contains $_.Name }) | ForEach-Object {
        [void]$_.ParentNode.RemoveChild($_)
    }
    $xml.package.metadata.description = $dll.BaseName.ToString()
    
    New-Item  -ItemType Directory -Force -Path $lib_folder
    Copy-Item $dll.Name -Destination $lib_folder -Force
    $xml.Save((Get-Location).Path+ "\" + $new_spec_name)
    nuget pack $new_spec_name
    $package_file = Get-ChildItem -Path "*.nupkg" | Sort-Object LastWriteTime -Descending |  Select-Object Name  -First 1
    nuget add $package_file.Name -source $targetDirectory
}