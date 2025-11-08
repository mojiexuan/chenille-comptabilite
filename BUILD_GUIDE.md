# 毛虫记账 - 构建指南

## 📦 构建命令

### 1. Debug 版本（调试）

```bash
# 运行调试版本
flutter run

# 构建调试APK
flutter build apk --debug
```

### 2. Release 版本（正式发布）

```bash
# 构建正式版APK（通用版）
flutter build apk --release

# 构建分架构APK（更小）
flutter build apk --release --split-per-abi
```

输出目录：`build/app/outputs/flutter-apk/`

### 3. App Bundle（Google Play 上架）

```bash
flutter build appbundle --release
```

输出目录：`build/app/outputs/bundle/release/`

---

## 🔐 签名配置（正式发布）

### 步骤 1：生成签名密钥

在项目根目录运行：

```bash
# Windows (PowerShell)
& "C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe" -genkey -v -keystore android/app/upload-keystore.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias upload

# macOS/Linux
keytool -genkey -v -keystore android/app/upload-keystore.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

**填写信息示例：**

- 密钥库口令: `您的密码`（请妥善保管）
- 您的名字与姓氏: `您的名字`
- 您的组织单位名称: `个人开发者`
- 您的组织名称: `您的工作室名称`
- 您所在的城市或区域名称: `您的城市`
- 您所在的省/市/自治区名称: `您的省份`
- 该单位的双字母国家/地区代码: `CN`

### 步骤 2：创建密钥配置文件

在 `android/` 目录下创建 `key.properties` 文件：

```properties
storePassword=您的密钥库口令
keyPassword=您的密钥口令
keyAlias=upload
storeFile=upload-keystore.jks
```

**⚠️ 重要：将 `key.properties` 添加到 `.gitignore`，不要提交到代码仓库！**

### 步骤 3：配置 build.gradle.kts

在 `android/app/build.gradle.kts` 中添加（已预留位置）：

```kotlin
// 在文件顶部添加
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    // ... 其他配置

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
            storeFile = file(keystoreProperties["storeFile"] as String)
            storePassword = keystoreProperties["storePassword"] as String
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            // 启用代码压缩和混淆
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}
```

---

## 📊 版本管理

### 更新版本号

编辑 `pubspec.yaml`：

```yaml
version: 1.0.1+2
#        ^^^^^ ^
#        |     |
#        |     +-- versionCode (构建号，每次发布递增)
#        +-------- versionName (显示给用户的版本号)
```

示例：

- `1.0.0+1` → 首个版本
- `1.0.1+2` → 修复 bug
- `1.1.0+3` → 新功能
- `2.0.0+4` → 重大更新

---

## 📱 应用元数据配置

### 应用信息

**pubspec.yaml**:

```yaml
name: chenille_comptabilite
description: 毛虫记账 - 简洁卡通的记账应用
version: 1.0.0+1
author: "您的名字"
```

**android/app/build.gradle.kts**:

```kotlin
defaultConfig {
    applicationId = "com.chenille.comptabilite"  // 应用包名（唯一标识）
    versionCode = flutter.versionCode             // 构建号
    versionName = flutter.versionName             // 版本名

    buildConfigField("String", "APP_AUTHOR", "\"您的名字\"")
    buildConfigField("String", "APP_REGION", "\"中国\"")
}
```

### AndroidManifest.xml

在 `android/app/src/main/AndroidManifest.xml` 中：

```xml
<application
    android:label="毛虫记账"                    <!-- 应用显示名称 -->
    android:icon="@mipmap/ic_launcher"          <!-- 应用图标 -->
    android:roundIcon="@mipmap/ic_launcher">    <!-- 圆形图标 -->
```

---

## 🎨 更新应用图标

1. 将图标放到 `assets/images/icon.png`（1024x1024 像素）
2. 运行生成命令：
   ```bash
   flutter pub run flutter_launcher_icons
   ```

---

## 🧹 清理构建缓存

遇到构建问题时，可以清理缓存：

```bash
# 清理Flutter缓存
flutter clean

# 清理Android Gradle缓存
cd android && ./gradlew clean && cd ..

# 重新获取依赖
flutter pub get
```

---

## 📤 发布前检查清单

- [ ] 更新版本号 (pubspec.yaml)
- [ ] 测试所有功能是否正常
- [ ] 检查是否有未处理的 linter 错误
- [ ] 确认图标和启动页正常显示
- [ ] 确认数据导入导出功能正常
- [ ] 签名密钥已配置（正式发布）
- [ ] 使用 `flutter build apk --release` 构建
- [ ] 在真机上安装测试 release 版本
- [ ] 检查 APK 大小是否合理（建议 < 30MB）

---

## 📏 APK 大小优化

### 1. 分架构构建（推荐）

```bash
flutter build apk --release --split-per-abi
```

会生成三个 APK：

- `app-armeabi-v7a-release.apk` (32 位 ARM)
- `app-arm64-v8a-release.apk` (64 位 ARM，主流)
- `app-x86_64-release.apk` (模拟器)

### 2. 启用混淆和压缩

在 `build.gradle.kts` 中：

```kotlin
buildTypes {
    release {
        isMinifyEnabled = true      // 启用代码压缩
        isShrinkResources = true    // 启用资源压缩
    }
}
```

---

## 🐛 常见问题

### 1. 构建失败：找不到 SDK

```bash
flutter doctor
```

检查 Android SDK 是否正确安装。

### 2. 签名错误

确保 `key.properties` 路径和密码正确。

### 3. 图标不更新

```bash
flutter clean
flutter pub get
flutter pub run flutter_launcher_icons
```

### 4. Gradle 构建缓慢

在 `android/gradle.properties` 中添加：

```properties
org.gradle.jvmargs=-Xmx4g -XX:MaxMetaspaceSize=1g
org.gradle.parallel=true
org.gradle.caching=true
```

---

## 📞 联系信息

- 应用名称：毛虫记账
- 包名：com.chenille.comptabilite
- 作者：您的名字
- 地区：中国

祝发布顺利！🎉
