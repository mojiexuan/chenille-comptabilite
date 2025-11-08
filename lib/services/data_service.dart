import 'package:flutter/foundation.dart' hide Category;
import 'package:chenille_comptabilite/config/constants.dart';
import 'package:chenille_comptabilite/models/category.dart';
import 'package:chenille_comptabilite/models/category_defaults_expense.dart';
import 'package:chenille_comptabilite/models/category_defaults_income.dart';
import 'package:chenille_comptabilite/models/transaction.dart';
import 'package:chenille_comptabilite/services/storage_service.dart';
import 'package:chenille_comptabilite/services/category_migration_service.dart';
import 'package:uuid/uuid.dart';

/// 数据管理服务
class DataService {
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  DataService._internal();

  final _uuid = const Uuid();

  List<Category> _categories = [];
  List<TransactionRecord> _transactions = [];

  /// 获取所有分类
  List<Category> get categories => List.unmodifiable(_categories);

  /// 获取所有交易记录
  List<TransactionRecord> get transactions => List.unmodifiable(_transactions);

  /// 初始化数据服务
  Future<void> init() async {
    await _loadCategories();
    await _loadTransactions();

    // 强制验证：如果分类为空（可能被错误清空），立即恢复默认分类
    if (_categories.isEmpty) {
      debugPrint('⚠️ 警告：分类列表为空，立即恢复默认分类！');
      _categories = [
        ...CategoryDefaultsExpense.getCategories(),
        ...CategoryDefaultsIncome.getCategories(),
      ];
      await _saveCategories();
      debugPrint('✅ 已恢复默认分类：${_categories.length}个');
    }

    // 检查并执行分类数据迁移
    await _migrateCategories();
  }

  /// 加载分类数据
  Future<void> _loadCategories() async {
    try {
      final data = StorageService.getJsonList(AppConstants.keyCategories);
      if (data == null || data.isEmpty) {
        // 首次使用，初始化默认分类
        debugPrint('首次使用或数据为空，初始化默认分类');
        _categories = [
          ...CategoryDefaultsExpense.getCategories(),
          ...CategoryDefaultsIncome.getCategories(),
        ];
        await _saveCategories();
      } else {
        // 尝试加载已有分类
        _categories = data.map((json) => Category.fromJson(json)).toList();
        debugPrint('成功加载分类：${_categories.length}个');
      }
    } catch (e) {
      // 如果加载失败，恢复为默认分类
      debugPrint('加载分类失败，恢复默认分类: $e');
      _categories = [
        ...CategoryDefaultsExpense.getCategories(),
        ...CategoryDefaultsIncome.getCategories(),
      ];
      await _saveCategories();
    }
  }

  /// 加载交易记录
  Future<void> _loadTransactions() async {
    final data = StorageService.getJsonList(AppConstants.keyTransactions);
    if (data != null) {
      _transactions =
          data.map((json) => TransactionRecord.fromJson(json)).toList();
      // 按日期降序排序
      _transactions.sort((a, b) => b.date.compareTo(a.date));
    }
  }

  /// 保存分类数据
  Future<void> _saveCategories() async {
    final data = _categories.map((c) => c.toJson()).toList();
    await StorageService.setJsonList(AppConstants.keyCategories, data);
  }

  /// 保存交易记录
  Future<void> _saveTransactions() async {
    final data = _transactions.map((t) => t.toJson()).toList();
    await StorageService.setJsonList(AppConstants.keyTransactions, data);
  }

  /// 添加分类
  Future<Category> addCategory(String name, String type, int iconCode) async {
    final category = Category(
      id: _uuid.v4(),
      name: name,
      type: type,
      iconCode: iconCode,
      isCustom: true,
    );
    _categories.add(category);
    await _saveCategories();
    return category;
  }

  /// 删除自定义分类
  Future<bool> deleteCategory(String categoryId) async {
    final category = _categories.firstWhere((c) => c.id == categoryId);
    if (!category.isCustom) return false;

    _categories.removeWhere((c) => c.id == categoryId);
    await _saveCategories();
    return true;
  }

  /// 添加交易记录
  Future<TransactionRecord> addTransaction({
    required double amount,
    required String categoryId,
    required String type,
    required DateTime date,
    String note = '',
  }) async {
    final transaction = TransactionRecord(
      id: _uuid.v4(),
      amount: amount,
      categoryId: categoryId,
      type: type,
      note: note,
      date: date,
    );
    _transactions.insert(0, transaction);
    await _saveTransactions();

    // 增加分类使用次数
    await _incrementCategoryUsage(categoryId);

    return transaction;
  }

