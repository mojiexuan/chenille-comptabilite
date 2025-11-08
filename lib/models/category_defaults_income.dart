import 'package:chenille_comptabilite/config/constants.dart';
import 'package:chenille_comptabilite/models/category.dart';

/// 默认收入分类数据
class CategoryDefaultsIncome {
  /// 获取默认收入分类（16个）
  static List<Category> getCategories() {
    return [
      Category(
          id: 'inc_salary',
          name: '工资',
          type: AppConstants.typeIncome,
          iconCode: 0xe227,
          isCustom: false),
      Category(
          id: 'inc_bonus',
          name: '奖金',
          type: AppConstants.typeIncome,
          iconCode: 0xe8d3,
          isCustom: false),
      Category(
          id: 'inc_parttime',
          name: '兼职',
          type: AppConstants.typeIncome,
          iconCode: 0xe8f9,
          isCustom: false),
      Category(
          id: 'inc_business',
          name: '生意收入',
          type: AppConstants.typeIncome,
          iconCode: 0xe8f8,
          isCustom: false),
      Category(
          id: 'inc_investment',
          name: '投资收益',
          type: AppConstants.typeIncome,
          iconCode: 0xe926,
          isCustom: false),
      Category(
          id: 'inc_financial',
          name: '理财收益',
          type: AppConstants.typeIncome,
          iconCode: 0xe84f,
          isCustom: false),
      Category(
          id: 'inc_rent',
          name: '租金收入',
          type: AppConstants.typeIncome,
          iconCode: 0xe80e,
          isCustom: false),
      Category(
          id: 'inc_gift',
          name: '礼金',
          type: AppConstants.typeIncome,
          iconCode: 0xe8f6,
          isCustom: false),
      Category(
          id: 'inc_refund',
          name: '退款',
          type: AppConstants.typeIncome,
          iconCode: 0xe5d5,
          isCustom: false),
      Category(
          id: 'inc_reimbursement',
          name: '报销',
          type: AppConstants.typeIncome,
          iconCode: 0xe8e0,
          isCustom: false),
      Category(
          id: 'inc_royalty',
          name: '稿费版税',
          type: AppConstants.typeIncome,
          iconCode: 0xe865,
          isCustom: false),
      Category(
          id: 'inc_lottery',
          name: '中奖彩票',
          type: AppConstants.typeIncome,
          iconCode: 0xe86c,
          isCustom: false),
      Category(
          id: 'inc_secondhand',
          name: '卖二手',
          type: AppConstants.typeIncome,
          iconCode: 0xe8cb,
          isCustom: false),
      Category(
          id: 'inc_bonus_red',
          name: '奖励红包',
          type: AppConstants.typeIncome,
          iconCode: 0xe8f6,
          isCustom: false),
      Category(
          id: 'inc_interest',
          name: '利息收入',
          type: AppConstants.typeIncome,
          iconCode: 0xe227,
          isCustom: false),
      Category(
          id: 'inc_other',
          name: '其他收入',
          type: AppConstants.typeIncome,
          iconCode: 0xe147,
          isCustom: false),
    ];
  }
}
