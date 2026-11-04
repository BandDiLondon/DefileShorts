# Genere les icones de DefileShorts (16, 32, 48, 128 px) dans ..\icons
# Dessin a 512 px puis reduction, pour un rendu net a toutes les tailles.
Add-Type -AssemblyName System.Drawing

$dossier = Join-Path $PSScriptRoot '..\icons'
New-Item -ItemType Directory -Force $dossier | Out-Null

function Pt([float]$x, [float]$y) { [Drawing.PointF]::new($x, $y) }

function Dessiner-Grand {
    $S = 512
    $bmp = [Drawing.Bitmap]::new($S, $S, [Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $g = [Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.Clear([Drawing.Color]::Transparent)

    # Carre arrondi en degrade
    $m = 16; $r = 120; $w = $S - 2 * $m
    $p = [Drawing.Drawing2D.GraphicsPath]::new()
    $p.AddArc($m, $m, $r, $r, 180, 90)
    $p.AddArc($m + $w - $r, $m, $r, $r, 270, 90)
    $p.AddArc($m + $w - $r, $m + $w - $r, $r, $r, 0, 90)
    $p.AddArc($m, $m + $w - $r, $r, $r, 90, 90)
    $p.CloseFigure()
    $fond = [Drawing.Drawing2D.LinearGradientBrush]::new((Pt 0 0), (Pt $S $S),
        [Drawing.Color]::FromArgb(255, 255, 82, 82), [Drawing.Color]::FromArgb(255, 196, 18, 48))
    $g.FillPath($fond, $p)

    # Deux chevrons vers le bas : le premier attenue, le second plein
    foreach ($c in @(@{ Y = 140; A = 150 }, @{ Y = 262; A = 255 })) {
        $crayon = [Drawing.Pen]::new([Drawing.Color]::FromArgb($c.A, 255, 255, 255), 60)
        $crayon.StartCap = [Drawing.Drawing2D.LineCap]::Round
        $crayon.EndCap = [Drawing.Drawing2D.LineCap]::Round
        $crayon.LineJoin = [Drawing.Drawing2D.LineJoin]::Round
        $pts = [Drawing.PointF[]]@((Pt 150 $c.Y), (Pt 256 ($c.Y + 106)), (Pt 362 $c.Y))
        $g.DrawLines($crayon, $pts)
        $crayon.Dispose()
    }
    $g.Dispose()
    return $bmp
}

$grand = Dessiner-Grand
foreach ($n in 16, 32, 48, 128) {
    $petit = [Drawing.Bitmap]::new($n, $n, [Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $g = [Drawing.Graphics]::FromImage($petit)
    $g.InterpolationMode = [Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.PixelOffsetMode = [Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $g.DrawImage($grand, 0, 0, $n, $n)
    $g.Dispose()
    $petit.Save((Join-Path $dossier "icon$n.png"), [Drawing.Imaging.ImageFormat]::Png)
    $petit.Dispose()
}
$grand.Save((Join-Path $dossier 'apercu-512.png'), [Drawing.Imaging.ImageFormat]::Png)
$grand.Dispose()
"Icones generees dans $dossier"
