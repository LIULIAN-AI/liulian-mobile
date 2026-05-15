# 本机跑通 LIULIAN 移动端 — 实操指南

更新于 2026-05-14（branch `feat/native-mobile-foundation-2026-05-14`）

## 已验证状态（本机 Ubuntu 24.04 实跑）

| 项 | 状态 | 产物 |
|---|---|---|
| Token 构建 | ✅ verified | 11 个 dist 文件，87 tokens |
| Token sync 到三端 | ✅ verified | `Tokens.swift / .kt / .ets` 三处都已注入 |
| 字体下载 | ✅ verified | Fraunces (360KB) + Switzer + JetBrains Mono 已分发到三端 |
| Android liulian-ui Kotlin compile | ✅ **PASS** | `liulian-ui-debug.aar` |
| Android app 全量编译 | ✅ **PASS** | `app-debug.apk` (7.4 MB) |
| **Android Paparazzi VR baseline** | ✅ **PASS** | 4 张 PNG (text / button / card / gallery) 入仓 |
| Android emulator 启动 | ❌ 未跑 | 需 GUI 环境运行 emulator |
| iOS 编译 / snapshot tests | ⚙️ **CI 配好** | `.github/workflows/ios-snapshots.yml` 用 `macos-26` runner，public repo free |
| HarmonyOS 编译 | ⚙️ **CI stub** | `.github/workflows/harmony-build.yml`（需自托管 Linux runner，参 HARMONY_TESTING.md） |

## 一次性准备（任何平台之前先做）

```bash
cd "/media/linlin/New Volume1/projects/2026.02.07_liulian/codes/liulian-mobile"

# 1. 从 design-system/dist/ 同步生成的 token 文件到三端
bash shared/scripts/sync-tokens.sh

# 2. 下载 Fraunces / Switzer / JetBrains Mono 到三端
bash shared/scripts/fetch-fonts.sh
```

完成后三端各自的 token + font 都到位。

---

## 1. Web demo（已在本机服务 + GitHub Pages）

**最快方式：手机/电脑直接打开**
```
https://liulian-ai.github.io/liulian-web/
```

**本机已有 server 运行**（端口 8888 — 之前 session 启的 python3 -m http.server）：
```
http://localhost:8888/
```

可以浏览：
- `/index.html` — 主页 hub
- `/web-demo.html` — Web 演示（Landing / Forecast / Studio tabs）
- `/mobile-preview.html` — 移动端 iOS phone-frame 预览

---

## 2. Android — 本机已验证编译，下面是怎么真在设备上跑

### 你需要

- Android Studio Iguana+ （或仅命令行）
- 一部 Android 真机（开发者模式 + USB 调试）或 Android emulator
- ANDROID_HOME 环境变量（本机已设：`$HOME/android-sdk`）

### 方式 A：命令行 + 真机（最快）

```bash
cd liulian-mobile/android

# 连真机插 USB（启用 USB Debugging）
adb devices  # 应该列出你的设备

# 装到设备
export ANDROID_HOME=$HOME/android-sdk
./gradlew :app:installDebug
adb shell am start -n ai.liulian.app/io.liulian.app.MainActivity
```

### 方式 B：Android Studio 图形界面

1. **下载 Android Studio**（如果还没装）：
   ```
   https://developer.android.com/studio
   ```
   或：`snap install android-studio --classic`（Ubuntu 24.04）

2. **打开项目**：File → Open → 选 `liulian-mobile/android/` 目录。Gradle 同步自动跑。

3. **配置 emulator**：Tools → Device Manager → Create Device → 选 Pixel 8 / API 34。

4. **▶ Run**

### 已验证产物

- `liulian-ui/build/outputs/aar/liulian-ui-debug.aar`
- `app/build/outputs/apk/debug/app-debug.apk` (7.4 MB)

### 屏幕

- **Home tab**：仿 web mobile-preview Home 标签页（Aare-Bern 头图、Quick actions、Stations 列表）
- **Gallery tab**：LiulianText / LiulianButton / LiulianCard 全 variants × states 排版

---

## 3. iOS — 你需要 Mac

我在 Linux 上不能跑 Xcode。你在 Mac 上的步骤：

### 你需要

- macOS 14+
- Xcode 15.4+（App Store 免费下载）

### 步骤

```bash
# 1. 同步本仓最新
git pull
bash shared/scripts/sync-tokens.sh
bash shared/scripts/fetch-fonts.sh

# 2. 打开 Swift Package
cd ios/LiulianUI
open Package.swift
```

Xcode 会把 `LiulianUI` 当作 Swift Package 打开。然后：

- **测试 Swift Package**：⌘U（运行 LiulianUITests）
- **看 SwiftUI Preview**：打开 `LiulianGallery.swift`，按 ⌥⌘P 启动 Preview 画布。你会看到所有 components 渲染出来。

### 真在 iOS Simulator 上跑

