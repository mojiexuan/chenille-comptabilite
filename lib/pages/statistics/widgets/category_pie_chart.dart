import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:chenille_comptabilite/config/constants.dart';
import 'package:chenille_comptabilite/config/theme.dart';
import 'package:chenille_comptabilite/models/transaction.dart';
import 'package:chenille_comptabilite/providers/data_provider.dart';
import 'package:chenille_comptabilite/utils/number_util.dart';

/// 分类饼图
class CategoryPieChart extends StatelessWidget {
  final List<TransactionRecord> transactions;
  final DataProvider dataProvider;

  const CategoryPieChart({
    super.key,
    required this.transactions,
    required this.dataProvider,
  });

  @override
  Widget build(BuildContext context) {
    final expenseData = _preparePieData();
    final screenWidth = MediaQuery.of(context).size.width;

    if (expenseData.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题
          const Text(
            '支出分类统计（Top 5）',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          // 饼图（居中显示）
          Center(
            child: SizedBox(
              height: 180,
              width: 180,
              child: PieChart(_buildPieChart(expenseData, screenWidth)),
            ),
          ),
          const SizedBox(height: 20),
          // 图例（下方显示，横向排列）
          _buildLegend(expenseData),
        ],
      ),
    );
  }

  /// 准备饼图数据
  List<_PieData> _preparePieData() {
    final Map<String, double> categoryAmount = {};
    double totalExpense = 0;

    // 只统计支出
    for (var transaction in transactions) {
      if (transaction.type == AppConstants.typeExpense) {
        categoryAmount[transaction.categoryId] =
            (categoryAmount[transaction.categoryId] ?? 0) + transaction.amount;
        totalExpense += transaction.amount;
      }
    }

    if (totalExpense == 0) return [];

    // 按金额降序排序，取前5
    final sortedEntries = categoryAmount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final topEntries = sortedEntries.take(5).toList();

    return topEntries.asMap().entries.map((entry) {
      final category = dataProvider.getCategoryById(entry.value.key);
      final percentage = (entry.value.value / totalExpense * 100);
      return _PieData(
        categoryName: category?.name ?? '未知',
        amount: entry.value.value,
        percentage: percentage,
        color: _getColor(entry.key),
      );
    }).toList();
  }

  /// 构建饼图
  PieChartData _buildPieChart(List<_PieData> data, double screenWidth) {
    return PieChartData(
      sectionsSpace: 2,
      centerSpaceRadius: 40,
      sections: data.map((item) {
        return PieChartSectionData(
          color: item.color,
          value: item.amount,
          title: '${item.percentage.toStringAsFixed(1)}%',
          radius: 50,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        );
      }).toList(),
    );
  }

  /// 构建图例（横向网格布局）
  Widget _buildLegend(List<_PieData> data) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Wrap(
          spacing: 20,
          runSpacing: 12,
          children: data.map((item) {
            return SizedBox(
              width: (constraints.maxWidth - 20) / 2, // 两列布局
              child: Row(
                children: [
                  // 颜色标识
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: item.color,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // 分类名称和金额
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.categoryName,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '¥${NumberUtil.formatMoney(item.amount)}',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }

  /// 获取颜色
  Color _getColor(int index) {
    const colors = [
      AppTheme.expenseColor,
      AppTheme.primaryColor,
      AppTheme.secondaryColor,
      Colors.purple,
      Colors.teal,
    ];
    return colors[index % colors.length];
  }
}

/// 饼图数据
class _PieData {
  final String categoryName;
  final double amount;
  final double percentage;
  final Color color;

  _PieData({
    required this.categoryName,
    required this.amount,
    required this.percentage,
    required this.color,
  });
}
