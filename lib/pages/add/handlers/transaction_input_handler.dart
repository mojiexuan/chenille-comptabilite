import 'package:chenille_comptabilite/utils/number_util.dart';

/// 交易输入处理器
/// 负责处理金额输入逻辑
class TransactionInputHandler {
  /// 金额上限（1千万）
  static const double maxAmount = 10000000.0;

  /// 处理键盘输入
  /// 返回新的金额字符串，如果输入无效则返回null
  static String? handleKeyInput(String currentAmount, String key) {
    if (key == '.') {
      // 处理小数点
      if (currentAmount.contains('.')) return null;
      if (currentAmount.isEmpty) {
        return '0.';
      } else {
        return currentAmount + '.';
      }
    } else {
      // 处理数字
      String newAmount;
      if (currentAmount == '0') {
        newAmount = key;
      } else {
        newAmount = currentAmount + key;
      }

      // 检查金额是否超过上限
      final parsedAmount = NumberUtil.parseMoney(newAmount);
      if (parsedAmount != null && parsedAmount > maxAmount) {
        return null; // 超过上限，返回null表示无效
      }

      // 检查小数位数
      if (newAmount.contains('.')) {
        final parts = newAmount.split('.');
        if (parts[1].length > 2) return null;
      }

      return newAmount;
    }
  }

  /// 处理删除操作
  /// 返回删除后的金额字符串
  static String handleDelete(String currentAmount) {
    if (currentAmount.isEmpty) return '';
    return currentAmount.substring(0, currentAmount.length - 1);
  }

  /// 验证金额是否有效
  /// 返回验证结果和错误信息（如果有）
  static ValidationResult validateAmount(String amount) {
    if (amount.isEmpty) {
      return ValidationResult(false, '请输入金额');
    }

    final amountValue = NumberUtil.parseMoney(amount);
    if (amountValue == null || amountValue <= 0) {
      return ValidationResult(false, '请输入有效的金额');
    }

    if (amountValue > maxAmount) {
      return ValidationResult(false, '单笔金额不能超过1千万');
    }

    return ValidationResult(true, null);
  }
}

/// 验证结果
class ValidationResult {
  final bool isValid;
  final String? errorMessage;

  ValidationResult(this.isValid, this.errorMessage);
}
