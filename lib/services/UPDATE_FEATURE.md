# 自动更新检测功能 - 使用文档

## 📋 功能概述

本功能实现了**企业级的应用版本检测和更新提示**，支持自动检测和手动检测两种方式。

### 核心特性

✅ **自动检测** - 应用启动时自动检测，每天只检测一次  
✅ **手动检测** - 用户点击按钮主动检测更新  
✅ **新版本提示** - 红点+文字提示有新版本  
✅ **更新详情** - 展示版本号和更新内容  
✅ **本地缓存** - 缓存检测结果，减少网络请求

---

## 🗂️ 模块结构

```
lib/
├── models/
│   └── version_info.dart              # 版本信息数据模型
├── services/
│   ├── version_service.dart           # 版本管理服务
│   └── version_api_service.dart       # 版本API服务
├── widgets/
│   └── update_checker_button.dart     # 更新检测按钮组件
└── pages/
    ├── splash/
    │   └── splash_page.dart           # 启动页（集成自动检测）
    └── profile/
        └── profile_page.dart          # 我的页面（集成更新按钮）
```

### 模块说明

| 文件                         | 职责             | 行数 |
| ---------------------------- | ---------------- | ---- |
| `version_info.dart`          | 版本信息数据模型 | 46   |
| `version_service.dart`       | 版本检测核心逻辑 | 150  |
| `version_api_service.dart`   | API 请求封装     | 43   |
| `update_checker_button.dart` | UI 组件          | 230  |

---

## 🔧 技术实现

### 1. VersionInfo（版本信息模型）

```dart
class VersionInfo {
  final String name;      // 版本号，如 "1.0.0"
  final int code;         // 版本代码，如 100
  final String content;   // 更新内容

  // 比较版本
  bool isNewerThan(int currentCode) {
    return code > currentCode;
  }
}
```

**API 响应格式**：

```json
{
  "name": "1.0.0",
  "code": 100,
  "content": "·首版发布"
}
```

---

### 2. VersionService（版本管理服务）

**核心功能**：

- 获取当前应用版本
- 检查服务器最新版本
- 比较版本判断是否需要更新
- 缓存版本信息
- 控制检测频率（每天一次）

**存储键**：

- `last_check_update_date` - 最后检查日期
- `latest_version_info` - 最新版本信息
- `has_new_version` - 是否有新版本

**主要方法**：

```dart
// 初始化
await VersionService().init();

// 检查是否需要自动检测
bool shouldAutoCheck();

// 检查更新
Future<bool> checkUpdate({bool manual = false});

// 清除新版本标记
Future<void> clearNewVersionFlag();
```

---

### 3. VersionApiService（API 服务）

**请求地址**：`https://chenille.chenjiabao.cn/`

**封装说明**：

- 基于 `HttpClient` 实现
- 自动初始化配置
- 统一错误处理
- 返回 `HttpResponse<VersionInfo>` 格式

---

### 4. UpdateCheckerButton（更新按钮组件）

**UI 状态**：

1. **默认状态** - 显示当前版本
2. **检测中状态** - 显示加载动画
3. **有新版本状态** - 显示红点+提示文字
4. **已是最新版本** - Toast 提示

**交互流程**：

```
用户点击按钮
    ↓
显示加载动画
    ↓
调用 VersionService.checkUpdate(manual: true)
    ↓
有新版本？
├── 是 → 显示更新详情对话框
└── 否 → Toast提示"已是最新版本"
```

---

## 🚀 使用指南

### 1. 依赖安装

已添加到 `pubspec.yaml`：

```yaml
dependencies:
  dio: ^5.4.0 # 网络请求
  package_info_plus: ^5.0.1 # 获取应用版本信息
```

运行安装：

```bash
flutter pub get
```

---

### 2. 自动检测（应用启动时）

在 `splash_page.dart` 中已集成：

```dart
Future<void> _initVersionService() async {
  try {
    final versionService = VersionService();
    await versionService.init();

    // 自动检测更新（每天只检测一次）
    if (versionService.shouldAutoCheck()) {
      versionService.checkUpdate(manual: false);
    }
  } catch (e) {
    debugPrint('[SplashPage] 初始化版本服务失败：$e');
  }
}
```

**特点**：

- ✅ 应用启动时自动执行
- ✅ 每天只检测一次
- ✅ 静默检测，不打扰用户
- ✅ 检测失败不影响应用启动

---

### 3. 手动检测（用户点击按钮）

在 `profile_page.dart` 中已集成：

```dart
ProfileSection(
  title: '关于',
  children: [
    // 检查更新按钮
    const UpdateCheckerButton(),
    // 其他菜单项...
  ],
),
```

**用户操作流程**：

1. 进入"我的"页面
2. 点击"检查更新"按钮
3. 显示加载状态
4. 检测完成后显示结果

---

### 4. 新版本提示

**红点显示条件**：

- ✅ 服务器版本 > 当前版本
- ✅ 用户未查看更新详情

**提示样式**：

```
┌─────────────────────────────────────┐
│ 🔄 检查更新                         │
│    当前版本 1.0.0                   │
│                        [有新版本] 🔴│
└─────────────────────────────────────┘
```

**清除红点**：
用户点击按钮查看更新详情后，红点自动消失。

---

### 5. 更新详情对话框

```
┌──────────────────────────┐
│   发现新版本             │
├──────────────────────────┤
│ 最新版本：  1.1.0        │
│                          │
│ 更新内容：               │
│ ┌──────────────────────┐ │
│ │ ·修复已知问题        │ │
│ │ ·优化性能            │ │
│ │ ·新增XX功能          │ │
│ └──────────────────────┘ │
│                          │
│           [我知道了]      │
└──────────────────────────┘
```

---

## 📊 数据流程

