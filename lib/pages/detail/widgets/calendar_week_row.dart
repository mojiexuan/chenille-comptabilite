import 'package:flutter/material.dart';

/// 日历星期标题行组件
class CalendarWeekRow extends StatelessWidget {
  const CalendarWeekRow({super.key});

  @override
  Widget build(BuildContext context) {
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
}
