# C盘空间扫描脚本
Write-Host "=== C盘空间概览 ===" -ForegroundColor Green
$drive = Get-PSDrive C
$total = [math]::Round(($drive.Used + $drive.Free)/1GB, 1)
$used = [math]::Round($drive.Used/1GB, 1)
$free = [math]::Round($drive.Free/1GB, 1)
$percent = [math]::Round($drive.Free*100/($drive.Used+$drive.Free), 1)
Write-Host "总容量: ${total}GB | 已用: ${used}GB | 可用: ${free}GB (${percent}%)"

Write-Host "`n=== C盘根目录下各文件夹大小 (前20) ===" -ForegroundColor Green
Get-ChildItem -Path "C:\" -Directory -ErrorAction SilentlyContinue | ForEach-Object {
    $folder = $_
    $size = (Get-ChildItem -Path $folder.FullName -Recurse -File -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
    [PSCustomObject]@{Folder=$folder.Name; "Size(GB)"=[math]::Round($size/1GB, 2)}
} | Sort-Object "Size(GB)" -Descending | Select-Object -First 20 | Format-Table -AutoSize

Write-Host "`n=== 当前用户($env:USERNAME)的个人文件夹大小 ===" -ForegroundColor Green
$userProfile = "C:\Users\$env:USERNAME"
Get-ChildItem -Path $userProfile -Directory -ErrorAction SilentlyContinue | ForEach-Object {
    $folder = $_
    $size = (Get-ChildItem -Path $folder.FullName -Recurse -File -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
    [PSCustomObject]@{Folder=$folder.Name; "Size(GB)"=[math]::Round($size/1GB, 2)}
} | Sort-Object "Size(GB)" -Descending | Format-Table -AutoSize

Write-Host "`n=== AppData 子文件夹大小 (前20) ===" -ForegroundColor Green
$appData = "$env:LOCALAPPDATA"
Get-ChildItem -Path $appData -Directory -ErrorAction SilentlyContinue | ForEach-Object {
    $folder = $_
    $size = (Get-ChildItem -Path $folder.FullName -Recurse -File -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
    [PSCustomObject]@{Folder=$folder.Name; "Size(MB)"=[math]::Round($size/1MB, 1)}
} | Sort-Object "Size(MB)" -Descending | Select-Object -First 20 | Format-Table -AutoSize

Write-Host "`n=== 检查关键位置 ===" -ForegroundColor Green
# Windows 更新缓存
$softDist = "C:\Windows\SoftwareDistribution\Download"
if (Test-Path $softDist) {
    $size = (Get-ChildItem -Path $softDist -Recurse -File -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
    Write-Host "Windows更新缓存: $([math]::Round($size/1MB, 1)) MB"
}

# 回收站状态
Write-Host "回收站: 请手动在桌面检查或运行 cleanmgr"

# 休眠文件状态
$hiberFile = "C:\hiberfil.sys"
if (Test-Path $hiberFile) {
    $size = (Get-Item $hiberFile -ErrorAction SilentlyContinue).Length
    Write-Host "休眠文件(hiberfil.sys): $([math]::Round($size/1GB, 2)) GB"
} else {
    Write-Host "休眠文件: 未启用"
}

# 页面文件
$pageFile = "C:\pagefile.sys"
if (Test-Path $pageFile) {
    $size = (Get-Item $pageFile -ErrorAction SilentlyContinue).Length
    Write-Host "页面文件(pagefile.sys): $([math]::Round($size/1GB, 2)) GB"
}

# 内存转储文件
$memDump = "C:\MEMORY.DMP"
if (Test-Path $memDump) {
    $size = (Get-Item $memDump -ErrorAction SilentlyContinue).Length
    Write-Host "内存转储(MEMORY.DMP): $([math]::Round($size/1GB, 2)) GB"
}

# Windows.old
$winOld = "C:\Windows.old"
if (Test-Path $winOld) {
    $size = (Get-ChildItem -Path $winOld -Recurse -File -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
    Write-Host "Windows.old: $([math]::Round($size/1GB, 2)) GB"
} else {
    Write-Host "Windows.old: 不存在"
}

# Temp 目录
$tempPaths = @("$env:TEMP", "$env:WINDIR\Temp", "C:\Windows\Prefetch")
foreach ($p in $tempPaths) {
    if (Test-Path $p) {
        $size = (Get-ChildItem -Path $p -Recurse -File -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
        Write-Host "Temp目录($p): $([math]::Round($size/1MB, 1)) MB"
    }
}

Write-Host "`n=== 检查大型单个文件 ===" -ForegroundColor Green
Get-ChildItem -Path "C:\" -File -ErrorAction SilentlyContinue | Where-Object { $_.Length -gt 100MB } | Select-Object Name, @{N="Size(GB)";E={[math]::Round($_.Length/1GB,2)}} | Format-Table -AutoSize

Write-Host "`n扫描完成！" -ForegroundColor Green
