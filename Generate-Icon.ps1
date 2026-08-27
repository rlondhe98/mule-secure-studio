# Generates MuleSoftSecureProperties.ico — blue rounded square with white lock
Add-Type -AssemblyName System.Drawing

function New-LockBitmap([int]$Size) {
    $bmp = [System.Drawing.Bitmap]::new($Size, $Size, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $g.Clear([System.Drawing.Color]::Transparent)

    $pad = [math]::Max(1, [int]($Size * 0.04))
    $s = $Size - 2 * $pad

    # Rounded-rect background
    $cr = [int]($s * 0.22)
    $bp = [System.Drawing.Drawing2D.GraphicsPath]::new()
    $bp.AddArc($pad, $pad, $cr * 2, $cr * 2, 180, 90)
    $bp.AddArc($pad + $s - $cr * 2, $pad, $cr * 2, $cr * 2, 270, 90)
    $bp.AddArc($pad + $s - $cr * 2, $pad + $s - $cr * 2, $cr * 2, $cr * 2, 0, 90)
    $bp.AddArc($pad, $pad + $s - $cr * 2, $cr * 2, $cr * 2, 90, 90)
    $bp.CloseFigure()

    $grad = [System.Drawing.Drawing2D.LinearGradientBrush]::new(
        [System.Drawing.PointF]::new($pad, $pad),
        [System.Drawing.PointF]::new($pad + $s, $pad + $s),
        [System.Drawing.Color]::FromArgb(59, 130, 246),   # #3B82F6
        [System.Drawing.Color]::FromArgb(29, 78, 216))     # #1D4ED8
    $g.FillPath($grad, $bp)
    $grad.Dispose(); $bp.Dispose()

    # Centre reference
    [float]$cx = $Size / 2
    [float]$cy = $Size / 2

    # --- Shield outline ---
    $sw = $s * 0.54; $sh = $s * 0.62
    $st = $cy - $sh * 0.44

    $sp = [System.Drawing.Drawing2D.GraphicsPath]::new()
    $sp.AddArc([float]($cx - $sw / 2), [float]$st, [float]$sw, [float]($sw * 0.35), 180, 180)
    $sideTop = $st + $sw * 0.175
    $sp.AddBezier([float]($cx + $sw / 2), [float]$sideTop,
                  [float]($cx + $sw / 2), [float]($st + $sh * 0.65),
                  [float]($cx + $sw * 0.12), [float]($st + $sh * 0.85),
                  [float]$cx, [float]($st + $sh))
    $sp.AddBezier([float]$cx, [float]($st + $sh),
                  [float]($cx - $sw * 0.12), [float]($st + $sh * 0.85),
                  [float]($cx - $sw / 2), [float]($st + $sh * 0.65),
                  [float]($cx - $sw / 2), [float]$sideTop)
    $sp.CloseFigure()

    $sf = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(45, 255, 255, 255))
    $g.FillPath($sf, $sp); $sf.Dispose()

    $pw = [math]::Max(1.2, $s * 0.032)
    $pen = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(230, 255, 255, 255), $pw)
    $pen.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round
    $g.DrawPath($pen, $sp); $pen.Dispose(); $sp.Dispose()

    # --- Lock icon inside shield ---
    if ($Size -ge 24) {
        $white = [System.Drawing.Color]::White
        $lw = $s * 0.20; $lh = $s * 0.15
        [float]$lx = $cx - $lw / 2
        [float]$ly = $cy + $s * 0.04

        # Shackle
        $spw = [math]::Max(1.4, $s * 0.032)
        $sPen = [System.Drawing.Pen]::new($white, $spw)
        $sPen.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
        $sPen.EndCap   = [System.Drawing.Drawing2D.LineCap]::Round
        $arcW = $lw * 0.58; $arcH = $lh * 0.72
        $g.DrawArc($sPen, [float]($cx - $arcW / 2), [float]($ly - $arcH + $spw / 2),
                   [float]$arcW, [float]($arcH * 2), 180, 180)
        $sPen.Dispose()

        # Body
        $lr = [math]::Max(1, $lw * 0.14)
        $lp = [System.Drawing.Drawing2D.GraphicsPath]::new()
        $lp.AddArc($lx, $ly, $lr * 2, $lr * 2, 180, 90)
        $lp.AddArc($lx + $lw - $lr * 2, $ly, $lr * 2, $lr * 2, 270, 90)
        $lp.AddArc($lx + $lw - $lr * 2, $ly + $lh - $lr * 2, $lr * 2, $lr * 2, 0, 90)
        $lp.AddArc($lx, $ly + $lh - $lr * 2, $lr * 2, $lr * 2, 90, 90)
        $lp.CloseFigure()
        $lb = [System.Drawing.SolidBrush]::new($white)
        $g.FillPath($lb, $lp); $lb.Dispose(); $lp.Dispose()

        # Keyhole
        if ($Size -ge 48) {
            $hr = [math]::Max(1, $lw * 0.10)
            $hb = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(29, 78, 216))
            $g.FillEllipse($hb, [float]($cx - $hr), [float]($ly + $lh * 0.30),
                           [float]($hr * 2), [float]($hr * 2))
            $hb.Dispose()
        }
    }

    $g.Dispose()
    return $bmp
}

function Save-MultiSizeIco([string]$Path, [int[]]$Sizes) {
    $pngBlobs = [System.Collections.Generic.List[byte[]]]::new()
    foreach ($sz in $Sizes) {
        $bmp = New-LockBitmap $sz
        $ms = [System.IO.MemoryStream]::new()
        $bmp.Save($ms, [System.Drawing.Imaging.ImageFormat]::Png)
        $pngBlobs.Add($ms.ToArray())
        $ms.Dispose(); $bmp.Dispose()
    }

    $fs = [System.IO.FileStream]::new($Path, [System.IO.FileMode]::Create)
    $bw = [System.IO.BinaryWriter]::new($fs)

    # ICO header
    $bw.Write([uint16]0)              # Reserved
    $bw.Write([uint16]1)              # Type = ICO
    $bw.Write([uint16]$Sizes.Count)   # Image count

    # Directory entries
    $dataOffset = 6 + 16 * $Sizes.Count
    for ($i = 0; $i -lt $Sizes.Count; $i++) {
        $w = if ($Sizes[$i] -ge 256) { 0 } else { $Sizes[$i] }
        $bw.Write([byte]$w)           # Width
        $bw.Write([byte]$w)           # Height
        $bw.Write([byte]0)            # Colour count
        $bw.Write([byte]0)            # Reserved
        $bw.Write([uint16]1)          # Planes
        $bw.Write([uint16]32)         # Bits per pixel
        $bw.Write([uint32]$pngBlobs[$i].Length)
        $bw.Write([uint32]$dataOffset)
        $dataOffset += $pngBlobs[$i].Length
    }

    # Image data
    foreach ($blob in $pngBlobs) { $bw.Write($blob) }

    $bw.Close(); $fs.Close()
    Write-Host "Created $Path ($($Sizes.Count) sizes: $($Sizes -join ', ')px)"
}

# Generate the icon
$outPath = Join-Path $PSScriptRoot "MuleSoftSecureProperties.ico"
Save-MultiSizeIco -Path $outPath -Sizes @(16, 24, 32, 48, 64, 128, 256)