### 完整流程图

```
应用启动
    ↓
SplashPage 初始化
    ↓
VersionService.init()
    ↓
加载当前版本信息 (package_info_plus)
    ↓
加载缓存的版本信息 (SharedPreferences)
    ↓
判断是否需要自动检测？
├── 否 → 使用缓存数据
└── 是 → 请求API
        ↓
    获取最新版本信息
        ↓
    比较版本号
        ↓
    缓存结果
        ↓
    更新UI状态
```

### 数据存储

使用 `SharedPreferences` 存储：

```dart
{
  "last_check_update_date": "2025-01-15T08:30:00.000Z",
  "latest_version_info": {
    "name": "1.1.0",
    "code": 110,
    "content": "·修复已知问题\n·优化性能"
  },
  "has_new_version": true
}
```

---

## 🎯 使用示例

### 示例 1：在其他页面使用

```dart
import 'package:chenille_comptabilite/services/version_service.dart';
import 'package:chenille_comptabilite/widgets/toast.dart';

class MyPage extends StatelessWidget {
  final VersionService _versionService = VersionService();

  Future<void> checkUpdate(BuildContext context) async {
    // 手动检查更新
    final hasNewVersion = await _versionService.checkUpdate(manual: true);

    if (hasNewVersion) {
      final latestVersion = _versionService.latestVersionInfo;
      Toast.show(context, '发现新版本：${latestVersion?.name}');
    } else {
      Toast.show(context, '已是最新版本');
    }
  }
}
```

### 示例 2：获取版本信息

```dart
final versionService = VersionService();
await versionService.init();

// 当前版本
print('当前版本：${versionService.currentVersion}');
print('版本代码：${versionService.currentVersionCode}');

// 最新版本
if (versionService.hasNewVersion) {
  final latest = versionService.latestVersionInfo;
  print('最新版本：${latest?.name}');
  print('更新内容：${latest?.content}');
}
```

### 示例 3：自定义更新按钮

```dart
class CustomUpdateButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final versionService = VersionService();

    return ElevatedButton(
      onPressed: () async {
        await versionService.checkUpdate(manual: true);
      },
      child: Text(
        versionService.hasNewVersion
          ? '有新版本 🔴'
          : '检查更新',
      ),
    );
  }
}
```

---

## 🔍 API 接口说明

### 请求

**URL**: `https://chenille.chenjiabao.cn/`  
**方法**: `GET`  
**超时**: 10 秒

### 响应

**成功响应**:

```json
{
  "name": "1.0.0",
  "code": 100,
  "content": "·首版发布"
}
```

**字段说明**:

- `name` (string) - 版本号，格式：x.y.z
- `code` (int) - 版本代码，用于版本比较
- `content` (string) - 更新内容，支持多行文本

**版本代码规则**:

- 1.0.0 → 100
- 1.0.1 → 101
- 1.1.0 → 110
- 2.0.0 → 200

---

## ⚙️ 配置选项

### 修改检测频率

在 `version_service.dart` 中修改：

```dart
/// 检查是否需要自动检测更新
bool shouldAutoCheck() {
  final lastCheckDate = StorageService.getString(_keyLastCheckDate);
  if (lastCheckDate == null) return true;

  final lastCheck = DateTime.tryParse(lastCheckDate);
  if (lastCheck == null) return true;

  final now = DateTime.now();
  // 修改这里可以改变检测频率
  // 例如：改为每小时检测一次
  return now.difference(lastCheck).inHours >= 1;
}
```

### 修改 API 地址

在 `version_api_service.dart` 中修改：

```dart
void _initHttpClient() {
  _client.init(HttpConfig(
    baseUrl: 'https://your-api-domain.com', // 修改为你的API地址
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    enableLog: false,
  ));
}
```

### 修改 UI 样式

在 `update_checker_button.dart` 中自定义样式。

---

## 🐛 调试技巧

### 1. 查看检测日志

```dart
// 开启详细日志
debugPrint('[VersionService] 当前版本：$currentVersion');
debugPrint('[VersionService] 最新版本：${latestVersion.name}');
```

### 2. 重置检测时间（测试用）

```dart
final versionService = VersionService();
await versionService.resetCheckTime(); // 重置后可立即再次检测
```

### 3. 模拟新版本

修改本地应用的版本号（pubspec.yaml）：

```yaml
version: 0.9.0+90 # 设置为比服务器版本低
```

---

## ✅ 功能检查清单

### 开发完成检查

- [x] 版本信息模型创建
- [x] 版本管理服务实现
- [x] API 服务封装
- [x] 更新按钮组件开发
- [x] 启动页集成自动检测
- [x] 我的页面集成更新按钮
- [x] 本地缓存实现
- [x] 每日检测限制
- [x] 红点提示实现
- [x] 更新详情对话框

### 测试检查

- [ ] 首次启动检测
- [ ] 每日自动检测
- [ ] 手动点击检测
- [ ] 有新版本提示
- [ ] 无新版本提示
- [ ] 网络异常处理
- [ ] 红点显示/隐藏
- [ ] 更新详情展示

---

## 🎉 总结

本自动更新检测功能具有以下优势：

✅ **用户友好** - 自动检测不打扰，手动检测响应快  
✅ **性能优化** - 缓存机制减少网络请求  
✅ **体验优秀** - 红点提示清晰，更新详情完整  
✅ **代码规范** - 模块化清晰，符合企业级标准  
✅ **易于维护** - 文档完善，便于后续扩展

**适用场景**：

- 需要版本管理的应用
- 需要通知用户更新的应用
- 需要展示更新内容的应用

根据 [chenille.chenjiabao.cn](https://chenille.chenjiabao.cn/) 提供的版本信息，系统会自动检测并提示用户有新版本可用。

