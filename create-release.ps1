$releaseFolder = "$PSScriptRoot\."
$releaseFile = "$releaseFolder\LiveReloadWebServer.exe"
$releaseZip = "$releaseFolder\LiveReloadWebServer.zip"
$hostedZip = "$releaseFolder\LiveReloadWebServer-Hosted.zip"

$rawVersion = [System.Diagnostics.FileVersionInfo]::GetVersionInfo($releaseFile).FileVersion

$version = $rawVersion.Trim().Replace(".0","") 
"Writing Version File for: $version ($rawVersion)"

$downloadUrl = "https://github.com/RickStrahl/LiveReloadServer/raw/$version/LiveReloadWebServer.zip"               

# Create Release Zip file
7z a -tzip $releaseZip $releaseFile ".\LiveReloadWebServer.json" 

# Created Hosted Zip file
7z a -tzip $hostedZip "$releaseFolder\LiveReloadServer\bin\release\netcoreapp3.1\publish\*.*" -r

# Write out Verification.txt
$sha = get-filehash -path $releaseZip -Algorithm SHA256  | select -ExpandProperty "Hash"
write-host $sha

$filetext = @"
`$packageName = "LiveReloadWebServer"
`$url = "$downloadUrl"
`$drop = "`$(Split-Path -Parent `$MyInvocation.MyCommand.Definition)"
`$sha = "$sha"
`Install-ChocolateyZipPackage -PackageName "`$packageName" -Url "`$url" -UnzipLocation "`$drop" -checksum64 "`$sha" -checksumtype "sha256"
"@
out-file -filepath Chocolatey\tools\chocolateyInstall.ps1 -inputobject $filetext
Write-Host $filetext

# Write out new NuSpec file with Version
$chocoNuspec = ".\Chocolatey\LiveReloadWebServer.template.nuspec"
$content = Get-Content -Path $chocoNuspec
$content = $content.Replace("{{version}}",$version)
# Write-Host $content
out-file -filepath $chocoNuSpec.Replace(".template","")  -inputobject $content -Encoding utf8

# Commit  current changes and add a tag
git add --all

git tag --delete $version
git push --delete origin $version 

git commit -m "$version" 
git tag $version
git push origin master --tags
