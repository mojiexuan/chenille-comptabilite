# 快速开始指南

## 环境准备

### 1. 安装 Flutter SDK

```bash
# 确认Flutter已安装
flutter --version

# 应该看到类似输出
# Flutter 3.x.x • channel stable
```

### 2. 检查环境

```bash
flutter doctor
```

确保 Android 相关的配置都是 ✓ 状态。

## 运行项目

### 1. 进入项目目录

```bash
cd ChenilleComptabilite
```

### 2. 安装依赖

```bash
flutter pub get
```

### 3. 连接设备或启动模拟器

**使用真机：**

- 开启 USB 调试
- 连接电脑
- 运行 `flutter devices` 查看设备

**使用模拟器：**

```bash
# 列出可用模拟器
flutter emulators

# 启动模拟器
flutter emulators --launch <emulator_id>
```

### 4. 运行应用

```bash
# 调试模式
flutter run

# 或指定设备
flutter run -d <device_id>
```

## 构建 APK

### Debug 版本

```bash
flutter build apk --debug
```

### Release 版本

```bash
flutter build apk --release
```

生成的 APK 文件位于：`build/app/outputs/flutter-apk/app-release.apk`

## 项目特性说明

### 数据存储位置

- 使用 SharedPreferences 存储 JSON 数据
- 自动初始化默认分类
- 数据持久化，应用重启不丢失

### 导入导出功能

- **导出**：自动保存到应用文档目录
- **导入**：支持选择 JSON 文件导入
- **文件名格式**：`chenille_backup_YYYY-MM-DD.json`

### 自定义分类

- 支持添加自定义收入/支出分类
- 分类名称限制 10 个字符
- 可选择 18 种预设图标
- 自定义分类可删除

### 统计功能

- **周统计**：显示本周收支趋势
- **月统计**：显示本月收支趋势和分类分布
- **年统计**：显示全年收支趋势

## 常见问题

### Q: 编译失败怎么办？

```bash
# 清理缓存
flutter clean

# 重新获取依赖
flutter pub get

# 重新构建
flutter run
```

### Q: 如何查看日志？

```bash
# 实时查看日志
flutter logs
```

### Q: 如何修改应用名称？

修改以下文件：

- `pubspec.yaml` 中的 `name` 字段
- `android/app/src/main/AndroidManifest.xml` 中的 `android:label`

### Q: 如何修改应用图标？

1. 准备图标文件（建议 1024x1024 PNG）
2. 使用 `flutter_launcher_icons` 包
3. 配置 `pubspec.yaml` 并运行生成命令

### Q: 数据存在哪里？

- Android: `/data/data/com.chenille.comptabilite/shared_prefs/`
- 导出的备份文件: 应用文档目录

## 开发调试

### 热重载

在应用运行时：

- 按 `r` 热重载
- 按 `R` 热重启
- 按 `q` 退出

### 性能分析

```bash
# 启动性能分析
flutter run --profile
```

### VSCode 调试

1. 打开 VSCode
2. 按 F5 启动调试
3. 设置断点进行调试

## 代码规范

### 文件命名

- 使用小写下划线：`transaction_item.dart`
- 组件放在 `widgets` 目录
- 页面放在 `pages` 目录

### 注释规范

```dart
/// 公共函数必须有文档注释
///
/// 参数说明、返回值说明等
void exampleFunction() {
  // 实现细节的注释
}
```

### 组件拆分原则

- 单个文件不超过 200 行
- 可复用的组件独立成文件
- 相关组件放在同一目录

## 更多帮助

查看详细文档：`README.md`

遇到问题？检查 Flutter 官方文档：https://flutter.dev/docs
