import 'package:flutter/material.dart';
import 'package:chenille_comptabilite/config/theme.dart';
import 'package:chenille_comptabilite/utils/date_util.dart';

/// 可折叠日历组件（支持周视图和月视图切换）
class CollapsibleCalendar extends StatefulWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final ValueChanged<bool> onExpanded; // 通知父组件展开/折叠状态

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
  bool _isExpanded = false; // 默认关闭（周视图）

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
            _buildHeader(),
            const SizedBox(height: 16),
            _buildWeekDays(),
            const SizedBox(height: 8),
            _buildCalendarGrid(),
          ],
        ),
      ),
    );
  }

  /// 构建头部（年月和切换按钮）
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: _previousMonth,
        ),
        GestureDetector(
          onTap: _toggleExpanded,
          child: Row(
            children: [
              Text(
                DateUtil.formatYearMonth(_currentMonth),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                _isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                size: 20,
                color: AppTheme.primaryColor,
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: _nextMonth,
        ),
      ],
    );
  }

  /// 构建星期标题
  Widget _buildWeekDays() {
    const weekDays = ['一', '二', '三', '四', '五', '六', '日'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: weekDays.map((day) {
        return SizedBox(
          width: 36,
          child: Text(
            day,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
    );
  }

  /// 构建日历网格
  Widget _buildCalendarGrid() {
    if (_isExpanded) {
      // 月视图：显示整月
      return _buildMonthView();
    } else {
      // 周视图：只显示选中日期所在的周
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
              return _buildDayCell(date);
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
          return _buildDayCell(date);
        }),
      ),
    );
  }

  /// 构建日期单元格
  Widget _buildDayCell(DateTime date) {
    final isSelected = DateUtil.isSameDay(date, widget.selectedDate);
    final isToday = DateUtil.isToday(date);
    final isFuture = date.isAfter(DateTime.now());
    final isCurrentMonth = date.month == _currentMonth.month;

    return GestureDetector(
      onTap: isFuture ? null : () => widget.onDateSelected(date),
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
