import 'package:flutter/material.dart';
import 'package:chenille_comptabilite/pages/detail/widgets/calendar_header.dart';
import 'package:chenille_comptabilite/pages/detail/widgets/calendar_week_row.dart';
import 'package:chenille_comptabilite/pages/detail/widgets/calendar_day_cell.dart';

/// 可折叠日历组件（支持周视图和月视图切换）
class CollapsibleCalendar extends StatefulWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final ValueChanged<bool> onExpanded;

  const CollapsibleCalendar({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    required this.onExpanded,
  });

  @override
  State<CollapsibleCalendar> createState() => _CollapsibleCalendarState();
}

class _CollapsibleCalendarState extends State<CollapsibleCalendar>
    with SingleTickerProviderStateMixin {
  late DateTime _currentMonth;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _currentMonth =
        DateTime(widget.selectedDate.year, widget.selectedDate.month);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragEnd: _handleDrag,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CalendarHeader(
              currentMonth: _currentMonth,
              isExpanded: _isExpanded,
              onPreviousMonth: _previousMonth,
              onNextMonth: _nextMonth,
              onToggleExpanded: _toggleExpanded,
            ),
            const SizedBox(height: 16),
            const CalendarWeekRow(),
            const SizedBox(height: 8),
            _buildCalendarGrid(),
          ],
        ),
      ),
    );
  }

  /// 构建日历网格
  Widget _buildCalendarGrid() {
    if (_isExpanded) {
      return _buildMonthView();
    } else {
      return _buildWeekView();
    }
  }

  /// 构建月视图
  Widget _buildMonthView() {
    final daysInMonth = _getDaysInMonth();
    final firstDayWeekday =
        DateTime(_currentMonth.year, _currentMonth.month, 1).weekday;
    final totalDays = daysInMonth + firstDayWeekday - 1;
    final rows = (totalDays / 7).ceil();

    return Column(
      children: List.generate(rows, (rowIndex) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(7, (colIndex) {
              final dayIndex = rowIndex * 7 + colIndex;
              final day = dayIndex - firstDayWeekday + 2;

              if (day < 1 || day > daysInMonth) {
                return const SizedBox(width: 36, height: 36);
              }

              final date =
                  DateTime(_currentMonth.year, _currentMonth.month, day);
              return CalendarDayCell(
                date: date,
                selectedDate: widget.selectedDate,
                currentMonth: _currentMonth,
                onDateSelected: widget.onDateSelected,
              );
            }),
          ),
        );
      }),
    );
  }

  /// 构建周视图
  Widget _buildWeekView() {
    final selectedWeekday = widget.selectedDate.weekday;
    final weekStart =
        widget.selectedDate.subtract(Duration(days: selectedWeekday - 1));

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(7, (index) {
          final date = weekStart.add(Duration(days: index));
          return CalendarDayCell(
            date: date,
            selectedDate: widget.selectedDate,
            currentMonth: _currentMonth,
            onDateSelected: widget.onDateSelected,
          );
        }),
      ),
    );
  }

  /// 获取当月天数
  int _getDaysInMonth() {
    return DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;
  }

  /// 上一月
  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
  }

  /// 下一月
  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
  }

  /// 切换展开/折叠
  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      widget.onExpanded(_isExpanded);
    });
  }

  /// 处理拖动手势
  void _handleDrag(DragEndDetails details) {
    if (details.primaryVelocity == null) return;

    if (details.primaryVelocity! < -500) {
      // 向上滑动：折叠到周视图
      if (_isExpanded) {
        _toggleExpanded();
      }
    } else if (details.primaryVelocity! > 500) {
      // 向下滑动：展开到月视图
      if (!_isExpanded) {
        _toggleExpanded();
      }
    }
  }
}
