import 'package:flutter/material.dart';
import 'package:chenille_comptabilite/config/theme.dart';
import 'package:chenille_comptabilite/utils/date_util.dart';

/// 内联日历选择器（可展开/收起）
class InlineCalendarSelector extends StatefulWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const InlineCalendarSelector({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  State<InlineCalendarSelector> createState() => _InlineCalendarSelectorState();
}

class _InlineCalendarSelectorState extends State<InlineCalendarSelector> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // 日期显示栏（可点击展开）
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 18,
                    color: AppTheme.primaryColor,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    DateUtil.formatFull(widget.selectedDate),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppTheme.primaryColor,
                  ),
                ],
              ),
            ),
          ),
          // 日历面板
          if (_isExpanded)
            OverflowBox(
              maxHeight: 300, // 限制最大高度
              alignment: Alignment.topCenter,
              child: ClipRect(
                child: SizedBox(
                  height: 300,
                  child: Theme(
                    data: ThemeData(
                      // 修复日历选中日期文字颜色问题
                      // 使用深色主题色，确保白色文字在深色背景上清晰可见
                      primaryColor: const Color(0xFFFF5722), // 使用更深的橙色作为主色
                      colorScheme: const ColorScheme.light(
                        primary: Color(0xFFFF5722), // 选中日期的背景色（深橙色，确保白字可见）
                        onPrimary: Colors.white, // 选中日期的文字颜色（白色）
                        onSurface: AppTheme.textPrimary, // 未选中日期的文字颜色
                        surface: Colors.white, // 日历背景色
                      ),
                      // 强制设置文字样式，确保选中日期文字可见
                      textTheme: const TextTheme(
                        titleMedium: TextStyle(
                          color: Colors.white, // 选中日期的文字
                          fontWeight: FontWeight.w600,
                        ),
                        bodyLarge: TextStyle(color: AppTheme.textPrimary),
                        bodyMedium: TextStyle(color: AppTheme.textPrimary),
                        labelLarge: TextStyle(
                          color: Colors.white, // 选中日期按钮的文字
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // 使用 Material 3 设计
                      useMaterial3: false,
                    ),
                    child: Localizations.override(
                      context: context,
                      locale: const Locale('zh', 'CN'),
                      child: CalendarDatePicker(
                        initialDate: widget.selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                        onDateChanged: (date) {
                          widget.onDateSelected(date);
                          setState(() {
                            _isExpanded = false;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
