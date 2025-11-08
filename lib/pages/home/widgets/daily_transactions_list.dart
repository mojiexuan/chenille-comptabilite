import 'package:flutter/material.dart';
import 'package:chenille_comptabilite/config/constants.dart';
import 'package:chenille_comptabilite/models/transaction.dart';
import 'package:chenille_comptabilite/providers/data_provider.dart';
import 'package:chenille_comptabilite/pages/home/widgets/transaction_item.dart';
import 'package:chenille_comptabilite/utils/date_util.dart';
import 'package:chenille_comptabilite/utils/number_util.dart';
import 'package:chenille_comptabilite/widgets/empty_view.dart';

/// 每日交易记录列表
class DailyTransactionsList extends StatelessWidget {
  final List<TransactionRecord> transactions;
  final DataProvider dataProvider;

  const DailyTransactionsList({
    super.key,
    required this.transactions,
    required this.dataProvider,
  });

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return const EmptyView(
        message: '还没有记账记录哦\n点击下方加号开始记账吧',
        icon: Icons.receipt_long_outlined,
      );
    }

    // 按日期分组
    final groupedTransactions = _groupTransactionsByDate(transactions);

    return ListView.builder(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + 80, // 底部导航栏高度
      ),
      itemCount: groupedTransactions.length,
      itemBuilder: (context, index) {
        final dateGroup = groupedTransactions[index];
        return _buildDateGroup(context, dateGroup);
      },
    );
  }

  /// 按日期分组交易记录
  List<_DateGroup> _groupTransactionsByDate(
      List<TransactionRecord> transactions) {
    final Map<String, List<TransactionRecord>> grouped = {};

    for (var transaction in transactions) {
      final dateKey = DateUtil.formatDate(transaction.date);
      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(transaction);
    }

    return grouped.entries.map((entry) {
      double dayIncome = 0;
      double dayExpense = 0;
      for (var t in entry.value) {
        if (t.type == AppConstants.typeIncome) {
          dayIncome += t.amount;
        } else {
          dayExpense += t.amount;
        }
      }

      return _DateGroup(
        date: entry.value.first.date,
        transactions: entry.value,
        dayIncome: dayIncome,
        dayExpense: dayExpense,
      );
    }).toList();
  }

  /// 构建日期分组
  Widget _buildDateGroup(BuildContext context, _DateGroup dateGroup) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateUtil.getRelativeDateDesc(dateGroup.date),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Text(
                '支出 ¥${NumberUtil.formatMoney(dateGroup.dayExpense)} | 收入 ¥${NumberUtil.formatMoney(dateGroup.dayIncome)}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        ...dateGroup.transactions.map(
          (transaction) => TransactionItem(
            transaction: transaction,
            dataProvider: dataProvider,
          ),
        ),
      ],
    );
  }
}

/// 日期分组数据类
class _DateGroup {
  final DateTime date;
  final List<TransactionRecord> transactions;
  final double dayIncome;
  final double dayExpense;

  _DateGroup({
    required this.date,
    required this.transactions,
    required this.dayIncome,
    required this.dayExpense,
  });
}
