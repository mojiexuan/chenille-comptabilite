import 'package:intl/intl.dart';

/// 数字工具类
class NumberUtil {
  /// 格式化金额 - 保留两位小数
  static String formatMoney(double amount) {
    return amount.toStringAsFixed(2);
  }

  /// 格式化金额 - 带千分位
  static String formatMoneyWithComma(double amount) {
    final formatter = NumberFormat('#,##0.00', 'zh_CN');
    return formatter.format(amount);
  }

  /// 格式化金额 - 智能显示（大额简化）
  static String formatMoneySimple(double amount) {
    if (amount >= 10000) {
      return '${(amount / 10000).toStringAsFixed(2)}万';
    }
    return formatMoney(amount);
  }

  /// 解析金额字符串
  static double? parseMoney(String text) {
    try {
      return double.parse(text);
    } catch (e) {
      return null;
    }
  }

  /// 验证金额格式（最多两位小数）
  static bool isValidMoney(String text) {
    final regex = RegExp(r'^\d+(\.\d{0,2})?$');
    return regex.hasMatch(text);
  }
}

