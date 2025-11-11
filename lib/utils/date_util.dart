import 'package:intl/intl.dart';

/// 日期工具类
class DateUtil {
  /// 格式化日期 - 年月日
  static String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  /// 格式化日期 - 月日（中文）
  static String formatMonthDay(DateTime date) {
    return '${date.month}月${date.day}日';
  }

  /// 格式化日期 - 年月（中文）
  static String formatYearMonth(DateTime date) {
    return '${date.year}年${date.month}月';
  }

  /// 格式化日期 - 完整（中文）
  static String formatFull(DateTime date) {
    final weekdays = ['', '周一', '周二', '周三', '周四', '周五', '周六', '周日'];
    return '${date.year}年${date.month}月${date.day}日 ${weekdays[date.weekday]}';
  }

  /// 判断是否为今天
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// 判断是否为昨天
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  /// 获取月份第一天
  static DateTime getMonthFirstDay(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  /// 获取月份最后一天
  static DateTime getMonthLastDay(DateTime date) {
    return DateTime(date.year, date.month + 1, 0);
  }

  /// 获取周的第一天（周一）
  static DateTime getWeekFirstDay(DateTime date) {
    final weekday = date.weekday;
    return date.subtract(Duration(days: weekday - 1));
  }

  /// 获取周的最后一天（周日）
  static DateTime getWeekLastDay(DateTime date) {
    final weekday = date.weekday;
    return date.add(Duration(days: 7 - weekday));
  }

  /// 获取年份第一天
  static DateTime getYearFirstDay(DateTime date) {
    return DateTime(date.year, 1, 1);
  }

  /// 获取年份最后一天
  static DateTime getYearLastDay(DateTime date) {
    return DateTime(date.year, 12, 31);
  }

  /// 判断两个日期是否为同一天
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  /// 判断两个日期是否为同一月
  static bool isSameMonth(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month;
  }

  /// 获取相对日期描述
  static String getRelativeDateDesc(DateTime date) {
    if (isToday(date)) {
      return '今天';
    } else if (isYesterday(date)) {
      return '昨天';
    } else {
      return formatMonthDay(date);
    }
  }

  /// 格式化日期 - 完整（带相对日期优化）
  /// 今天显示：今天 周一
  /// 昨天显示：昨天 周日
  /// 其他日期显示：2025年11月9日 周六
  static String formatFullWithRelative(DateTime date) {
    final weekdays = ['', '周一', '周二', '周三', '周四', '周五', '周六', '周日'];
    final weekday = weekdays[date.weekday];

    if (isToday(date)) {
      return '今天 $weekday';
    } else if (isYesterday(date)) {
      return '昨天 $weekday';
    } else {
      return '${date.year}年${date.month}月${date.day}日 $weekday';
    }
  }
}
