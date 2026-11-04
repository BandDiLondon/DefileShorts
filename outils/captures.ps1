# Images de presentation du store (1280 x 800, 24 bits sans transparence) dans ..\store\
# capture-fr-1280x800.png et capture-en-1280x800.png
# Fichier enregistre en UTF-8 avec BOM (accents).
Add-Type -AssemblyName System.Drawing

$racine = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$sortie = Join-Path $racine 'store'
New-Item -ItemType Directory -Force $sortie | Out-Null

function Pt([float]$x, [float]$y) { [Drawing.PointF]::new($x, $y) }
function Couleur($a, $r, $g, $b) { [Drawing.Color]::FromArgb($a, $r, $g, $b) }
function Arrondi([float]$x, [float]$y, [float]$w, [float]$h, [float]$r) {
    $p = [Drawing.Drawing2D.GraphicsPath]::new()
    $d = 2 * $r
    $p.AddArc($x, $y, $d, $d, 180, 90)
    $p.AddArc($x + $w - $d, $y, $d, $d, 270, 90)
    $p.AddArc($x + $w - $d, $y + $h - $d, $d, $d, 0, 90)
    $p.AddArc($x, $y + $h - $d, $d, $d, 90, 90)
    $p.CloseFigure()
    return $p
}
function Chevron($g, [float]$cx, [float]$cy, [float]$t, $couleur, [float]$epais) {
    $c = [Drawing.Pen]::new($couleur, $epais)
    $c.StartCap = [Drawing.Drawing2D.LineCap]::Round
    $c.EndCap = [Drawing.Drawing2D.LineCap]::Round
    $c.LineJoin = [Drawing.Drawing2D.LineJoin]::Round
    $g.DrawLines($c, [Drawing.PointF[]]@((Pt ($cx - $t) ($cy - $t / 2)), (Pt $cx ($cy + $t / 2)), (Pt ($cx + $t) ($cy - $t / 2))))
    $c.Dispose()
}

$textes = @{
    fr = @{
        Titre  = 'Au Short suivant, automatiquement.'
        Puces  = @('Passe au Short suivant à la fin de la vidéo', 'Un interrupteur pour activer ou couper', 'Aucune donnée recueillie, aucun accès réseau')
        Inter  = 'Défilement automatique'
        Note   = 'Shorts YouTube seulement.'
    }
    en = @{
        Titre  = 'Next Short, automatically.'
        Puces  = @('Moves on when the current Short ends', 'One switch to turn it on or off', 'No data collected, no network access')
        Inter  = 'Auto-scroll'
        Note   = 'YouTube Shorts only.'
    }
}

$logo = [Drawing.Image]::FromFile((Join-Path $racine 'icons\apercu-512.png'))