由于 LiulianApp 还没有 .xcodeproj（pbxproj 容易手写错），按下面步骤建一个：

1. Xcode → File → New → Project → iOS → App
2. 名字 `LiulianApp`，Interface SwiftUI，Bundle ID `ai.liulian.app`
3. **删除**自动生成的 `ContentView.swift`
4. **拖入** `liulian-mobile/ios/LiulianApp/Sources/LiulianApp/`（包含 LiulianAppMain.swift + Views/）
5. **拖入** `liulian-mobile/ios/LiulianApp/Info.plist`（覆盖默认）
6. **拖入** `liulian-mobile/ios/LiulianApp/Resources/Fonts/` 文件夹（"Copy items if needed"勾选）
7. **加 LiulianUI 依赖**：File → Add Package Dependencies → Add Local… → 选 `ios/LiulianUI/`
8. 选 iPhone 15 Pro Simulator → ▶ Run

### 我已为你准备的

- 所有 `.swift` 源已 Linux 上写好（无法在 Linux 编译 SwiftUI，但代码风格符合 Apple SwiftUI 模式）
- `Info.plist` 已加 `UIAppFonts` 字段，字体到位即可
- LiulianUI Package.swift 已可直接 Xcode 打开

---

## 4. HarmonyOS — 你需要 DevEco Studio (Windows / macOS)

我在 Linux 上不能跑 DevEco。

### 你需要

- DevEco Studio 5.0+ — https://developer.huawei.com/consumer/cn/deveco-studio/
- 推荐 Windows 10/11 或 macOS（Linux beta 支持不全）
- HarmonyOS NEXT SDK（DevEco 内置 SDK Manager 装）

### 步骤

```bash
# 1. 同步
git pull
bash shared/scripts/sync-tokens.sh
bash shared/scripts/fetch-fonts.sh
```

2. 打开 DevEco Studio → File → Open → 选 `liulian-mobile/harmony/` 目录
3. DevEco 自动解析 `build-profile.json5` + `oh-package.json5`，索引 entry 和 liulian_ui 两个模块
4. SDK Manager 装好 HarmonyOS NEXT API 12+ 平台
5. 工具栏 emulator manager → 新建 Phone 设备 → 启动
6. ▶ Run → 选 entry 模块 → 跑

### 我已为你准备的

- `module.json5` + 全部 `oh-package.json5` + `build-profile.json5`
- 所有 `.ets` 源（`@Component` struct + ArkUI 模式）
- 三个 `.ets` 页（Index / Home / Gallery）
- 字体已放到 `entry/src/main/resources/rawfile/fonts/`

### 注意

- ArkTS 是 TypeScript 的严格子集 + Huawei 扩展，我的代码遵循 ArkUI Stage Model 规范，但**未在真 DevEco 编译过**。
- DevEco 打开时可能提示一两个小规范问题（比如可选/必选参数、类型推断），自行小调即可。

---

## 5. 视觉回归（VR）— 一次性产 4-grid 对比

当三端都跑通后，截图比对：

```bash
# 各 platform 用各自方式截 LiulianGallery 页：
# - Web:     Playwright screenshot of /web-demo.html
# - iOS:     SwiftUI Preview → Export Image
# - Android: ./gradlew :liulian-ui:liulianUiPreviewScreenshots
#            (需要先加 Paparazzi/Shot 依赖 — 见 PLUGINS.md)
# - Harmony: DevEco Preview → Export

# 把 4 张图放到 shared/refs/:
ls shared/refs/{web,ios,android,harmony}-Gallery.png

# 生成 4-grid 对比
montage shared/refs/{web,ios,android,harmony}-Gallery.png -tile 2x2 -geometry +10+10 shared/refs/4grid-Gallery.png

# 像素 diff（≤2% 算通过）
compare -metric AE -fuzz 2% shared/refs/web-Gallery.png shared/refs/android-Gallery.png shared/refs/diff-web-vs-android.png
echo "diff pixels:"
```

---

## 我在 Linux 上能做的进一步操作

如果你想我**继续在本机推进**，下面是我能做的事：

1. **装 Android Studio + 启动 emulator**（一次性 6+ GB，启动 emulator 需 GUI）
2. **APK 装到 USB 连接的真机** — 只要 `adb devices` 看到设备，我可以 `:app:installDebug` 一键装
3. **加 Paparazzi 到 liulian-ui 配置 + 跑 Compose snapshot 测试** — 在 Linux 上无 emulator 也能截 Gallery 视图，~10 分钟 setup

如果你想做这些告诉我哪个先做。

## 我无法在 Linux 上做的（必须你接力）

- iOS 任何编译 / Simulator 启动 — 需要 Mac
- HarmonyOS DevEco 任何启动 — Linux beta 严重残缺，需 Windows/macOS
- App Store / Google Play / 华为 AppGallery 上架签名 — 各需对应平台 + 证书
