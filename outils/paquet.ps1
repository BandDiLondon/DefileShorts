# Cree dist\DefileShorts-<version>.zip pour le Chrome Web Store.
# Zip fait a la main : Compress-Archive (PowerShell 5.1) ecrit des "\" dans les chemins, refuses par le store.
Add-Type -AssemblyName System.IO.Compression, System.IO.Compression.FileSystem

$racine = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$version = (Get-Content (Join-Path $racine 'manifest.json') -Raw | ConvertFrom-Json).version
$dist = Join-Path $racine 'dist'
New-Item -ItemType Directory -Force $dist | Out-Null
$zip = Join-Path $dist "DefileShorts-$version.zip"
if (Test-Path $zip) { Remove-Item $zip }

$fichiers = @('manifest.json', 'defile.js', 'arriere-plan.js','popup.html', 'popup.js',
    'icons/icon16.png', 'icons/icon32.png', 'icons/icon48.png', 'icons/icon128.png',
    '_locales/fr/messages.json', '_locales/en/messages.json')

function Creer-Zip($chemin, $prefixe, $extras) {
    if (Test-Path $chemin) { Remove-Item $chemin }
    $archive = [IO.Compression.ZipFile]::Open($chemin, [IO.Compression.ZipArchiveMode]::Create)
    try {
        foreach ($f in $fichiers) {
            $source = Join-Path $racine ($f -replace '/', '\')
            if (-not (Test-Path $source)) { throw "Fichier manquant : $f" }
            [IO.Compression.ZipFileExtensions]::CreateEntryFromFile($archive, $source, "$prefixe$f", [IO.Compression.CompressionLevel]::Optimal) | Out-Null
        }
        foreach ($e in $extras.GetEnumerator()) {
            [IO.Compression.ZipFileExtensions]::CreateEntryFromFile($archive, $e.Value, "$prefixe$($e.Key)", [IO.Compression.CompressionLevel]::Optimal) | Out-Null
        }
    } finally { $archive.Dispose() }
    "Paquet : $chemin ($([Math]::Round((Get-Item $chemin).Length / 1KB, 1)) Ko)"
}

# 1) Pour le Chrome Web Store : manifest.json a la racine du zip
Creer-Zip $zip '' @{}

# 2) Pour les amis (release GitHub) : un dossier DefileShorts/ + mode d'emploi
$extras = @{ 'INSTALLER.txt' = (Join-Path $PSScriptRoot 'INSTALLER.txt'); 'LICENSE' = (Join-Path $racine 'LICENSE') }
Creer-Zip (Join-Path $dist "DefileShorts-$version-installation.zip") 'DefileShorts/' $extras
