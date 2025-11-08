import 'package:chenille_comptabilite/config/constants.dart';
import 'package:chenille_comptabilite/models/transaction.dart';

/// 图表数据处理器
/// 负责将交易记录转换为图表数据
class ChartDataHandler {
  /// 准备图表数据
  /// 根据时间周期聚合收入和支出数据
  static List<ChartDataPoint> prepareChartData({
    required List<TransactionRecord> transactions,
    required String period,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    final Map<DateTime, double> incomeMap = {};
    final Map<DateTime, double> expenseMap = {};

    for (var transaction in transactions) {
      final key = _getDateKey(transaction.date, period);

      if (transaction.type == AppConstants.typeIncome) {
        incomeMap[key] = (incomeMap[key] ?? 0) + transaction.amount;
      } else {
        expenseMap[key] = (expenseMap[key] ?? 0) + transaction.amount;
      }
    }

    // 合并所有日期键并排序
    final allKeys = {...incomeMap.keys, ...expenseMap.keys}.toList()..sort();

    return allKeys.map((key) {
      return ChartDataPoint(
        date: key,
        income: incomeMap[key] ?? 0,
        expense: expenseMap[key] ?? 0,
      );
    }).toList();
  }

  /// 根据周期获取日期键
  static DateTime _getDateKey(DateTime date, String period) {
    switch (period) {
      case AppConstants.periodWeek:
      case AppConstants.periodMonth:
        return DateTime(date.year, date.month, date.day);
      case AppConstants.periodYear:
        return DateTime(date.year, date.month);
      default:
        return DateTime(date.year, date.month, date.day);
    }
  }

  /// 获取底部标题文本
  static String getBottomTitle(DateTime date, String period) {
    switch (period) {
      case AppConstants.periodWeek:
      case AppConstants.periodMonth:
        return '${date.day}';
      case AppConstants.periodYear:
        return '${date.month}月';
      default:
        return '';
    }
  }
}

/// 图表数据点
class ChartDataPoint {
  final DateTime date;
  final double income;
  final double expense;

  ChartDataPoint({
    required this.date,
    required this.income,
    required this.expense,
  });
}
