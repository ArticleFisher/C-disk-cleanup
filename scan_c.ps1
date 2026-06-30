$ErrorActionPreference = "SilentlyContinue"
$drive = Get-PSDrive C
$usedGb = [math]::Round($drive.Used/1GB, 1)
$freeGb = [math]::Round($drive.Free/1GB, 1)
$totalGb = [math]::Round(($drive.Used+$drive.Free)/1GB, 1)
$freePct = [math]::Round($drive.Free*100/($drive.Used+$drive.Free), 1)
Write-Host "=== C: Drive Summary ==="
Write-Host "Total: ${totalGb}GB | Used: ${usedGb}GB | Free: ${freeGb}GB (${freePct}%)"

Write-Host "`n=== C:\ Root Folders (Top 20) ==="
Get-ChildItem "C:\" -Directory | ForEach-Object {
    $f = $_
    $s = (Get-ChildItem $f.FullName -Recurse -File | Measure-Object Length -Sum).Sum
    [PSCustomObject]@{Folder=$f.Name; SizeGB=[math]::Round($s/1GB, 2)}
} | Sort SizeGB -Descending | Select -First 20 | Format-Table -AutoSize

Write-Host "=== User Profile Folders ==="
$up = "C:\Users\$env:USERNAME"
Get-ChildItem $up -Directory | ForEach-Object {
    $f = $_
    $s = (Get-ChildItem $f.FullName -Recurse -File | Measure-Object Length -Sum).Sum
    [PSCustomObject]@{Folder=$f.Name; SizeGB=[math]::Round($s/1GB, 2)}
} | Sort SizeGB -Descending | Format-Table -AutoSize

Write-Host "=== AppData Local Subfolders (Top 15) ==="
$ad = "$env:LOCALAPPDATA"
Get-ChildItem $ad -Directory | ForEach-Object {
    $f = $_
    $s = (Get-ChildItem $f.FullName -Recurse -File | Measure-Object Length -Sum).Sum
    [PSCustomObject]@{Folder=$f.Name; SizeMB=[math]::Round($s/1MB, 1)}
} | Sort SizeMB -Descending | Select -First 15 | Format-Table -AutoSize

Write-Host "=== AppData Roaming Subfolders (Top 15) ==="
$ar = "$env:APPDATA"
Get-ChildItem $ar -Directory | ForEach-Object {
    $f = $_
    $s = (Get-ChildItem $f.FullName -Recurse -File | Measure-Object Length -Sum).Sum
    [PSCustomObject]@{Folder=$f.Name; SizeMB=[math]::Round($s/1MB, 1)}
} | Sort SizeMB -Descending | Select -First 15 | Format-Table -AutoSize

Write-Host "=== Key System Files ==="
$paths = @{
    "hiberfil.sys" = "C:\hiberfil.sys"
    "pagefile.sys" = "C:\pagefile.sys"
    "swapfile.sys" = "C:\swapfile.sys"
    "MEMORY.DMP" = "C:\MEMORY.DMP"
}
foreach ($name in $paths.Keys) {
    $p = $paths[$name]
    if (Test-Path $p) {
        $s = (Get-Item $p).Length
        Write-Host "${name}: $([math]::Round($s/1GB,2)) GB"
    } else {
        Write-Host "${name}: Not found"
    }
}

$winOld = "C:\Windows.old"
if (Test-Path $winOld) {
    $s = (Get-ChildItem $winOld -Recurse -File | Measure-Object Length -Sum).Sum
    Write-Host "Windows.old: $([math]::Round($s/1GB,2)) GB"
} else {
    Write-Host "Windows.old: Not found"
}

$wuDir = "C:\Windows\SoftwareDistribution\Download"
if (Test-Path $wuDir) {
    $s = (Get-ChildItem $wuDir -Recurse -File | Measure-Object Length -Sum).Sum
    Write-Host "Windows Update Cache: $([math]::Round($s/1MB,1)) MB"
}

$temp1 = "$env:TEMP"
$temp2 = "$env:WINDIR\Temp"
$prefetch = "C:\Windows\Prefetch"
foreach ($t in @($temp1, $temp2, $prefetch)) {
    if (Test-Path $t) {
        $s = (Get-ChildItem $t -Recurse -File | Measure-Object Length -Sum).Sum
        Write-Host "Temp folder ($t): $([math]::Round($s/1MB,1)) MB"
    }
}

Write-Host "`nDone!"
