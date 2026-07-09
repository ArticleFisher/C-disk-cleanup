# Git 安装与 GitHub 账号绑定完整指南

> 本指南记录从零开始下载 Git、安装到指定目录、配置 GitHub 账号的完整流程。

---

## 目录

- [1. 下载 Git](#1-下载-git)
- [2. 安装 Git](#2-安装-git)
- [3. 验证安装](#3-验证安装)
- [4. 注册/登录 GitHub](#4-注册登录-github)
- [5. 生成 Personal Access Token](#5-生成-personal-access-token)
- [6. 使用 gh CLI 绑定账号](#6-使用-gh-cli-绑定账号)
- [7. 配置 Git 用户信息](#7-配置-git-用户信息)
- [8. 常见问题](#8-常见问题)

---

## 1. 下载 Git

### 1.1 获取最新版本号

```bash
# 通过 GitHub API 获取最新 Git for Windows 版本
curl -sL -o /dev/null -w "%{url_effective}" "https://github.com/git-for-windows/git/releases/latest"
```

### 1.2 下载 64 位安装包

```bash
# 下载到 D 盘
curl -L -o /d/Git-2.55.0.2-64-bit.exe \
  "https://github.com/git-for-windows/git/releases/download/v2.55.0.windows.2/Git-2.55.0.2-64-bit.exe"
```

> **注意：** 版本号以实际最新版为准。文件名格式为 `Git-{大版本}.{小版本}.{修订}-64-bit.exe`。

---

## 2. 安装 Git

### 2.1 静默安装（推荐）

使用 Inno Setup 的静默安装参数（`/SILENT`），指定安装目录为 `D:\Git`：

```powershell
# PowerShell 方式
$installer = "D:\Git-2.55.0.2-64-bit.exe"
$targetDir = "D:\Git"
Start-Process -FilePath $installer -ArgumentList "/DIR=`"$targetDir`" /SILENT /SUPPRESSMSGBOXES /COMPONENTS=`"icons,ext,gitlfs,assoc`" /TASKS=`"modifypath`" /NORESTART" -Wait -PassThru -NoNewWindow
```

**命令行参数说明：**

| 参数 | 说明 |
|------|------|
| `/DIR=路径` | 指定安装目录 |
| `/SILENT` | 静默安装（显示进度条） |
| `/VERYSILENT` | 完全静默（不显示任何界面） |
| `/SUPPRESSMSGBOXES` | 禁止弹窗 |
| `/COMPONENTS=...` | 选择安装组件（icons=图标, ext=扩展, gitlfs=LFS, assoc=文件关联） |
| `/TASKS=modifypath` | 将 Git 添加到 PATH |
| `/NORESTART` | 安装完成后不重启 |

### 2.2 交互式安装

双击安装包，按以下步骤操作：

1. 选择安装路径 → `D:\Git`
2. 选择组件 → 保持默认（或按需勾选 Git LFS）
3. 选择默认编辑器 → 选 VS Code 或 Nano
4. 调整 PATH 环境 → **"Git from the command line and also from 3rd-party software"**
5. HTTPS 传输后端 → 选 "Use the OpenSSL library"
6. 行尾转换 → 选 "Checkout Windows-style, commit Unix-style line endings"（建议）
7. 终端模拟器 → 选 "Use MinTTY"
8. 其余保持默认 → 安装

---

## 3. 验证安装

### 3.1 检查 Git 版本

```powershell
# 直接运行
"D:\Git\cmd\git.exe" --version

# 预期输出：git version 2.55.0.windows.2
```

### 3.2 检查安装目录结构

```
D:\Git\
├── bin\           # Git 核心可执行文件
├── cmd\           # git.exe / git-cmd.exe
├── mingw64\       # MinGW 工具链
├── usr\           # Unix 工具（bash、sed 等）
├── etc\           # 配置文件
├── git-bash.exe   # Git Bash 快捷方式
├── git-cmd.exe    # Git CMD 快捷方式
└── unins000.exe   # 卸载程序
```

---

## 4. 注册/登录 GitHub

### 4.1 注册账号

1. 打开 https://github.com/signup
2. 输入邮箱地址，设置密码，验证邮箱
3. 选择 Free（免费）计划

### 4.2 登录

访问 https://github.com/login 输入账号信息。

---

## 5. 生成 Personal Access Token (PAT)

从 2021 年起，GitHub 不再支持在命令行使用密码认证，必须使用 Token。

### 操作步骤

1. 登录 GitHub 后访问：**https://github.com/settings/tokens**
2. 点击 **"Generate new token (classic)"**
3. 填写 Note（备注，随意填写，如 "My PC"）
4. 选择过期时间：建议选 **"No expiration"**（永不过期）
5. 勾选权限范围（Scopes）：

   | 权限 | 说明 |
   |------|------|
   | ✅ `repo` | 私有仓库读写（必选） |
   | ✅ `workflow` | GitHub Actions 管理 |
   | ✅ `read:org` | 读取组织信息 |
   | ✅ `read:user` | 读取用户信息 |
   | ✅ `user:email` | 读取邮箱地址 |

6. 点击 **"Generate token"**
7. **立即复制并保存 Token！**（关闭页面后无法再次查看）

Token 以 `ghp_` 开头，例如：
```
ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

---

## 6. 使用 gh CLI 绑定账号

### 6.1 安装 GitHub CLI

Git 安装包自带 GitHub CLI，位置在：
```
C:\Program Files\GitHub CLI\gh.exe
```

### 6.2 验证 gh 是否可用

```powershell
"C:\Program Files\GitHub CLI\gh.exe" auth status
```

### 6.3 Token 方式登录（推荐）

```powershell
# 方法一：管道输入 Token
echo "ghp_你的TOKEN" | "C:\Program Files\GitHub CLI\gh.exe" auth login --hostname github.com --git-protocol https --with-token

# 方法二：从文件读取
echo ghp_你的TOKEN > token.txt
"C:\Program Files\GitHub CLI\gh.exe" auth login --hostname github.com --git-protocol https --with-token < token.txt
```

### 6.4 设备码方式登录（备选）

```bash
"C:\Program Files\GitHub CLI\gh.exe" auth login --hostname github.com --git-protocol https
```

按照提示：
1. 复制终端显示的一次性验证码（如 `235C-DE4B`）
2. 浏览器访问 **https://github.com/login/device**
3. 输入验证码，点击 "Continue"
4. 在浏览器中登录 GitHub 并授权

### 6.5 验证登录状态

```powershell
"C:\Program Files\GitHub CLI\gh.exe" auth status
```

预期输出：
```
github.com
  ✓ Logged in to github.com account YourUserName
  - Git operations protocol: https
  - Token: ghp_************************************
  - Token scopes: 'read:org', 'read:user', 'repo', 'user:email', 'workflow'
```

### 6.6 测试 API 连通性

```powershell
# 验证 Token 有效，查看用户信息
"C:\Program Files\GitHub CLI\gh.exe" api user

# 列出你的仓库
"C:\Program Files\GitHub CLI\gh.exe" repo list
```

---

## 7. 配置 Git 用户信息

```powershell
# 设置全局用户名和邮箱（用于 commit 记录）
"D:\Git\cmd\git.exe" config --global user.name "YourGitHubUsername"
"D:\Git\cmd\git.exe" config --global user.email "your.email@example.com"

# 查看配置
"D:\Git\cmd\git.exe" config --global --list
```

---

## 8. 常见问题

### 8.1 网络连接被中断

```
fatal: unable to access '...': Recv failure: Connection was aborted
```

**解决方法：** 强制使用 HTTP/1.1 协议：

```bash
git -c http.version=HTTP/1.1 push
```

可在全局配置中永久设置：

```bash
git config --global http.version HTTP/1.1
```

### 8.2 静默安装时安装了默认路径

若系统中已安装旧版 Git，静默安装可能覆盖到旧版路径而非 `/DIR` 指定的路径。

解决方法：先卸载旧版 Git，再重新安装到目标目录。

### 8.3 Token 权限不足

```
error validating token: missing required scope 'xxx'
```

回到 https://github.com/settings/tokens 编辑 Token，补充缺失的权限。

### 8.4 设备码认证失败

```
failed to authenticate via web browser: Post "https://github.com/login/device/code": connection aborted
```

说明本地网络对 GitHub 的 HTTPS 连接被防火墙/杀毒软件拦截，建议改用 Token 方式。

---

> **附录：** 本指南配套脚本请见仓库中的 PowerShell 扫描工具（`scan_c.ps1` / `scan2.ps1`）
