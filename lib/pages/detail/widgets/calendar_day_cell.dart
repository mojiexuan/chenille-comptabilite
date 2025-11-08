import 'package:flutter/material.dart';
import 'package:chenille_comptabilite/config/theme.dart';
import 'package:chenille_comptabilite/utils/date_util.dart';

/// 日历日期单元格组件
class CalendarDayCell extends StatelessWidget {
  final DateTime date;
  final DateTime selectedDate;
  final DateTime currentMonth;
  final ValueChanged<DateTime>? onDateSelected;

  const CalendarDayCell({
    super.key,
    required this.date,
    required this.selectedDate,
    required this.currentMonth,
    this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = DateUtil.isSameDay(date, selectedDate);
    final isToday = DateUtil.isToday(date);
    final isFuture = date.isAfter(DateTime.now());
    final isCurrentMonth = date.month == currentMonth.month;

    return GestureDetector(
      onTap: isFuture ? null : () => onDateSelected?.call(date),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryColor
              : isToday
                  ? AppTheme.primaryColor.withOpacity(0.1)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          '${date.day}',
          style: TextStyle(
            fontSize: 14,
            color: isFuture
                ? Colors.grey[400]
                : isSelected
                    ? Colors.white
                    : isToday
                        ? AppTheme.primaryColor
                        : isCurrentMonth
                            ? Colors.black87
                            : Colors.grey[400],
            fontWeight:
                isSelected || isToday ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
