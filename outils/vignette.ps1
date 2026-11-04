# Cree la petite vignette promotionnelle du store (440 x 280) dans ..\store\vignette-440x280.png
Add-Type -AssemblyName System.Drawing

$racine = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$sortie = Join-Path $racine 'store'
New-Item -ItemType Directory -Force $sortie | Out-Null

function Pt([float]$x, [float]$y) { [Drawing.PointF]::new($x, $y) }

$W = 440; $H = 280
# 24 bits sans transparence : exigence du store pour les images promotionnelles
$bmp = [Drawing.Bitmap]::new($W, $H, [Drawing.Imaging.PixelFormat]::Format24bppRgb)
$g = [Drawing.Graphics]::FromImage($bmp)
$g.SmoothingMode = [Drawing.Drawing2D.SmoothingMode]::AntiAlias
$g.TextRenderingHint = [Drawing.Text.TextRenderingHint]::AntiAliasGridFit
$g.InterpolationMode = [Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic

$fond = [Drawing.Drawing2D.LinearGradientBrush]::new((Pt 0 0), (Pt $W $H),
    [Drawing.Color]::FromArgb(255, 30, 22, 24), [Drawing.Color]::FromArgb(255, 70, 24, 30))
$g.FillRectangle($fond, 0, 0, $W, $H)

$logo = [Drawing.Image]::FromFile((Join-Path $racine 'icons\apercu-512.png'))
$g.DrawImage($logo, 36, 76, 128, 128)
$logo.Dispose()

$blanc = [Drawing.SolidBrush]::new([Drawing.Color]::White)
$gris = [Drawing.SolidBrush]::new([Drawing.Color]::FromArgb(255, 232, 210, 210))
$titre = [Drawing.Font]::new('Segoe UI Semibold', 26)
$sous = [Drawing.Font]::new('Segoe UI', 13)
$g.DrawString('DefileShorts', $titre, $blanc, 182, 92)
$g.DrawString("Next Short, automatically", $sous, $gris, 186, 140)
$g.DrawString("No data collected", $sous, $gris, 186, 164)

$g.Dispose()
$fichier = Join-Path $sortie 'vignette-440x280.png'
$bmp.Save($fichier, [Drawing.Imaging.ImageFormat]::Png)
$bmp.Dispose()
"Vignette : $fichier"
