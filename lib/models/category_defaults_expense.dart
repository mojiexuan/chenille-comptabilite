import 'package:chenille_comptabilite/config/constants.dart';
import 'package:chenille_comptabilite/models/category.dart';

/// 默认支出分类数据
class CategoryDefaultsExpense {
  /// 获取默认支出分类（40个）
  static List<Category> getCategories() {
    return [
      Category(
          id: 'exp_food',
          name: '餐饮',
          type: AppConstants.typeExpense,
          iconCode: 0xe533,
          isCustom: false),
      Category(
          id: 'exp_snacks',
          name: '零食烟酒',
          type: AppConstants.typeExpense,
          iconCode: 0xe7e9,
          isCustom: false),
      Category(
          id: 'exp_shopping',
          name: '购物',
          type: AppConstants.typeExpense,
          iconCode: 0xe59c,
          isCustom: false),
      Category(
          id: 'exp_clothing',
          name: '服饰鞋包',
          type: AppConstants.typeExpense,
          iconCode: 0xe8b6,
          isCustom: false),
      Category(
          id: 'exp_daily',
          name: '日用品',
          type: AppConstants.typeExpense,
          iconCode: 0xe8cc,
          isCustom: false),
      Category(
          id: 'exp_digital',
          name: '数码电器',
          type: AppConstants.typeExpense,
          iconCode: 0xe1b8,
          isCustom: false),
      Category(
          id: 'exp_transport',
          name: '交通',
          type: AppConstants.typeExpense,
          iconCode: 0xe530,
          isCustom: false),
      Category(
          id: 'exp_car_maintain',
          name: '汽车保养',
          type: AppConstants.typeExpense,
          iconCode: 0xe531,
          isCustom: false),
      Category(
          id: 'exp_housing',
          name: '住房',
          type: AppConstants.typeExpense,
          iconCode: 0xe318,
          isCustom: false),
      Category(
          id: 'exp_utilities',
          name: '水电煤气',
          type: AppConstants.typeExpense,
          iconCode: 0xe87d,
          isCustom: false),
      Category(
          id: 'exp_home_repair',
          name: '家居维修',
          type: AppConstants.typeExpense,
          iconCode: 0xe869,
          isCustom: false),
      Category(
          id: 'exp_communication',
          name: '通讯',
          type: AppConstants.typeExpense,
          iconCode: 0xe0b0,
          isCustom: false),
      Category(
          id: 'exp_entertainment',
          name: '娱乐',
          type: AppConstants.typeExpense,
          iconCode: 0xe30a,
          isCustom: false),
      Category(
          id: 'exp_sports',
          name: '运动',
          type: AppConstants.typeExpense,
          iconCode: 0xe4dc,
          isCustom: false),
      Category(
          id: 'exp_travel',
          name: '旅游',
          type: AppConstants.typeExpense,
          iconCode: 0xe53d,
          isCustom: false),
      Category(
          id: 'exp_medical',
          name: '医疗',
          type: AppConstants.typeExpense,
          iconCode: 0xe3bf,
          isCustom: false),
      Category(
          id: 'exp_beauty',
          name: '美容',
          type: AppConstants.typeExpense,
          iconCode: 0xe556,
          isCustom: false),
      Category(
          id: 'exp_education',
          name: '教育',
          type: AppConstants.typeExpense,
          iconCode: 0xe5c3,
          isCustom: false),
      Category(
          id: 'exp_children',
          name: '孩子教育',
          type: AppConstants.typeExpense,
          iconCode: 0xe8e5,
          isCustom: false),
      Category(
          id: 'exp_social',
          name: '社交人情',
          type: AppConstants.typeExpense,
          iconCode: 0xe7ef,
          isCustom: false),
      Category(
          id: 'exp_parents',
          name: '父母赡养',
          type: AppConstants.typeExpense,
          iconCode: 0xe7fb,
          isCustom: false),
      Category(
          id: 'exp_pet',
          name: '宠物',
          type: AppConstants.typeExpense,
          iconCode: 0xe91d,
          isCustom: false),
      Category(
          id: 'exp_insurance',
          name: '金融保险',
          type: AppConstants.typeExpense,
          iconCode: 0xe32a,
          isCustom: false),
      Category(
          id: 'exp_charity',
          name: '捐赠公益',
          type: AppConstants.typeExpense,
          iconCode: 0xe87e,
          isCustom: false),
      Category(
          id: 'exp_books',
          name: '书籍阅读',
          type: AppConstants.typeExpense,
          iconCode: 0xe865,
          isCustom: false),
      Category(
          id: 'exp_membership',
          name: '会员订阅',
          type: AppConstants.typeExpense,
          iconCode: 0xe8f4,
          isCustom: false),
      Category(
          id: 'exp_game',
          name: '游戏充值',
          type: AppConstants.typeExpense,
          iconCode: 0xe30e,
          isCustom: false),
      Category(
          id: 'exp_express',
          name: '快递物流',
          type: AppConstants.typeExpense,
          iconCode: 0xe558,
          isCustom: false),
      Category(
          id: 'exp_medicine',
          name: '药品保健',
          type: AppConstants.typeExpense,
          iconCode: 0xe3be,
          isCustom: false),
      Category(
          id: 'exp_furniture',
          name: '家具家电',
          type: AppConstants.typeExpense,
          iconCode: 0xe30b,
          isCustom: false),
      Category(
          id: 'exp_payment',
          name: '生活缴费',
          type: AppConstants.typeExpense,
          iconCode: 0xe8e0,
          isCustom: false),
      Category(
          id: 'exp_parking',
          name: '停车费',
          type: AppConstants.typeExpense,
          iconCode: 0xe54f,
          isCustom: false),
      Category(
          id: 'exp_internet',
          name: '话费宽带',
          type: AppConstants.typeExpense,
          iconCode: 0xe0af,
          isCustom: false),
      Category(
          id: 'exp_takeout',
          name: '外卖',
          type: AppConstants.typeExpense,
          iconCode: 0xe56c,
          isCustom: false),
      Category(
          id: 'exp_coffee',
          name: '咖啡饮品',
          type: AppConstants.typeExpense,
          iconCode: 0xefef,
          isCustom: false),
      Category(
          id: 'exp_haircut',
          name: '美发护理',
          type: AppConstants.typeExpense,
          iconCode: 0xe91f,
          isCustom: false),
      Category(
          id: 'exp_photo',
          name: '摄影拍照',
          type: AppConstants.typeExpense,
          iconCode: 0xe412,
          isCustom: false),
      Category(
          id: 'exp_office',
          name: '办公用品',
          type: AppConstants.typeExpense,
          iconCode: 0xe0e8,
          isCustom: false),
      Category(
          id: 'exp_gift_out',
          name: '送礼支出',
          type: AppConstants.typeExpense,
          iconCode: 0xe8f5,
          isCustom: false),
      Category(
          id: 'exp_other',
          name: '其他支出',
          type: AppConstants.typeExpense,
          iconCode: 0xe5c3,
          isCustom: false),
    ];
  }
}
