import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:chenille_comptabilite/config/theme.dart';
import 'package:chenille_comptabilite/models/transaction.dart';
import 'package:chenille_comptabilite/pages/statistics/handlers/chart_data_handler.dart';

/// 趋势图表组件
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
    final chartData = ChartDataHandler.prepareChartData(
      transactions: transactions,
      period: period,
      startDate: startDate,
      endDate: endDate,
    );

    if (chartData.isEmpty) {
      return _buildEmptyView();
    }

    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: _buildContainerDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '收支趋势',
            style: TextStyle(
              fontSize: screenWidth * 0.042,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: screenWidth * 0.04),
          SizedBox(
            height: screenWidth * 0.5,
            child: LineChart(_buildLineChart(chartData)),
          ),
        ],
      ),
    );
  }

  /// 构建空视图
  Widget _buildEmptyView() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(40),
      decoration: _buildContainerDecoration(),
      child: const Center(
        child: Text(
          '暂无数据',
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  /// 构建容器装饰
  BoxDecoration _buildContainerDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  /// 构建折线图
  LineChartData _buildLineChart(List<ChartDataPoint> data) {
    return LineChartData(
      gridData: _buildGridData(),
      titlesData: _buildTitlesData(data),
      borderData: FlBorderData(show: false),
      lineBarsData: [
        _buildIncomeLine(data),
        _buildExpenseLine(data),
      ],
    );
  }

  /// 构建网格数据
  FlGridData _buildGridData() {
    return FlGridData(
      show: true,
      drawVerticalLine: false,
      horizontalInterval: 1,
      getDrawingHorizontalLine: (value) {
        return FlLine(
          color: Colors.grey[200]!,
          strokeWidth: 1,
        );
      },
    );
  }

  /// 构建标题数据
  FlTitlesData _buildTitlesData(List<ChartDataPoint> data) {
    return FlTitlesData(
      show: true,
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
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
                ChartDataHandler.getBottomTitle(point.date, period),
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
            );
          },
        ),
      ),
    );
  }

  /// 构建收入线
  LineChartBarData _buildIncomeLine(List<ChartDataPoint> data) {
    return LineChartBarData(
      spots: data.asMap().entries.map((e) {
        return FlSpot(e.key.toDouble(), e.value.income);
      }).toList(),
      isCurved: true,
      color: AppTheme.incomeColor,
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
    );
  }

  /// 构建支出线
  LineChartBarData _buildExpenseLine(List<ChartDataPoint> data) {
    return LineChartBarData(
      spots: data.asMap().entries.map((e) {
        return FlSpot(e.key.toDouble(), e.value.expense);
      }).toList(),
      isCurved: true,
      color: AppTheme.expenseColor,
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
    );
  }
}
