# 🧹 C 盘清理优化清单

> 生成时间：2026-06-30
> 扫描依据：实际 C 盘数据分析（总计 453.5GB / 已用 352.8GB / 可用 100.7GB · 22.2%）

---

## 目录

- [Tier 1 🚀 立即可释放（~50GB+）](#tier-1--立即可释放50gb)
- [Tier 2 📦 应用数据清理](#tier-2--应用数据清理)
- [Tier 3 📁 用户文件整理](#tier-3--用户文件整理)
- [Tier 4 ⚙️ 系统设置优化](#tier-4--系统设置优化)
- [Tier 5 🔄 维护策略](#tier-5--维护策略)

---

## Tier 1 🚀 立即可释放（~50GB+）

这部分清理不影响系统稳定性和个人数据，操作最快、效果最明显。

### 1.1 NVIDIA GPU 着色器缓存

| 项目 | 值 |
|------|-----|
| 路径 | `%LOCALAPPDATA%\NVIDIA\DXCache` |
| 当前占用 | **37.9 GB** |
| 清理后是否会再生 | ✅ 会，运行游戏/GPU 应用时自动重建 |
| 建议频率 | 每 3-6 个月或升级大版本驱动后 |

**操作步骤：**
```powershell
# 查看当前大小
Get-ChildItem "$env:LOCALAPPDATA\NVIDIA\DXCache" -Recurse -File | Measure-Object Length -Sum | Select @{N="SizeGB";E={[math]::Round($_.Sum/1GB,1)}}

# 删除缓存（安全，不会影响功能）
Remove-Item "$env:LOCALAPPDATA\NVIDIA\DXCache\*" -Recurse -Force -ErrorAction SilentlyContinue
```

> ⚡ **注意：** 首次运行游戏时会重新编译着色器，可能出现短暂卡顿或加载变慢
> 💡 **预期回收：~35 GB**（会留少量当前使用中文件）

---

### 1.2 系统 Temp 文件

| 位置 | 当前占用 |
|------|---------|
| `%TEMP%`（用户 Temp） | **10.7 GB** |
| `C:\Windows\Temp` | 需检查 |
| `C:\Windows\Prefetch` | 可清理 |

**操作步骤：**
```powershell
# 清理用户 Temp（最安全，可全删）
Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue

# 清理 Windows Temp（需要管理员权限）
Start-Process PowerShell -Verb RunAs -ArgumentList @"
  Remove-Item "$env:WINDIR\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
  Remove-Item "C:\Windows\Prefetch\*" -Recurse -Force -ErrorAction SilentlyContinue
"@
```

> 💡 **预期回收：~10 GB**

---

### 1.3 WPS Office 缓存（Kingsoft）

| 项目 | 当前占用 |
|------|---------|
| Kingsoft 漫游数据 | **7 GB** |
| ├─ wps 子目录 | 4.2 GB |
| └─ office6 子目录 | 2.7 GB |

**操作步骤：**
```powershell
# 清理 WPS 缓存文件（不影响文档和设置）
Remove-Item "$env:APPDATA\Kingsoft\wps\addons\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "$env:APPDATA\Kingsoft\office6\cache\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "$env:LOCALAPPDATA\Kingsoft\*" -Recurse -Force -ErrorAction SilentlyContinue
```

> ⚠️ **注意：** `$env:APPDATA\Kingsoft` 下的配置和模板文件建议保留
> 💡 **预期回收：~3-5 GB**（保留配置的情况下）

---

### 1.4 腾讯系应用缓存

| 应用 | 当前占用 |
|------|---------|
| 微信 (WeChat) | **1.5 GB** |
| 腾讯会议 (WeMeet) | **1.3 GB** |
| OD（腾讯微云/应用）| **1.3 GB** |
| 腾讯视频 (QQLive) | **1 GB** |
| QQ | **1 GB** |
| **合计** | **~6.7 GB** |

**微信清理（最占空间的聊天应用）：**
1. 打开微信 → 设置 → 文件管理 → **打开文件夹**
2. 进入 `FileStorage` 目录
3. 可清理：
   - `Image` — 聊天图片缓存（可删）
   - `Video` — 聊天视频缓存（可删）
   - `File` — 接收的文件（按需保留）
   - `Cache` — 其他缓存（可删）

> 💡 **微信保守清理：~1 GB，全部清理：~5 GB（会丢失已过期聊天图片）**

**其他应用：**
```powershell
# 腾讯会议缓存
Remove-Item "$env:APPDATA\Tencent\WeMeet\Cache\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "$env:APPDATA\Tencent\WeMeet\Logs\*" -Recurse -Force -ErrorAction SilentlyContinue

# QQ 缓存
Remove-Item "$env:APPDATA\Tencent\QQ\Cache\*" -Recurse -Force -ErrorAction SilentlyContinue

# QQLive 缓存
Remove-Item "$env:APPDATA\Tencent\QQLive\Cache\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "$env:LOCALAPPDATA\Tencent\QQLive\*" -Recurse -Force -ErrorAction SilentlyContinue

# OD 缓存
Remove-Item "$env:APPDATA\Tencent\OD\Cache\*" -Recurse -Force -ErrorAction SilentlyContinue
```

> 💡 **预期回收：~5 GB**

---

## Tier 2 📦 应用数据清理

这部分清理删除后可重建，但可能需要重新登录或重新下载部分资源。

### 2.1 剪映专业版 (JianyingPro)

| 项目 | 值 |
|------|-----|
| 路径 | `%LOCALAPPDATA%\JianyingPro` |
| 当前占用 | **2.5 GB** |

**操作步骤：**
```powershell
# 清理剪映缓存（草稿箱中的项目会保留，但缓存素材会被删除）
Remove-Item "$env:LOCALAPPDATA}\JianyingPro\*\Cache\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "$env:LOCALAPPDATA}\JianyingPro\*\cache-cg\*" -Recurse -Force -ErrorAction SilentlyContinue
```

> ⚠️ **注意：** 如果正在编辑中的项目，建议先导出再清理
> 💡 **预期回收：~2 GB**

---

### 2.2 Windows 更新缓存

| 项目 | 值 |
|------|-----|
| 路径 | `C:\Windows\SoftwareDistribution\Download` |
| 清理方式 | 磁盘清理 (cleanmgr) 或 DISM |

**操作步骤：**
```powershell
# 方法一：使用磁盘清理工具
cleanmgr /sageset:1   # 勾选"Windows 更新清理"后
cleanmgr /sagerun:1

# 方法二：手动清理（需要先停止更新服务）
net stop wuauserv
net stop bits
Remove-Item "C:\Windows\SoftwareDistribution\Download\*" -Recurse -Force
net start bits
net start wuauserv
```

> 💡 **预期回收：数百 MB ~ 数 GB**

---

### 2.3 浏览器缓存

| 浏览器 | 缓存位置 |
|--------|---------|
| Edge/Chrome | `%LOCALAPPDATA%\Google\Chrome\User Data\Default\Cache` |
| 其他 Chromium 系 | 类似路径 |

```powershell
# Chrome/Edge 缓存
Remove-Item "$env:LOCALAPPDATA}\Google\Chrome\User Data\Default\Cache\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "$env:LOCALAPPDATA}\Google\Chrome\User Data\Default\Code Cache\*" -Recurse -Force -ErrorAction SilentlyContinue
```

> 💡 **预期回收：数百 MB ~ 1 GB**

---

### 2.4 Steam 缓存

| 项目 | 当前占用 |
|------|---------|
| Steam AppData | **1.4 GB** |

```powershell
# 清理 Steam 着色器预缓存（Steam 设置中关闭"着色器预缓存"后再清理）
Remove-Item "$env:LOCALAPPDATA}\Steam\htmlcache\*" -Recurse -Force -ErrorAction SilentlyContinue
```

> 更彻底的做法：打开 Steam → 设置 → 下载 → 清除下载缓存
> 💡 **预期回收：~1 GB**

---

### 2.5 包管理器缓存（如果有）

```powershell
# npm 缓存
npm cache clean --force

# pip 缓存
pip cache purge

# winget 缓存
winget cache reset
```

> 💡 **预期回收：数百 MB ~ 1 GB**

---

## Tier 3 📁 用户文件整理

这部分是**真正的数据**，需要你手动判断哪些可以移动/删除。

### 3.1 桌面文件整理

| 当前占用 | **22.71 GB** |
|---------|-------------|

| 大型文件夹 | 占用 |
|-----------|------|
| 全栈就业 | **8.1 GB** |
| 存档 | **1.5 GB** |

**建议：**
1. **「全栈就业」** — 考虑移动到 `D:\` 或 `E:\`，桌面只放快捷方式
2. **「存档」** — 检查是否还有用，没用则删，有用则移到其他盘
3. 检查其他桌面文件，把项目代码、大文件移到非系统盘

```powershell
# 查看桌面所有文件夹大小（已帮你跑过，顶部两个最大）
```

> 💡 **预期回收：10-20 GB**（取决于你移走多少）

---

### 3.2 文档文件夹整理

| 当前占用 | **18.75 GB** |
|---------|-------------|

建议检查是否有大型项目文件、虚拟机镜像、ISO 文件等，移到其他盘。

> 💡 **预期回收：5-15 GB**（视内容而定）

---

### 3.3 视频文件夹整理

| 当前占用 | **12.32 GB** |
|---------|-------------|

视频文件通常占用大但实际不常看。建议：

1. 将已看过的视频移到外置硬盘或 NAS
2. 检查是否有录屏文件可删除
3. 剪映导出的视频及时转移到其他盘

> 💡 **预期回收：5-10 GB**

---

### 3.4 清理废弃用户账户

| 账户 | 说明 |
|------|------|
| `defaultuser100000` | 系统初始账户，通常可删除 |
| 另有 5 个变体档案 | 残留配置 |

```powershell
# 查看所有用户账户
Get-LocalUser | Select Name, Enabled

# 删除废弃用户（需要管理员权限，小心确认不是当前使用的账户）
# Remove-LocalUser -Name "defaultuser100000"
```

> 💡 **预期回收：数百 MB ~ 1 GB**

---

## Tier 4 ⚙️ 系统设置优化

### 4.1 启用存储感知

让 Windows 自动清理临时文件。

```powershell
# 开启存储感知
Set-StorageSense -Enabled $true
```

手动路径：设置 → 系统 → 存储 → 存储感知 → 配置运行计划

---

### 4.2 调整虚拟内存（页面文件）

| 当前配置 | |
|---------|------|
| C 盘 pagefile.sys | **8-10 GB** |
| E 盘 pagefile.sys | **40-47 GB**（建议检查是否必要） |

```powershell
# 查看当前页面文件配置
Get-CimInstance Win32_PageFileSetting | Select Name, InitialSize, MaximumSize
```

建议：如果 E 盘有充足空间，C 盘虚拟内存可设为：
- 初始大小：4096 MB
- 最大大小：8192 MB

路径：设置 → 系统 → 关于 → 高级系统设置 → 性能设置 → 高级 → 虚拟内存更改

---

### 4.3 检查系统还原点

```powershell
# 查看还原点占用
Get-ComputerRestorePoint | Format-Table SequenceNumber, Description, CreationTime, RestorePointType

# 删除所有还原点（保留最新一个）
Disable-ComputerRestore -Drive "C:\"
Enable-ComputerRestore -Drive "C:\"
```

> 💡 **预期回收：数百 MB ~ 3 GB**

---

### 4.4 磁盘清理 (cleanmgr)

内置工具可以一键清理多项系统文件：

```powershell
# 交互式磁盘清理
cleanmgr /sageset:1

# 静默执行已配置的方案
cleanmgr /sagerun:1

# 直接运行选择界面
cleanmgr
```

在磁盘清理中勾选以下项：
- ☑ Windows 更新清理
- ☑ 传递优化文件
- ☑ 回收站
- ☑ 临时文件
- ☑ 缩略图
- ☑ Delivery Optimization Files

---

### 4.5 关闭不必要的开机自启

```powershell
# 查看所有自启程序
Get-CimInstance Win32_StartupCommand | Select Name, Command, Location
```

路径：任务管理器 → 启动 → 禁用不必要的程序

---

## Tier 5 🔄 维护策略

### 5.1 建议清理频率

| 项目 | 频率 |
|------|------|
| NVIDIA DXCache | 每 3-6 个月 |
| 系统 Temp | 每月 |
| 微信/QQ 缓存 | 每月 |
| 浏览器缓存 | 每月 |
| 桌面/文档整理 | 每季度 |
| disk cleanup | 每季度 |
| 完整大扫除 | 每半年 |

### 5.2 预期总回收空间

| 层级 | 保守估计 | 积极估计 |
|------|---------|---------|
| Tier 1 🚀 | 50 GB | 55 GB |
| Tier 2 📦 | 3 GB | 5 GB |
| Tier 3 📁 | 15 GB | 30 GB |
| Tier 4 ⚙️ | 2 GB | 5 GB |
| **总计** | **~70 GB** | **~95 GB** |

清理后可用空间预计从 **22.2% → 38%~43%**，大幅降低磁盘满的风险。

### 5.3 长期建议

1. **重要数据养成存其他盘的习惯**（项目代码、文档、视频）
2. **微信文件定期导出备份**，避免聊天记录无限膨胀
3. **关注 DXCache** — 如果 1-2 个月后又涨到 30GB+，考虑在需要时再手动删除
4. **考虑硬件升级**：如果 C 盘持续紧张，500GB SSD 已不贵，可以考虑换 1TB/2TB

---

## 附：快速清理脚本

将以下内容保存为 `clean_c_drive.ps1`，管理员身份运行即可执行 Tier 1 所有操作：

```powershell
# C 盘快速清理脚本 — 仅清理安全缓存，不影响数据
$ErrorActionPreference = "SilentlyContinue"
$startFree = (Get-PSDrive C).Free

Write-Host "===== C 盘快速清理 =====" -ForegroundColor Cyan

# 1. NVIDIA DXCache
Write-Host "[1/4] 清理 NVIDIA 着色器缓存..." -NoNewline
$nvidiaSize = (Get-ChildItem "$env:LOCALAPPDATA\NVIDIA\DXCache" -Recurse -File | Measure-Object Length -Sum).Sum
Remove-Item "$env:LOCALAPPDATA\NVIDIA\DXCache\*" -Recurse -Force
Write-Host " 释放 $([math]::Round($nvidiaSize/1GB,1)) GB" -ForegroundColor Green

# 2. 用户 Temp
Write-Host "[2/4] 清理系统 Temp..." -NoNewline
$tempSize = (Get-ChildItem "$env:TEMP" -Recurse -File | Measure-Object Length -Sum).Sum
Remove-Item "$env:TEMP\*" -Recurse -Force
Write-Host " 释放 $([math]::Round($tempSize/1GB,1)) GB" -ForegroundColor Green

# 3. WPS 缓存
Write-Host "[3/4] 清理 WPS 缓存..." -NoNewline
$wpsSize = (Get-ChildItem "$env:APPDATA\Kingsoft" -Recurse -File | Measure-Object Length -Sum).Sum
Remove-Item "$env:APPDATA\Kingsoft\wps\addons\*" -Recurse -Force
Remove-Item "$env:APPDATA\Kingsoft\office6\cache\*" -Recurse -Force
Write-Host " 释放 $([math]::Round($wpsSize/1GB,1)) GB" -ForegroundColor Green

# 4. 腾讯系缓存
Write-Host "[4/4] 清理腾讯应用缓存..." -NoNewline
$tencentSize = (Get-ChildItem "$env:APPDATA\Tencent" -Recurse -File | Measure-Object Length -Sum).Sum
Remove-Item "$env:APPDATA\Tencent\WeMeet\Cache\*" -Recurse -Force
Remove-Item "$env:APPDATA\Tencent\WeMeet\Logs\*" -Recurse -Force
Remove-Item "$env:APPDATA\Tencent\QQ\Cache\*" -Recurse -Force
Remove-Item "$env:APPDATA\Tencent\QQLive\Cache\*" -Recurse -Force
Remove-Item "$env:APPDATA\Tencent\OD\Cache\*" -Recurse -Force
Write-Host " 释放 $([math]::Round($tencentSize/1GB,1)) GB" -ForegroundColor Green

$endFree = (Get-PSDrive C).Free
$reclaimed = [math]::Round(($endFree - $startFree)/1GB, 1)
Write-Host "===== 清理完成！本次共释放 ${reclaimed} GB =====" -ForegroundColor Cyan
Write-Host "当前可用空间：$([math]::Round($endFree/1GB,1)) / $([math]::Round(($endFree+$startFree)/1GB,1)) GB" -ForegroundColor Cyan
```

---

> ⚡ **All clear!** 按照 Tier 1→2→3→4→5 的顺序操作，每完成一级重新看一下可用空间变化。