foreach ($langue in 'fr', 'en') {
    $T = $textes[$langue]
    $W = 1280; $H = 800
    $bmp = [Drawing.Bitmap]::new($W, $H, [Drawing.Imaging.PixelFormat]::Format24bppRgb)
    $g = [Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.TextRenderingHint = [Drawing.Text.TextRenderingHint]::AntiAliasGridFit
    $g.InterpolationMode = [Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic

    # Fond
    $fond = [Drawing.Drawing2D.LinearGradientBrush]::new((Pt 0 0), (Pt $W $H), (Couleur 255 28 21 23), (Couleur 255 68 24 30))
    $g.FillRectangle($fond, 0, 0, $W, $H)

    # Colonne de gauche : logo, nom, accroche, puces
    $blanc = [Drawing.SolidBrush]::new([Drawing.Color]::White)
    $doux = [Drawing.SolidBrush]::new((Couleur 255 236 212 212))
    $g.DrawImage($logo, 80, 120, 96, 96)
    $g.DrawString('DefileShorts', [Drawing.Font]::new('Segoe UI Semibold', 30), $blanc, 192, 138)
    $g.DrawString($T.Titre, [Drawing.Font]::new('Segoe UI Semibold', 34), $blanc, [Drawing.RectangleF]::new(80, 270, 580, 140))
    $y = 430
    $policePuce = [Drawing.Font]::new('Segoe UI', 19)
    $rose = [Drawing.SolidBrush]::new((Couleur 255 240 56 64))
    foreach ($p in $T.Puces) {
        $g.FillEllipse($rose, 84, $y + 11, 12, 12)
        $g.DrawString($p, $policePuce, $doux, 108, $y)
        $y += 52
    }

    # Short en cours (format 9:16), avec barre de lecture presque au bout
    $cx = 770; $cy = 96; $cw = 300; $ch = 534
    $carte = Arrondi $cx $cy $cw $ch 22
    $g.FillPath([Drawing.Drawing2D.LinearGradientBrush]::new((Pt $cx $cy), (Pt ($cx + $cw) ($cy + $ch)), (Couleur 255 40 90 150), (Couleur 255 30 140 150)), $carte)
    $g.FillEllipse([Drawing.SolidBrush]::new((Couleur 60 255 255 255)), $cx + 40, $cy + 90, 180, 180)
    $g.FillEllipse([Drawing.SolidBrush]::new((Couleur 40 255 255 255)), $cx + 150, $cy + 260, 120, 120)
    $g.FillRectangle([Drawing.SolidBrush]::new((Couleur 90 255 255 255)), $cx + 24, $cy + $ch - 30, $cw - 48, 5)
    $g.FillRectangle($rose, $cx + 24, $cy + $ch - 30, ($cw - 48) * 0.96, 5)

    # Short suivant qui arrive par le bas
    $suivante = Arrondi $cx ($cy + $ch + 26) $cw 300 22
    $g.FillPath([Drawing.Drawing2D.LinearGradientBrush]::new((Pt $cx 650), (Pt ($cx + $cw) 800), (Couleur 255 225 130 60), (Couleur 255 200 80 60)), $suivante)

    # Pastille « suivant » entre les deux
    $g.FillEllipse($blanc, $cx + $cw + 30, $cy + $ch - 20, 72, 72)
    Chevron $g ($cx + $cw + 66) ($cy + $ch + 12) 16 (Couleur 255 255 120 120) 8
    Chevron $g ($cx + $cw + 66) ($cy + $ch + 30) 16 (Couleur 255 210 24 48) 8

    # Menu de l'extension (reproduit) en haut à droite
    $mx = 960; $my = 60; $mw = 290; $mh = 96
    $g.FillPath([Drawing.SolidBrush]::new((Couleur 70 0 0 0)), (Arrondi ($mx + 4) ($my + 6) $mw $mh 12))
    $g.FillPath([Drawing.SolidBrush]::new([Drawing.Color]::White), (Arrondi $mx $my $mw $mh 12))
    $g.FillPath([Drawing.SolidBrush]::new((Couleur 255 26 115 232)), (Arrondi ($mx + 18) ($my + 22) 20 20 4))
    $coche = [Drawing.Pen]::new([Drawing.Color]::White, 3)
    $coche.StartCap = [Drawing.Drawing2D.LineCap]::Round; $coche.EndCap = [Drawing.Drawing2D.LineCap]::Round
    $g.DrawLines($coche, [Drawing.PointF[]]@((Pt ($mx + 23) ($my + 32)), (Pt ($mx + 27) ($my + 37)), (Pt ($mx + 34) ($my + 27))))
    $noir = [Drawing.SolidBrush]::new((Couleur 255 32 33 36))
    $g.DrawString($T.Inter, [Drawing.Font]::new('Segoe UI', 14), $noir, $mx + 46, $my + 18)
    $g.DrawString($T.Note, [Drawing.Font]::new('Segoe UI', 11), [Drawing.SolidBrush]::new((Couleur 255 102 102 102)), $mx + 18, $my + 56)

    $g.Dispose()
    $fichier = Join-Path $sortie "capture-$langue-1280x800.png"
    $bmp.Save($fichier, [Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
    "Capture : $fichier"
}
$logo.Dispose()
