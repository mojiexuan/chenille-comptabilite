# 毛虫记账 (Chenille Comptabilite)

一款简洁卡通的个人记账应用，使用 Flutter 开发。

## 功能特性

### 主要功能

- **首页**：展示本月收支信息，以及每天的收支记录
- **明细**：通过日历查看每一天的收支明细
- **记账**：快速记录收入和支出
- **统计**：多维度统计分析（周/月/年），提供可视化图表
- **我的**：数据导入导出，方便备份和迁移

### 技术特点

- 组件化开发，代码模块化清晰
- 本地持久化存储，无需网络
- 企业级编码规范
- 完整的中文注释

## 技术栈

- **框架**：Flutter 3.0+
- **状态管理**：Provider
- **本地存储**：SharedPreferences
- **图表**：FL Chart
- **其他**：Intl、UUID、File Picker、Path Provider

## 📜 开源协议

本项目采用 **CC BY-NC-SA 4.0**（知识共享 署名-非商业性使用-相同方式共享 4.0）协议。

**简单来说**：

- ✅ 可以自由学习、修改、分享
- ✅ 必须保留作者署名
- ❌ 禁止任何商业使用
- ❌ 禁止嵌入收费项目
- ✅ 衍生作品必须同样免费开源

详细说明请查看 [LICENSE.txt](./LICENSE.txt) 和 [LICENSE_CN.md](./LICENSE_CN.md)

## 项目结构

```
lib/
├── config/              # 配置文件
│   ├── constants.dart   # 常量配置
│   └── theme.dart       # 主题配置
├── models/              # 数据模型
│   ├── category.dart    # 分类模型
│   └── transaction.dart # 交易记录模型
├── services/            # 服务层
│   ├── storage_service.dart  # 存储服务
│   └── data_service.dart     # 数据管理服务
├── providers/           # 状态管理
│   └── data_provider.dart    # 数据Provider
├── utils/               # 工具类
│   ├── date_util.dart   # 日期工具
│   └── number_util.dart # 数字工具
├── widgets/             # 公共组件
│   ├── common_button.dart    # 按钮组件
│   ├── common_dialog.dart    # 对话框组件
│   ├── toast.dart            # Toast组件
│   └── empty_view.dart       # 空数据视图
├── pages/               # 页面
│   ├── main_page.dart   # 主页面（底部导航）
│   ├── home/            # 首页模块
│   ├── add/             # 记账模块
│   ├── detail/          # 明细模块
│   ├── statistics/      # 统计模块
│   └── profile/         # 我的模块
└── main.dart            # 应用入口
```

## 开始使用

### 环境要求

- Flutter SDK 3.0.0 或更高版本
- Dart SDK 3.0.0 或更高版本

### 安装依赖

```bash
flutter pub get
```

### 运行应用

```bash
flutter run
```

### 构建 APK

```bash
flutter build apk --release

flutter build apk --release --split-per-abi --no-tree-shake-icons
```

## 数据存储

应用使用本地 JSON 格式存储数据，包含以下内容：

- **分类数据**：预设分类和自定义分类
- **交易记录**：所有收支记录

数据存储在应用私有目录，支持导出备份和导入恢复。

## 预设分类

### 支出分类

餐饮、交通、购物、娱乐、医疗、住房、教育、通讯、美容、运动、旅游、宠物

### 收入分类

工资、奖金、兼职、投资、礼金、退款

用户可以自定义添加更多分类（最多 10 个字符）。

## 开发规范

### 代码规范

- 每个文件代码不超过 200 行，超过则拆分
- 所有函数必须包含中文文档注释
- 遵循 Dart 代码风格指南
- 组件化开发，优先复用

### 命名规范

- 类名：大驼峰 (PascalCase)
- 方法/变量：小驼峰 (camelCase)
- 常量：全大写下划线分隔 (UPPER_CASE)
- 私有成员：下划线前缀 (\_prefix)

## 许可证

MIT License

## 更新日志

### v1.0.0 (2025-10-25)

- ✅ 首页展示本月收支
- ✅ 日历明细查看
- ✅ 快速记账功能
- ✅ 多维度统计图表
- ✅ 数据导入导出
- ✅ 自定义分类

## 联系方式

如有问题或建议，欢迎反馈！

## 🌟 企业级 Flutter 开发提示词模板（增强版）

你是一名 **高级 Flutter 工程师**，负责开发一款 **Android 应用**。你的目标是生成 **高效、组件化、可复用、可维护、符合企业级规范** 的 Flutter 代码，并提供完整文档、结构说明与依赖关系图。

---

1️⃣ 项目结构与组件化

- 项目必须采用 **组件化开发**，代码按模块、功能或组件拆分。
- 建议目录结构：
  lib/
  |—— config/ // 配置文件（constants、theme）
  ├── widgets/ // 公共组件（CommonButton、Toast、Dialog 等）
  ├── modules/ // 功能模块，每个模块独立目录
  ├── utils/ // 工具类函数
  ├── models/ // 数据模型（Category、TransactionRecord
  ├── services/ // 服务层（StorageService、DataService）
  ├── pages/ // 页面视图
  └── main.dart
- **原则**：每个文件 ≤ 200 行，页面组件可适度放宽，但仍强制要求不超过 400 行，功能单一，利于复用与维护。

---

2️⃣ 复用优先

- 所有 **UI 组件**（按钮、Toast、Dialog、输入框等）必须抽象为可复用组件。
- 避免重复代码，逻辑复用工具函数或服务。

3️⃣ 数据管理与持久化

- 本地存储：应用为单机版，数据必须持久化（Hive、SharedPreferences、SQLite 等）。
- 缓存结构要简洁、清晰，避免冗余信息。

4️⃣ 编码规范

- 严格遵循企业级规范：
- 所有函数必须有 中文文档注释。
- 命名规范：camelCase 用于变量/方法，PascalCase 用于类名。
- 遵循 Dart/Flutter 官方最佳实践。

5️⃣ 文件拆分策略

- 文件 ≤ 200 行。
- 按功能拆分：
- - 页面：pages/home_page.dart
- - 模块逻辑：modules/auth/auth_service.dart
- - 组件：components/custom_button.dart
- - 工具：utils/logger.dart
- 保持代码可维护，避免臃肿。

6️⃣ 开发原则

- 高效：性能优先，避免重复渲染和复杂操作。
- 完美：UI、交互、错误处理都要到位。
- 易维护：注释清晰，代码简洁，结构合理。
- 人类思考：遇到问题分析最优解，不随意实现。

7️⃣ AI 交互策略

- 不确定时主动提问用户：
- 功能需求不明确
- 数据格式不清楚
- UI 风格未指定

8️⃣ 输出要求

- 代码必须：
- - 可直接在 Flutter 项目中使用
- - 有完整中文注释
- - 遵循模块化与复用原则
- - 文件结构清晰
- - 数据持久化方案明确
- 避免：
- - 冗长或不可复用的代码
- - 单文件超长 (>200 行)
- - 未注释或不规范命名

9️⃣ 模块结构图输出

- 每次生成代码时，请生成 模块结构图，包含：
- - 模块名称
- - 主要组件
- - 工具函数
- - 数据服务

🔟 组件复用说明

- 每个可复用组件必须生成复用说明：
- - 功能描述
- - 可配置参数
- - 使用示例
