# V免签 iOS 监控端

## 简介

这是 V免签 项目的 iOS 版本，用于连接 V免签 服务端进行收款监控。

⚠️ **重要限制**：iOS 系统无法自动监听微信/支付宝通知，此应用采用被动接收模式。

## 功能

| 功能 | 说明 |
|---|---|
| 扫码配置 | 扫描服务端二维码连接 |
| 手动配置 | 手动输入服务端地址 |
| 心跳检测 | 保持与服务端的连接 |
| 消息通知 | 收到回调时显示本地通知 |

## 环境要求

- **编译环境**：macOS + Xcode 15+
- **运行设备**：iOS 15.0+
- **Apple 开发者账号**（如需真机安装）

## 快速开始

### 方式一：Xcode 本地编译（推荐）

1. 复制项目到 Mac
2. 用 Xcode 打开 `vmqApk-ios/VmqIOS.xcodeproj`
3. 选择你的开发者账号签名
4. 连接 iPhone 运行

### 方式二：云编译

参见 `.github/workflows/build.yml`

### 方式三：全能签安装

1. 用 Xcode 导出 .ipa（需要开发者账号）
2. 导入 iPhone
3. 用全能签签名安装

## 关于 iOS 版本的限制

由于 Apple 系统限制，iOS 版本**无法自动监听**微信/支付宝收款通知，只能：

1. 配置好与服务端的连接
2. 开启心跳保持长连接
3. 等待服务端推送通知到手机

这是 iOS 与 Android 的根本区别，无法通过技术手段解决。

## 项目结构

```
vmqApk-ios/
├── VmqIOS/
│   ├── AppDelegate.swift       # 应用代理
│   ├── SceneDelegate.swift     # 场景代理
│   ├── MainViewController.swift # 主界面
│   ├── NetworkService.swift     # 网络服务
│   ├── QRScannerViewController.swift # 二维码扫描
│   └── Info.plist              # 应用配置
├── VmqIOS.xcodeproj/           # Xcode 项目文件
└── README.md                    # 说明文档
```

## 常见问题

### Q: 为什么收不到通知？
A: 检查服务端是否开启，URL 是否正确配置。

### Q: 可以实现自动监听吗？
A: 不可以，这是 iOS 系统限制。

### Q: 需要付费吗？
A: 基础功能免费，如需真机安装需要 Apple 开发者账号（688元/年）。
