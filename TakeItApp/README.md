# TakeItApp（拿了吗）v1.0

已完成：SwiftUI 1.0 功能代码（可直接放入 Xcode iOS App 项目运行）。

## 功能（v1.0）
- 必拿清单：新增/勾选启用
- 提醒地点：用当前位置添加地点、半径 50-200m
- 离开地点触发提醒（本地通知）
- 本地存储（UserDefaults）
- UI 主题：薄荷绿 + 柠檬黄（清新治愈风格）

## 代码结构
- `TakeItApp/App.swift`：应用入口，连接定位与提醒引擎
- `TakeItApp/HomeView.swift`：主界面
- `TakeItApp/Models.swift`：数据模型
- `TakeItApp/LocationManager.swift`：定位与地理围栏
- `TakeItApp/ReminderEngine.swift`：通知与本地存储

## 在 Xcode 运行（必须）
1. 新建 iOS App（SwiftUI）项目，名称可用 `TakeItApp`
2. 用本目录下 `TakeItApp/*.swift` 替换项目默认文件
3. 打开 `Signing & Capabilities`，添加：
   - `Background Modes` -> 勾选 `Location updates`
4. 在 `Info.plist` 增加权限文案：
   - `NSLocationWhenInUseUsageDescription` = `用于在你离开地点时提醒拿重要物品。`
   - `NSLocationAlwaysAndWhenInUseUsageDescription` = `用于后台离开地点提醒，避免遗漏重要物品。`
   - `NSUserNotificationUsageDescription` = `用于出门提醒你拿重要物品。`
5. 真机运行（模拟器无法完整验证地理围栏）

## 说明
- 你提到的“1米触发”在 iOS 常规定位下不稳定，v1 使用可落地半径（50m+）保证可靠。
- 后续 v1.1 可接 BLE / AirTag 类方案，进一步接近近距离提醒。
