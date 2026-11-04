# Cree dist\DefileShorts-<version>.zip pour le Chrome Web Store.
# Zip fait a la main : Compress-Archive (PowerShell 5.1) ecrit des "\" dans les chemins, refuses par le store.
Add-Type -AssemblyName System.IO.Compression, System.IO.Compression.FileSystem

$racine = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$version = (Get-Content (Join-Path $racine 'manifest.json') -Raw | ConvertFrom-Json).version
$dist = Join-Path $racine 'dist'
New-Item -ItemType Directory -Force $dist | Out-Null
$zip = Join-Path $dist "DefileShorts-$version.zip"
if (Test-Path $zip) { Remove-Item $zip }

$fichiers = @('manifest.json', 'defile.js', 'popup.html', 'popup.js',
    'icons/icon16.png', 'icons/icon32.png', 'icons/icon48.png', 'icons/icon128.png',
    '_locales/fr/messages.json', '_locales/en/messages.json')

$archive = [IO.Compression.ZipFile]::Open($zip, [IO.Compression.ZipArchiveMode]::Create)
try {
    foreach ($f in $fichiers) {
        $source = Join-Path $racine ($f -replace '/', '\')
        if (-not (Test-Path $source)) { throw "Fichier manquant : $f" }
        [IO.Compression.ZipFileExtensions]::CreateEntryFromFile($archive, $source, $f, [IO.Compression.CompressionLevel]::Optimal) | Out-Null
    }
} finally { $archive.Dispose() }
"Paquet : $zip ($([Math]::Round((Get-Item $zip).Length / 1KB, 1)) Ko)"
