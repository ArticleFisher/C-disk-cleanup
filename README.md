# C 盘空间分析 & 清理清单

本仓库包含 C 盘空间扫描脚本和基于实际数据分析生成的清理优化清单。

## 文件说明

| 文件 | 说明 |
|------|------|
| `C盘清理优化清单.md` | 完整的 5 层级清理优化清单（针对实际扫描数据定制） |
| `scan_c.ps1` | C 盘空间扫描脚本（快速概览） |
| `scan2.ps1` | 深入扫描脚本（AppData 细分、各应用缓存、桌面文件夹） |
| `c_drive_scan.ps1` | 中文版扫描脚本（同上，带中文注释） |

## 使用

```powershell
powershell -ExecutionPolicy Bypass -File scan_c.ps1
powershell -ExecutionPolicy Bypass -File scan2.ps1
```
