import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:chenille_comptabilite/config/constants.dart';
import 'package:chenille_comptabilite/config/theme.dart';
import 'package:chenille_comptabilite/models/transaction.dart';
import 'package:chenille_comptabilite/utils/date_util.dart';

/// 趋势图表
class TrendChart extends StatelessWidget {
  final List<TransactionRecord> transactions;
  final String period;
  final DateTime startDate;
  final DateTime endDate;

  const TrendChart({
    super.key,
    required this.transactions,
    required this.period,
    required this.startDate,
    required this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    final chartData = _prepareChartData();
    final screenWidth = MediaQuery.of(context).size.width;

    if (chartData.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(40),
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
        child: const Center(
          child: Text(
            '暂无数据',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(screenWidth * 0.04), // 响应式内边距
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
          Text(
            '收支趋势',
            style: TextStyle(
              fontSize: screenWidth * 0.042, // 响应式字体
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: screenWidth * 0.04),
          SizedBox(
            height: screenWidth * 0.5, // 响应式高度
            child: LineChart(_buildLineChart(chartData)),
          ),
        ],
      ),
    );
  }

  /// 准备图表数据
  List<_ChartPoint> _prepareChartData() {
    final Map<DateTime, double> incomeMap = {};
    final Map<DateTime, double> expenseMap = {};

    for (var transaction in transactions) {
      DateTime key;
      switch (period) {
        case AppConstants.periodWeek:
          key = DateTime(transaction.date.year, transaction.date.month,
              transaction.date.day);
          break;
        case AppConstants.periodMonth:
          key = DateTime(transaction.date.year, transaction.date.month,
              transaction.date.day);
          break;
        case AppConstants.periodYear:
          key = DateTime(transaction.date.year, transaction.date.month);
          break;
        default:
          key = DateTime(transaction.date.year, transaction.date.month,
              transaction.date.day);
      }

      if (transaction.type == AppConstants.typeIncome) {
        incomeMap[key] = (incomeMap[key] ?? 0) + transaction.amount;
      } else {
        expenseMap[key] = (expenseMap[key] ?? 0) + transaction.amount;
      }
    }

    final allKeys = {...incomeMap.keys, ...expenseMap.keys}.toList()..sort();
    return allKeys.map((key) {
      return _ChartPoint(
        date: key,
        income: incomeMap[key] ?? 0,
        expense: expenseMap[key] ?? 0,
      );
    }).toList();
  }

  /// 构建折线图
  LineChartData _buildLineChart(List<_ChartPoint> data) {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.grey[200]!,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: (value, meta) {
              if (value.toInt() >= data.length) return const Text('');
              final point = data[value.toInt()];
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _getBottomTitle(point.date),
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              );
            },
          ),
        ),
        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(show: false),
      lineBarsData: [
        // 收入线
        LineChartBarData(
          spots: data.asMap().entries.map((e) {
            return FlSpot(e.key.toDouble(), e.value.income);
          }).toList(),
          isCurved: true,
          color: AppTheme.incomeColor,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(show: false),
        ),
        // 支出线
        LineChartBarData(
          spots: data.asMap().entries.map((e) {
            return FlSpot(e.key.toDouble(), e.value.expense);
          }).toList(),
          isCurved: true,
          color: AppTheme.expenseColor,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(show: false),
        ),
      ],
    );
  }

  /// 获取底部标题
  String _getBottomTitle(DateTime date) {
    switch (period) {
      case AppConstants.periodWeek:
        return '${date.day}';
      case AppConstants.periodMonth:
        return '${date.day}';
      case AppConstants.periodYear:
        return '${date.month}月';
      default:
        return '';
    }
  }
}

/// 图表数据点
class _ChartPoint {
  final DateTime date;
  final double income;
  final double expense;

  _ChartPoint({
    required this.date,
    required this.income,
    required this.expense,
  });
}
