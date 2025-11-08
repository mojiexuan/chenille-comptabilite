import 'package:flutter/material.dart';
import 'package:chenille_comptabilite/config/theme.dart';
import 'package:chenille_comptabilite/utils/date_util.dart';

/// 日期选择栏组件
class DateBarSelector extends StatelessWidget {
  final DateTime selectedDate;
  final VoidCallback onTap;

  const DateBarSelector({
    super.key,
    required this.selectedDate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today,
              size: 18,
              color: AppTheme.primaryColor,
            ),
            const SizedBox(width: 12),
            Text(
              DateUtil.formatFull(selectedDate),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppTheme.textPrimary,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_drop_down,
              color: AppTheme.primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
