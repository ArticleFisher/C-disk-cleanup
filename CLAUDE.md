# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with this repository.

Windows C 盘分析 + 清理工具集。扫描脚本输出 → 清理清单操作。

## 运行

```powershell
powershell -ExecutionPolicy Bypass -File scan_c.ps1       # 快速概览
powershell -ExecutionPolicy Bypass -File scan2.ps1        # 深度扫描
powershell -ExecutionPolicy Bypass -File c_drive_scan.ps1 # scan2 中文版
```

## 文件

| 文件 | 用途 |
|------|------|
| `scan_c.ps1` | 快速扫描：C 盘根目录、AppData 各 Top15、系统文件(hiberfil/pagefile/DMP)、Temp |
| `scan2.ps1` | 深度扫描：其他用户、NVIDIA/Kingsoft/Tencent 缓存、桌面大文件夹 |
| `C盘清理优化清单.md` | 5 层清理清单，Tier 1→5 风险递增，每项含路径/大小/操作命令 |

## 架构

1. **快扫** → 全局概览
2. **深扫** → 针对应用缓存和用户数据
3. **清单** → 五层：立即可释放 → 应用数据 → 用户文件 → 系统设置 → 维护策略

## 技术要点

- 目录大小：`Get-ChildItem -Recurse -File | Measure-Object Length -Sum`
- `$ErrorActionPreference = "SilentlyContinue"` 跳过无权限路径
- 系���文件检查（hiberfil/pagefile）需管理员权限
