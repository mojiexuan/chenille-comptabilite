import 'package:flutter/material.dart';
import 'package:chenille_comptabilite/config/theme.dart';

/// 金额输入显示组件（不可编辑，配合自定义键盘使用）
class AmountInput extends StatelessWidget {
  final String amount;

  const AmountInput({
    super.key,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '金额',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              const Text(
                '¥ ',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textSecondary,
                ),
              ),
              Expanded(
                child: Text(
                  amount.isEmpty ? '0.00' : amount,
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: amount.isEmpty
                        ? AppTheme.textHint
                        : AppTheme.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(thickness: 2),
      ],
    );
  }
}
