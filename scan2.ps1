# Check other user profiles sizes
$users = Get-ChildItem "C:\Users\" -Directory | Where-Object { $_.Name -ne "Public" -and $_.Name -ne "liaohui" }
foreach ($u in $users) {
    $s = (Get-ChildItem $u.FullName -Recurse -File -ErrorAction SilentlyContinue | Measure-Object Length -Sum).Sum
    if ($s -gt 100MB) {
        Write-Host ("$($u.Name): " + [math]::Round($s/1MB,1) + " MB")
    }
}

Write-Host "---"
# What's in NVIDIA AppData?
$nvidia = "$env:LOCALAPPDATA\NVIDIA"
Get-ChildItem $nvidia -Directory | ForEach-Object {
    $f = $_
    $s = (Get-ChildItem $f.FullName -Recurse -File -ErrorAction SilentlyContinue | Measure-Object Length -Sum).Sum
    if ($s -gt 50MB) {
        Write-Host ("NVIDIA/" + $f.Name + ": " + [math]::Round($s/1MB,1) + " MB")
    }
}

Write-Host "---"
# What's in Kingsoft Roaming?
$kingsoft = "$env:APPDATA\Kingsoft"
Get-ChildItem $kingsoft -Directory | ForEach-Object {
    $f = $_
    $s = (Get-ChildItem $f.FullName -Recurse -File -ErrorAction SilentlyContinue | Measure-Object Length -Sum).Sum
    if ($s -gt 50MB) {
        Write-Host ("Kingsoft/" + $f.Name + ": " + [math]::Round($s/1MB,1) + " MB")
    }
}

Write-Host "---"
# What's in Tencent Roaming?
$tencent = "$env:APPDATA\Tencent"
Get-ChildItem $tencent -Directory | ForEach-Object {
    $f = $_
    $s = (Get-ChildItem $f.FullName -Recurse -File -ErrorAction SilentlyContinue | Measure-Object Length -Sum).Sum
    if ($s -gt 50MB) {
        Write-Host ("Tencent/" + $f.Name + ": " + [math]::Round($s/1MB,1) + " MB")
    }
}

Write-Host "---"
# Check Desktop top folders
$desktop = [Environment]::GetFolderPath("Desktop")
Get-ChildItem $desktop -Directory | ForEach-Object {
    $f = $_
    $s = (Get-ChildItem $f.FullName -Recurse -File -ErrorAction SilentlyContinue | Measure-Object Length -Sum).Sum
    if ($s -gt 100MB) {
        Write-Host ("Desktop/" + $f.Name + ": " + [math]::Round($s/1MB,1) + " MB")
    }
}
