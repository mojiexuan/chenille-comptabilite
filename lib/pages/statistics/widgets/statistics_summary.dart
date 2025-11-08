import 'package:flutter/material.dart';
import 'package:chenille_comptabilite/config/theme.dart';
import 'package:chenille_comptabilite/utils/number_util.dart';

/// 统计汇总卡片
class StatisticsSummary extends StatelessWidget {
  final double income;
  final double expense;
  final int incomeCount;
  final int expenseCount;
  final int days;

  const StatisticsSummary({
    super.key,
    required this.income,
    required this.expense,
    this.incomeCount = 0,
    this.expenseCount = 0,
    this.days = 1,
  });

  @override
  Widget build(BuildContext context) {
    final balance = income - expense;
    final dailyAvg = days > 0 ? expense / days : 0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryColor.withOpacity(0.1),
            AppTheme.secondaryColor.withOpacity(0.1),
          ],
        ),
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
        children: [
          // 结余
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '结余',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '¥${NumberUtil.formatMoneyWithComma(balance)}',
                style: TextStyle(
                  color: balance >= 0
                      ? AppTheme.incomeColor
                      : AppTheme.expenseColor,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // 收入支出
          Row(
            children: [
              Expanded(
                child: _buildMainItem(
                    '收入', income, incomeCount, AppTheme.incomeColor),
              ),
              Container(
                width: 1,
                height: 50,
                color: Colors.grey[300],
              ),
              Expanded(
                child: _buildMainItem(
                    '支出', expense, expenseCount, AppTheme.expenseColor),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 日均支出和笔数统计
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSubItem(
                    '日均支出', '¥${NumberUtil.formatMoney(dailyAvg.toDouble())}'),
                Container(width: 1, height: 20, color: Colors.grey[300]),
                _buildSubItem('总笔数', '${incomeCount + expenseCount}'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建主要项（收入/支出）
  Widget _buildMainItem(String label, double amount, int count, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '¥${NumberUtil.formatMoneyWithComma(amount)}',
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '$count笔',
          style: TextStyle(
            color: Colors.grey[500],
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  /// 构建次要项
  Widget _buildSubItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
