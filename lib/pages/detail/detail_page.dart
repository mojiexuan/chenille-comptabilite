import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chenille_comptabilite/config/constants.dart';
import 'package:chenille_comptabilite/config/theme.dart';
import 'package:chenille_comptabilite/providers/data_provider.dart';
import 'package:chenille_comptabilite/pages/detail/widgets/collapsible_calendar.dart';
import 'package:chenille_comptabilite/pages/home/widgets/transaction_item.dart';
import 'package:chenille_comptabilite/utils/date_util.dart';
import 'package:chenille_comptabilite/utils/number_util.dart';
import 'package:chenille_comptabilite/widgets/empty_view.dart';
import 'package:chenille_comptabilite/widgets/custom_app_bar.dart';

/// 明细页
class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.backgroundColor,
      child: Column(
        children: [
          const CustomAppBar(title: '明细'),
          // 可折叠日历组件
          CollapsibleCalendar(
            selectedDate: _selectedDate,
            onDateSelected: (date) {
              setState(() {
                _selectedDate = date;
              });
            },
            onExpanded: (expanded) {
              // 日历展开状态变化回调（如需要可以使用）
            },
          ),
          // 交易记录列表
          Expanded(
            child: Consumer<DataProvider>(
              builder: (context, dataProvider, child) {
                // 筛选选中日期的交易记录
                final dayTransactions = dataProvider.transactions
                    .where((t) => DateUtil.isSameDay(t.date, _selectedDate))
                    .toList();

                if (dayTransactions.isEmpty) {
                  return const EmptyView(
                    message: '这天还没有记账记录',
                    icon: Icons.event_busy_outlined,
                  );
                }

                // 计算当天收支
                double dayIncome = 0;
                double dayExpense = 0;
                for (var t in dayTransactions) {
                  if (t.type == AppConstants.typeIncome) {
                    dayIncome += t.amount;
                  } else {
                    dayExpense += t.amount;
                  }
                }

                return Column(
                  children: [
                    // 当天收支汇总
                    _buildDaySummary(dayIncome, dayExpense),
                    // 交易记录列表
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).padding.bottom + 80,
                        ),
                        itemCount: dayTransactions.length,
                        itemBuilder: (context, index) {
                          return TransactionItem(
                            transaction: dayTransactions[index],
                            dataProvider: dataProvider,
                          );
                        },
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

  /// 构建当天收支汇总
  Widget _buildDaySummary(double income, double expense) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryItem('收入', income, Colors.green),
          Container(
            width: 1,
            height: 30,
            color: Colors.grey[300],
          ),
          _buildSummaryItem('支出', expense, Colors.red),
        ],
      ),
    );
  }

  /// 构建汇总项
  Widget _buildSummaryItem(String label, double amount, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '¥${NumberUtil.formatMoney(amount)}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
