import 'package:flutter/material.dart';
import 'package:chenille_comptabilite/config/theme.dart';

/// 金额和备注输入行（合并在一行）
class AmountNoteRow extends StatelessWidget {
  final String amount;
  final String note;
  final ValueChanged<String> onNoteChanged;

  const AmountNoteRow({
    super.key,
    required this.amount,
    required this.note,
    required this.onNoteChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // 金额显示
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '金额',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  amount.isEmpty ? '0' : '¥$amount',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: amount.isEmpty
                        ? Colors.grey[400]
                        : AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ),
          // 分隔线
          Container(
            width: 1,
            height: 40,
            color: Colors.grey[300],
            margin: const EdgeInsets.symmetric(horizontal: 16),
          ),
          // 备注输入
          Expanded(
            flex: 3,
            child: TextField(
              onChanged: onNoteChanged,
              autofocus: false, // 不自动聚焦
              decoration: InputDecoration(
                hintText: '添加备注...',
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[400],
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textPrimary,
              ),
              maxLines: 1,
              maxLength: 10, // 限制10个字
              buildCounter: (
                context, {
                required currentLength,
                required isFocused,
                maxLength,
              }) {
                return null; // 隐藏计数器
              },
            ),
          ),
        ],
      ),
    );
  }
}
