# 项目架构说明

## 整体架构

本项目采用**分层架构**和**组件化设计**，确保代码清晰、可维护。

```
┌─────────────────────────────────────┐
│         Presentation Layer          │  UI层
│    (Pages, Widgets, Screens)        │
├─────────────────────────────────────┤
│       State Management Layer        │  状态管理层
│          (Provider)                 │
├─────────────────────────────────────┤
│         Business Logic Layer        │  业务逻辑层
│      (Services, Data Service)       │
├─────────────────────────────────────┤
│          Data Layer                 │  数据层
│  (Models, Storage Service)          │
└─────────────────────────────────────┘
```

## 目录结构详解

### config/ - 配置层

负责应用的全局配置。

- **constants.dart**: 常量定义（存储键、类型定义等）
- **theme.dart**: 主题配置（颜色、样式等）

### models/ - 数据模型层

定义数据结构，纯数据类。

- **category.dart**: 分类模型
  - 包含默认分类生成方法
  - JSON 序列化/反序列化
- **transaction.dart**: 交易记录模型
  - 收入/支出记录结构
  - JSON 序列化/反序列化

### services/ - 服务层

处理业务逻辑和数据持久化。

- **storage_service.dart**: 本地存储服务
  - 封装 SharedPreferences
  - 提供 JSON 存取接口
- **data_service.dart**: 数据管理服务
  - 管理分类和交易记录
  - 提供 CRUD 操作
  - 处理导入导出逻辑

### providers/ - 状态管理层

使用 Provider 模式管理应用状态。

- **data_provider.dart**: 数据状态管理
  - 连接 UI 和 Service 层
  - 通知 UI 更新
  - 提供数据访问接口

### utils/ - 工具类层

提供通用工具方法。

- **date_util.dart**: 日期处理工具
  - 格式化日期
  - 日期计算（周、月、年）
- **number_util.dart**: 数字处理工具
  - 金额格式化
  - 数字验证

### widgets/ - 公共组件层

可复用的 UI 组件。

- **common_button.dart**: 按钮组件
- **common_dialog.dart**: 对话框组件
- **toast.dart**: 提示消息组件
- **empty_view.dart**: 空数据视图

### pages/ - 页面层

应用的各个功能页面。

#### main_page.dart

主页面，包含底部导航栏，管理五个 Tab 页面。

#### home/ - 首页模块

- **home_page.dart**: 首页主页面
- **widgets/month_summary_card.dart**: 月度汇总卡片
- **widgets/daily_transactions_list.dart**: 每日交易列表
- **widgets/transaction_item.dart**: 交易记录项

#### add/ - 记账模块

- **add_transaction_page.dart**: 记账主页面
- **widgets/amount_input.dart**: 金额输入组件
- **widgets/category_selector.dart**: 分类选择器
- **widgets/date_selector.dart**: 日期选择器
- **widgets/note_input.dart**: 备注输入组件
- **widgets/add_category_dialog.dart**: 添加分类对话框

#### detail/ - 明细模块

- **detail_page.dart**: 明细主页面
- **widgets/calendar_widget.dart**: 日历组件

#### statistics/ - 统计模块

- **statistics_page.dart**: 统计主页面
- **widgets/period_selector.dart**: 周期选择器
- **widgets/statistics_summary.dart**: 统计汇总卡片
- **widgets/trend_chart.dart**: 趋势折线图
- **widgets/category_pie_chart.dart**: 分类饼图

#### profile/ - 我的模块

- **profile_page.dart**: 个人页面（导入导出功能）

## 数据流

### 添加交易记录流程

```
1. 用户输入 → AddTransactionPage
2. 验证数据 → DataProvider.addTransaction()
3. 调用服务 → DataService.addTransaction()
4. 保存数据 → StorageService.setJsonList()
5. 更新状态 → notifyListeners()
6. 刷新UI → Consumer重建
```

### 查询数据流程

```
1. 页面加载 → Consumer监听DataProvider
2. 获取数据 → DataProvider.transactions
3. 数据来源 → DataService缓存
4. 展示UI
```

### 导出数据流程

```
1. 点击导出 → ProfilePage._exportData()
2. 获取数据 → DataProvider.exportData()
3. 序列化 → JSON.encode()
4. 写文件 → File.writeAsString()
5. 提示成功
```

## 状态管理

### Provider 使用

```dart
// 顶层注入
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => DataProvider()..init()),
  ],
  child: MyApp(),
)

// 页面消费
Consumer<DataProvider>(
  builder: (context, dataProvider, child) {
    return ListView(children: ...);
  },
)
```

### 何时使用 Provider

- 跨页面共享数据
- 需要响应式更新 UI
- 数据有增删改操作

### 何时使用 StatefulWidget

- 页面内部状态
- 临时 UI 状态
- 表单输入状态

## 组件设计原则

### 1. 单一职责

每个组件只负责一个功能。

### 2. 可复用性

通用组件支持参数配置。

### 3. 组合优于继承

通过组合小组件构建复杂 UI。

### 4. 最小化重建

使用 const 构造函数减少不必要的重建。

## 性能优化

### 1. 列表优化

- 使用 ListView.builder 懒加载
- 使用 const 构造函数
- 避免在 build 中创建对象

### 2. 状态优化

- Provider 精确监听
- 避免不必要的 setState
- 使用 Selector 细粒度更新

### 3. 图表优化

- 限制数据点数量
- 使用采样降低复杂度
- 异步加载数据

## 扩展指南

### 添加新页面

1. 在`pages/`下创建目录
2. 创建主页面和 widgets 子目录
3. 在`main_page.dart`中添加导航

### 添加新功能

1. 评估是否需要新的 Model
2. 在 Service 层添加业务逻辑
3. 在 Provider 中暴露接口
4. 创建 UI 组件

### 修改数据结构

1. 更新 Model 类
2. 更新序列化方法
3. 考虑数据迁移逻辑
4. 更新相关 Service

## 测试策略

### 单元测试

- 测试 Model 的序列化
- 测试 Utils 工具方法
- 测试 Service 业务逻辑

### Widget 测试

- 测试组件渲染
- 测试用户交互
- 测试状态变化

### 集成测试

- 测试完整流程
- 测试数据持久化
- 测试页面导航

## 最佳实践

### 1. 命名规范

- 文件名：snake_case
- 类名：PascalCase
- 变量/方法：camelCase
- 常量：UPPER_CASE

### 2. 注释规范

- 公共 API 必须有文档注释
- 复杂逻辑添加行内注释
- 使用中文注释

### 3. 错误处理

- 使用 try-catch 捕获异常
- 向用户展示友好提示
- 记录错误日志

### 4. 代码审查要点

- 是否符合分层架构
- 是否有重复代码
- 组件是否可复用
- 是否有性能问题

## 依赖管理

### 核心依赖

- **provider**: 状态管理
- **shared_preferences**: 本地存储
- **fl_chart**: 图表展示
- **uuid**: ID 生成
- **intl**: 国际化支持

### 添加新依赖

1. 评估必要性
2. 检查版本兼容性
3. 更新 pubspec.yaml
4. 运行 flutter pub get
5. 更新 README

## 总结

本架构设计遵循以下原则：

- ✅ 清晰的分层
- ✅ 高内聚低耦合
- ✅ 易于测试
- ✅ 便于扩展
- ✅ 代码复用
