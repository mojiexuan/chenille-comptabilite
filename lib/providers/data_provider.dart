import 'package:flutter/foundation.dart' hide Category;
import 'package:chenille_comptabilite/models/category.dart';
import 'package:chenille_comptabilite/models/transaction.dart';
import 'package:chenille_comptabilite/services/data_service.dart';

/// 数据状态管理
class DataProvider with ChangeNotifier {
  final DataService _dataService = DataService();

  /// 获取所有分类
  List<Category> get categories => _dataService.categories;

  /// 获取所有交易记录
  List<TransactionRecord> get transactions => _dataService.transactions;

  /// 初始化
  Future<void> init() async {
    await _dataService.init();
    notifyListeners();
  }

  /// 添加分类
  Future<Category> addCategory(String name, String type, int iconCode) async {
    final category = await _dataService.addCategory(name, type, iconCode);
    notifyListeners();
    return category;
  }

  /// 删除分类
  Future<bool> deleteCategory(String categoryId) async {
    final result = await _dataService.deleteCategory(categoryId);
    if (result) {
      notifyListeners();
    }
    return result;
  }

  /// 添加交易记录
  Future<TransactionRecord> addTransaction({
    required double amount,
    required String categoryId,
    required String type,
    required DateTime date,
    String note = '',
  }) async {
    final transaction = await _dataService.addTransaction(
      amount: amount,
      categoryId: categoryId,
      type: type,
      date: date,
      note: note,
    );
    notifyListeners();
    return transaction;
  }

  /// 更新交易记录
  Future<void> updateTransaction(TransactionRecord transaction) async {
    await _dataService.updateTransaction(transaction);
    notifyListeners();
  }

  /// 删除交易记录
  Future<void> deleteTransaction(String transactionId) async {
    await _dataService.deleteTransaction(transactionId);
    notifyListeners();
  }

  /// 导出数据
  Map<String, dynamic> exportData() {
    return _dataService.exportData();
  }

  /// 导入数据
  Future<void> importData(Map<String, dynamic> data) async {
    await _dataService.importData(data);
    notifyListeners();
  }

  /// 清空数据（保留默认分类，删除用户自定义分类和所有交易记录）
  Future<void> clearData() async {
    debugPrint('[DataProvider] 开始清空数据...');
    await _dataService.clearData();
    debugPrint('[DataProvider] 清空完成，当前分类数量：${_dataService.categories.length}');
    debugPrint(
        '[DataProvider] 支出分类数量：${getCategoriesByType('expense').length}');
    debugPrint('[DataProvider] 收入分类数量：${getCategoriesByType('income').length}');
    // 直接通知UI更新，无需重新init（否则会重新加载数据导致状态不一致）
    notifyListeners();
    debugPrint('[DataProvider] 已通知所有监听者更新UI');
  }

  /// 根据分类ID获取分类
  Category? getCategoryById(String categoryId) {
    return _dataService.getCategoryById(categoryId);
  }

  /// 获取指定类型的分类
  List<Category> getCategoriesByType(String type) {
    return _dataService.getCategoriesByType(type);
  }
}
