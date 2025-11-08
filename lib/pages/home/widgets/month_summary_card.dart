import 'package:flutter/material.dart';
import 'package:chenille_comptabilite/config/theme.dart';
import 'package:chenille_comptabilite/utils/number_util.dart';

/// 本月收支汇总卡片
class MonthSummaryCard extends StatelessWidget {
  final double income;
  final double expense;
  final String yearMonth;

  const MonthSummaryCard({
    super.key,
    required this.income,
    required this.expense,
    required this.yearMonth,
  });

  @override
  Widget build(BuildContext context) {
    final balance = income - expense;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            yearMonth,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildAmountItem('收入', income, AppTheme.incomeColor),
              _buildAmountItem('支出', expense, AppTheme.expenseColor),
              _buildAmountItem('结余', balance, AppTheme.primaryColor),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建金额项
  Widget _buildAmountItem(String label, double amount, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '¥${NumberUtil.formatMoney(amount)}',
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
