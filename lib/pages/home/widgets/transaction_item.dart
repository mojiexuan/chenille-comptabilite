import 'package:flutter/material.dart';
import 'package:chenille_comptabilite/config/constants.dart';
import 'package:chenille_comptabilite/config/theme.dart';
import 'package:chenille_comptabilite/models/transaction.dart';
import 'package:chenille_comptabilite/providers/data_provider.dart';
import 'package:chenille_comptabilite/utils/number_util.dart';
import 'package:chenille_comptabilite/widgets/common_dialog.dart';
import 'package:chenille_comptabilite/widgets/toast.dart';

/// 交易记录项
class TransactionItem extends StatelessWidget {
  final TransactionRecord transaction;
  final DataProvider dataProvider;

  const TransactionItem({
    super.key,
    required this.transaction,
    required this.dataProvider,
  });

  @override
  Widget build(BuildContext context) {
    final category = dataProvider.getCategoryById(transaction.categoryId);
    final isIncome = transaction.type == AppConstants.typeIncome;

    return Dismissible(
      key: Key(transaction.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) => _confirmDelete(context),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.all(12),
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
          children: [
            // 图标
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isIncome
                    ? AppTheme.incomeColor.withOpacity(0.1)
                    : AppTheme.expenseColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                IconData(category?.iconCode ?? 0xe88a, fontFamily: 'MaterialIcons'),
                color: isIncome ? AppTheme.incomeColor : AppTheme.expenseColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            // 分类和备注
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category?.name ?? '未知分类',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  if (transaction.note.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      transaction.note,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            // 金额
            Text(
              '${isIncome ? '+' : '-'}¥${NumberUtil.formatMoney(transaction.amount)}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isIncome ? AppTheme.incomeColor : AppTheme.expenseColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 确认删除
  Future<bool?> _confirmDelete(BuildContext context) async {
    final result = await CommonDialog.showConfirm(
      context,
      title: '删除记录',
      content: '确定要删除这条记录吗？',
    );

    if (result == true) {
      await dataProvider.deleteTransaction(transaction.id);
      if (context.mounted) {
        Toast.success(context, '删除成功');
      }
      return true;
    }
    return false;
  }
}

