import 'package:chenille_comptabilite/models/category.dart';
import 'package:chenille_comptabilite/models/category_defaults_expense.dart';
import 'package:chenille_comptabilite/models/category_defaults_income.dart';
import 'package:chenille_comptabilite/models/transaction.dart';

/// 分类数据迁移服务
///
/// 负责处理应用版本更新时的分类数据合并与迁移
class CategoryMigrationService {
  /// 合并分类数据
  ///
  /// 策略：
  /// 1. 保留用户的所有现有分类（包括使用次数和自定义分类）
  /// 2. 添加新版本中新增的默认分类
  /// 3. 更新已存在分类的名称和图标（如果默认分类有更新）
  /// 4. 不删除用户已有的分类（即使新版本中已移除）
  static List<Category> mergeCategories(
    List<Category> userCategories,
    List<TransactionRecord> transactions,
  ) {
    // 获取最新的默认分类
    final latestDefaults = [
      ...CategoryDefaultsExpense.getCategories(),
      ...CategoryDefaultsIncome.getCategories(),
    ];

    // 创建用户分类的ID映射
    final userCategoryMap = <String, Category>{};
    for (var category in userCategories) {
      userCategoryMap[category.id] = category;
    }

    // 结果列表
    final mergedCategories = <Category>[];

    // 1. 处理所有默认分类
    for (var defaultCategory in latestDefaults) {
      if (userCategoryMap.containsKey(defaultCategory.id)) {
        // 用户已有此分类，保留用户的使用数据，但更新名称和图标
        final userCategory = userCategoryMap[defaultCategory.id]!;
        mergedCategories.add(
          defaultCategory.copyWith(
            usageCount: userCategory.usageCount, // 保留使用次数
            isCustom: false, // 确保标记为默认分类
          ),
        );
        // 从映射中移除，避免重复添加
        userCategoryMap.remove(defaultCategory.id);
      } else {
        // 新增的默认分类，直接添加
        mergedCategories.add(defaultCategory);
      }
    }

    // 2. 保留用户的自定义分类和被引用的旧分类
    final usedCategoryIds = _getUsedCategoryIds(transactions);
    for (var userCategory in userCategoryMap.values) {
      // 保留自定义分类或被交易记录引用的分类
      if (userCategory.isCustom || usedCategoryIds.contains(userCategory.id)) {
        mergedCategories.add(userCategory);
      }
      // 未被使用的旧默认分类会被自动移除
    }

    return mergedCategories;
  }

  /// 获取被交易记录使用的分类ID集合
  static Set<String> _getUsedCategoryIds(List<TransactionRecord> transactions) {
    return transactions.map((t) => t.categoryId).toSet();
  }

  /// 检查是否需要迁移
  ///
  /// 判断依据：
  /// 1. 用户分类数量与最新默认分类不一致
  /// 2. 存在默认分类ID但不在用户分类中
  static bool needsMigration(List<Category> userCategories) {
    final latestDefaults = [
      ...CategoryDefaultsExpense.getCategories(),
      ...CategoryDefaultsIncome.getCategories(),
    ];

    final userCategoryIds = userCategories.map((c) => c.id).toSet();
    final defaultIds = latestDefaults.map((c) => c.id).toSet();

    // 如果存在新的默认分类ID不在用户分类中，需要迁移
    return !defaultIds.every((id) => userCategoryIds.contains(id));
  }
}
