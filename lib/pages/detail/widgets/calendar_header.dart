import 'package:flutter/material.dart';
import 'package:chenille_comptabilite/config/theme.dart';
import 'package:chenille_comptabilite/utils/date_util.dart';

/// 日历头部组件
class CalendarHeader extends StatelessWidget {
  final DateTime currentMonth;
  final bool isExpanded;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;
  final VoidCallback onToggleExpanded;

  const CalendarHeader({
    super.key,
    required this.currentMonth,
    required this.isExpanded,
    required this.onPreviousMonth,
    required this.onNextMonth,
    required this.onToggleExpanded,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: onPreviousMonth,
        ),
        GestureDetector(
          onTap: onToggleExpanded,
          child: Row(
            children: [
              Text(
                DateUtil.formatYearMonth(currentMonth),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                isExpanded
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
          onPressed: onNextMonth,
        ),
      ],
    );
  }
}