  /// 增加分类使用次数
  Future<void> _incrementCategoryUsage(String categoryId) async {
    final index = _categories.indexWhere((c) => c.id == categoryId);
    if (index != -1) {
      _categories[index] = _categories[index].incrementUsage();
      await _saveCategories();
    }
  }

  /// 更新交易记录
  Future<void> updateTransaction(TransactionRecord transaction) async {
    final index = _transactions.indexWhere((t) => t.id == transaction.id);
    if (index != -1) {
      _transactions[index] = transaction;
      _transactions.sort((a, b) => b.date.compareTo(a.date));
      await _saveTransactions();
    }
  }

  /// 删除交易记录
  Future<void> deleteTransaction(String transactionId) async {
    _transactions.removeWhere((t) => t.id == transactionId);
    await _saveTransactions();
  }

  /// 导出所有数据
  Map<String, dynamic> exportData() {
    return {
      'categories': _categories.map((c) => c.toJson()).toList(),
      'transactions': _transactions.map((t) => t.toJson()).toList(),
      'exportTime': DateTime.now().toIso8601String(),
    };
  }

  /// 导入数据
  Future<void> importData(Map<String, dynamic> data) async {
    final categoriesData = data['categories'] as List?;
    final transactionsData = data['transactions'] as List?;

    if (categoriesData != null) {
      _categories = categoriesData
          .map((json) => Category.fromJson(json as Map<String, dynamic>))
          .toList();
      await _saveCategories();
    }

    if (transactionsData != null) {
      _transactions = transactionsData
          .map((json) =>
              TransactionRecord.fromJson(json as Map<String, dynamic>))
          .toList();
      _transactions.sort((a, b) => b.date.compareTo(a.date));
      await _saveTransactions();
    }
  }

  /// 清空数据（恢复默认分类，删除用户自定义分类和所有交易记录）
  Future<void> clearData() async {
    try {
      debugPrint('开始清空数据...');

      // 清空所有交易记录
      _transactions = [];

      // 完全恢复默认分类（即使用户删除了某些默认分类，也会恢复）
      _categories = [
        ...CategoryDefaultsExpense.getCategories(),
        ...CategoryDefaultsIncome.getCategories(),
      ];

      debugPrint(
          '内存中已设置：分类数量=${_categories.length}, 交易数量=${_transactions.length}');

      // 保存到本地存储
      await _saveTransactions(); // 先保存交易（清空）
      await _saveCategories(); // 再保存分类（恢复默认）

      // 验证保存后立即读取，确认存储成功
      final savedCategories =
          StorageService.getJsonList(AppConstants.keyCategories);
      final savedTransactions =
          StorageService.getJsonList(AppConstants.keyTransactions);
      debugPrint(
          '已保存到存储：分类=${savedCategories?.length ?? 0}, 交易=${savedTransactions?.length ?? 0}');
      debugPrint('✅ 清空数据完成！当前内存分类数量：${_categories.length}');
    } catch (e) {
      debugPrint('❌ 清空数据失败: $e');
      // 即使保存失败，也确保内存中的数据已更新
      rethrow;
    }
  }

  /// 根据分类ID获取分类
  Category? getCategoryById(String categoryId) {
    try {
      return _categories.firstWhere((c) => c.id == categoryId);
    } catch (e) {
      return null;
    }
  }

  /// 获取指定类型的分类（按使用次数降序排列）
  List<Category> getCategoriesByType(String type) {
    final filtered = _categories.where((c) => c.type == type).toList();
    // 按使用次数降序排序，次数相同则保持原顺序
    filtered.sort((a, b) {
      if (b.usageCount != a.usageCount) {
        return b.usageCount.compareTo(a.usageCount);
      }
      // 次数相同时，默认分类在前，自定义分类在后
      if (a.isCustom != b.isCustom) {
        return a.isCustom ? 1 : -1;
      }
      return 0;
    });
    return filtered;
  }

  /// 执行分类数据迁移
  Future<void> _migrateCategories() async {
    if (CategoryMigrationService.needsMigration(_categories)) {
      // 执行智能合并
      _categories = CategoryMigrationService.mergeCategories(
        _categories,
        _transactions,
      );
      await _saveCategories();
    }
  }
}
