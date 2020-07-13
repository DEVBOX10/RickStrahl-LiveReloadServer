$packageName = "LiveReloadWebServer"
$url = "https://github.com/RickStrahl/Westwind.AspnetCore.LiveReload/raw/0.2.5.2/LiveReloadServer/LiveReloadWebServer.zip"
$drop = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$sha = "2349484CFC8411D0B2C7D5205FB09E06B5A9226C91491193A7A053ACED2314B6"
Install-ChocolateyZipPackage -PackageName "$packageName" -Url "$url" -UnzipLocation "$drop" -checksum64 "$sha" -checksumtype "sha256"
