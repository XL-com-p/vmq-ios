# V免签 iOS 云编译指南

## 方案说明

由于 iOS 应用必须在 macOS + Xcode 环境下编译，本项目配置了 GitHub Actions 云编译。

## 准备工作

### 1. 注册 GitHub 账号
访问 https://github.com 注册账号

### 2. 创建代码仓库
1. 登录 GitHub
2. 点击 "New repository" 创建新仓库
3. 仓库名：`vmq-ios`
4. 选择 "Public"
5. 点击 "Create repository"

### 3. 上传代码
```bash
# 在本地打开终端，克隆仓库
git clone https://github.com/你的用户名/vmq-ios.git
cd vmq-ios

# 复制项目文件
# 将 vmqApk-ios 文件夹下的所有内容复制到此处

# 提交推送
git add .
git commit -m "add ios source"
git push origin main
```

## 编译问题说明

⚠️ **重要**：iOS 云编译有几个问题需要注意：

### 问题 1：需要 Apple 证书
- 默认的 GitHub Actions 使用模拟器编译，只能在模拟器运行
- **真机安装需要 Apple 开发者证书**

### 问题 2：证书如何处理

有两种方案：

#### 方案 A：仅模拟器测试（免费）
1. 编译成功后下载 .app 文件
2. 用 Xcode 安装到模拟器
3. **不能安装到真机**

#### 方案 B：真机安装（需要付费）
需要设置证书：
1. 在 Mac 上导出你的 Apple 开发者证书（.p12）
2. 在 GitHub 仓库设置中添加 Secrets：
   - `APPLE_CERTIFICATE`：证书 base64 编码
   - `APPLE_CERTIFICATE_PASSWORD`：证书密码
   - `BUILD_PROVISION`：描述文件
3. 修改 workflow 使用签名

## 替代方案（推荐）

如果不想那么复杂，推荐以下方案：

### 方案 1：找有 Mac 的朋友帮忙
- 复制整个 `vmqApk-ios` 文件夹到 Mac
- 用 Xcode 打开编译

### 方案 2：使用付费云编译服务
- **Codemagic**（免费套餐有限）
- **AppCenter**（微软）
- 这些服务可以帮你自动处理证书

### 方案 3：Xcode Cloud
- 如果你用 macOS，可以用 Xcode Cloud

## 快速开始（推荐）

最简单的方法：

1. 把 `vmqApk-ios` 文件夹复制到有 Mac 的电脑上
2. 用 Xcode 打开 `VmqIOS.xcodeproj`
3. 连接 iPhone，点击运行

## 如果需要签名 .ipa 用全能签安装

1. 在 Xcode 中：Product → Archive
2. 导出时选择 "Ad Hoc" 或 "Development"
3. 导出的 .ipa 导入 iPhone
4. 用全能签签名安装
