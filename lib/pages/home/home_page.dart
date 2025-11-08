import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chenille_comptabilite/config/constants.dart';
import 'package:chenille_comptabilite/config/theme.dart';
import 'package:chenille_comptabilite/providers/data_provider.dart';
import 'package:chenille_comptabilite/pages/home/widgets/month_summary_card.dart';
import 'package:chenille_comptabilite/pages/home/widgets/daily_transactions_list.dart';
import 'package:chenille_comptabilite/utils/date_util.dart';
import 'package:chenille_comptabilite/widgets/custom_app_bar.dart';

/// 首页
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.backgroundColor,
      child: Column(
        children: [
          const CustomAppBar(title: '毛虫记账'),
          Expanded(
            child: Consumer<DataProvider>(
              builder: (context, dataProvider, child) {
                final now = DateTime.now();
                final monthStart = DateUtil.getMonthFirstDay(now);
                final monthEnd = DateUtil.getMonthLastDay(now);

                // 筛选本月的交易记录
                final monthTransactions = dataProvider.transactions.where((t) {
                  return t.date.isAfter(
                          monthStart.subtract(const Duration(days: 1))) &&
                      t.date.isBefore(monthEnd.add(const Duration(days: 1)));
                }).toList();

                // 计算本月收入和支出
                double monthIncome = 0;
                double monthExpense = 0;
                for (var t in monthTransactions) {
                  if (t.type == AppConstants.typeIncome) {
                    monthIncome += t.amount;
                  } else {
                    monthExpense += t.amount;
                  }
                }

                return Column(
                  children: [
                    // 本月收支汇总卡片
                    MonthSummaryCard(
                      income: monthIncome,
                      expense: monthExpense,
                      yearMonth: DateUtil.formatYearMonth(now),
                    ),
                    // 每日交易记录列表
                    Expanded(
                      child: DailyTransactionsList(
                        transactions: dataProvider.transactions,
                        dataProvider: dataProvider,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
