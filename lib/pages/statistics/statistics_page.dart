import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chenille_comptabilite/config/constants.dart';
import 'package:chenille_comptabilite/config/theme.dart';
import 'package:chenille_comptabilite/providers/data_provider.dart';
import 'package:chenille_comptabilite/pages/statistics/widgets/period_selector.dart';
import 'package:chenille_comptabilite/pages/statistics/widgets/trend_chart.dart';
import 'package:chenille_comptabilite/pages/statistics/widgets/category_pie_chart.dart';
import 'package:chenille_comptabilite/pages/statistics/widgets/statistics_summary.dart';
import 'package:chenille_comptabilite/utils/date_util.dart';
import 'package:chenille_comptabilite/widgets/custom_app_bar.dart';

/// 统计页
class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  String _period = AppConstants.periodMonth;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.backgroundColor,
      child: Column(
        children: [
          const CustomAppBar(title: '统计'),
          // 周期选择器（固定在顶部）
          Container(
            color: AppTheme.backgroundColor,
            child: PeriodSelector(
              selectedPeriod: _period,
              onPeriodChanged: (period) {
                setState(() {
                  _period = period;
                });
              },
            ),
          ),
          // 可滚动内容区域
          Expanded(
            child: Consumer<DataProvider>(
              builder: (context, dataProvider, child) {
                final now = DateTime.now();
                DateTime startDate;
                DateTime endDate;

                // 根据周期确定日期范围
                switch (_period) {
                  case AppConstants.periodWeek:
                    startDate = DateUtil.getWeekFirstDay(now);
                    endDate = DateUtil.getWeekLastDay(now);
                    break;
                  case AppConstants.periodMonth:
                    startDate = DateUtil.getMonthFirstDay(now);
                    endDate = DateUtil.getMonthLastDay(now);
                    break;
                  case AppConstants.periodYear:
                    startDate = DateUtil.getYearFirstDay(now);
                    endDate = DateUtil.getYearLastDay(now);
                    break;
                  default:
                    startDate = DateUtil.getMonthFirstDay(now);
                    endDate = DateUtil.getMonthLastDay(now);
                }

                // 筛选周期内的交易记录
                final periodTransactions = dataProvider.transactions.where((t) {
                  return t.date.isAfter(
                          startDate.subtract(const Duration(days: 1))) &&
                      t.date.isBefore(endDate.add(const Duration(days: 1)));
                }).toList();

                // 计算总收入、总支出和笔数
                double totalIncome = 0;
                double totalExpense = 0;
                int incomeCount = 0;
                int expenseCount = 0;
                for (var t in periodTransactions) {
                  if (t.type == AppConstants.typeIncome) {
                    totalIncome += t.amount;
                    incomeCount++;
                  } else {
                    totalExpense += t.amount;
                    expenseCount++;
                  }
                }

                // 计算天数
                final days = endDate.difference(startDate).inDays + 1;

                return SingleChildScrollView(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.bottom + 80,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      // 统计汇总
                      StatisticsSummary(
                        income: totalIncome,
                        expense: totalExpense,
                        incomeCount: incomeCount,
                        expenseCount: expenseCount,
                        days: days,
                      ),
                      const SizedBox(height: 8),
                      // 趋势图表
                      TrendChart(
                        transactions: periodTransactions,
                        period: _period,
                        startDate: startDate,
                        endDate: endDate,
                      ),
                      const SizedBox(height: 8),
                      // 分类饼图
                      CategoryPieChart(
                        transactions: periodTransactions,
                        dataProvider: dataProvider,
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
