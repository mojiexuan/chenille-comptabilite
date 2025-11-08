import 'package:flutter/material.dart';
import 'package:chenille_comptabilite/config/theme.dart';

/// 浮动日历对话框组件
class FloatingCalendarDialog extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateChanged;
  final VoidCallback onClose;

  const FloatingCalendarDialog({
    super.key,
    required this.selectedDate,
    required this.onDateChanged,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: GestureDetector(
        onTap: onClose,
        child: Container(
          color: Colors.black54,
          child: Center(
            child: GestureDetector(
              onTap: () {}, // 阻止冒泡
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 日历标题
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '选择日期',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: onClose,
                        ),
                      ],
                    ),
                    // 日历选择器
                    SizedBox(
                      height: 320,
                      child: Theme(
                        data: ThemeData(
                          primaryColor: AppTheme.primaryColor,
                          colorScheme: const ColorScheme.light(
                            primary: AppTheme.primaryColor,
                            onPrimary: AppTheme.textPrimary,
                            onSurface: AppTheme.textPrimary,
                            surface: Colors.white,
                          ),
                          textTheme: const TextTheme(
                            titleMedium: TextStyle(
                              color: AppTheme.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                            bodyLarge: TextStyle(color: AppTheme.textPrimary),
                            bodyMedium: TextStyle(color: AppTheme.textPrimary),
                            labelLarge: TextStyle(
                              color: AppTheme.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          useMaterial3: false,
                        ),
                        child: CalendarDatePicker(
                          initialDate: selectedDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                          onDateChanged: onDateChanged,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
