import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chenille_comptabilite/config/constants.dart';
import 'package:chenille_comptabilite/providers/data_provider.dart';
import 'package:chenille_comptabilite/pages/add/widgets/type_toggle.dart';
import 'package:chenille_comptabilite/pages/add/widgets/category_selector.dart';
import 'package:chenille_comptabilite/pages/add/widgets/amount_note_row.dart';
import 'package:chenille_comptabilite/pages/add/widgets/date_bar_selector.dart';
import 'package:chenille_comptabilite/pages/add/widgets/floating_calendar_dialog.dart';
import 'package:chenille_comptabilite/pages/add/widgets/transaction_header.dart';
import 'package:chenille_comptabilite/pages/add/handlers/transaction_input_handler.dart';
import 'package:chenille_comptabilite/widgets/custom_keyboard.dart';
import 'package:chenille_comptabilite/widgets/toast.dart';

/// 添加交易记录页面
class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  String _transactionType = AppConstants.typeExpense;
  String _amount = '';
  String? _selectedCategoryId;
  DateTime _selectedDate = DateTime.now();
  String _note = '';
  bool _showCalendar = false;

  @override
  void initState() {
    super.initState();
    // 初始化时设置默认分类为第一个
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setDefaultCategory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // 主内容区
          Column(
            children: [
              SizedBox(height: MediaQuery.of(context).padding.top),
              // 自定义顶部栏
              TransactionHeader(
                onClose: () => Navigator.of(context).pop(),
              ),
              // 日期显示栏
              DateBarSelector(
                selectedDate: _selectedDate,
                onTap: () => setState(() => _showCalendar = true),
              ),
              const SizedBox(height: 12),
              // 可滚动内容区域
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(top: 8, bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: CategorySelector(
                      transactionType: _transactionType,
                      selectedCategoryId: _selectedCategoryId,
                      onCategorySelected: (categoryId) {
                        setState(() => _selectedCategoryId = categoryId);
                      },
                    ),
                  ),
                ),
              ),
              // 类型切换
              TypeToggle(
                selectedType: _transactionType,
                onTypeChanged: (type) {
                  setState(() {
                    _transactionType = type;
                    _setDefaultCategory();
                  });
                },
              ),
              // 金额和备注行
              AmountNoteRow(
                amount: _amount,
                note: _note,
                onNoteChanged: (value) => setState(() => _note = value),
              ),
              // 自定义数字键盘
              CustomKeyboard(
                onKeyTap: _handleKeyTap,
                onDelete: _handleDelete,
                onConfirm: _submitTransaction,
              ),
            ],
          ),
          // 浮动日历
          if (_showCalendar)
            FloatingCalendarDialog(
              selectedDate: _selectedDate,
              onDateChanged: (date) {
                setState(() {
                  _selectedDate = date;
                  _showCalendar = false;
                });
              },
              onClose: () => setState(() => _showCalendar = false),
            ),
        ],
      ),
    );
  }

  /// 设置默认分类（选择第一个）
  void _setDefaultCategory() {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    final categories = dataProvider.getCategoriesByType(_transactionType);
    if (categories.isNotEmpty) {
      setState(() => _selectedCategoryId = categories.first.id);
    }
  }

  /// 处理键盘输入
  void _handleKeyTap(String key) {
    final newAmount = TransactionInputHandler.handleKeyInput(_amount, key);
    if (newAmount != null) {
      setState(() => _amount = newAmount);
    } else if (key != '.') {
      // 只有在超过上限时才显示提示（小数点重复不提示）
      Toast.warning(context, '单笔金额不能超过1千万');
    }
  }

  /// 处理删除
  void _handleDelete() {
    setState(() {
      _amount = TransactionInputHandler.handleDelete(_amount);
    });
  }

  /// 提交交易记录
  Future<void> _submitTransaction() async {
    // 验证金额
    final validation = TransactionInputHandler.validateAmount(_amount);
    if (!validation.isValid) {
      Toast.warning(context, validation.errorMessage!);
      return;
    }

    // 验证分类
    if (_selectedCategoryId == null) {
      Toast.warning(context, '请选择分类');
      return;
    }

    // 提交数据
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    await dataProvider.addTransaction(
      amount: double.parse(_amount),
      categoryId: _selectedCategoryId!,
      type: _transactionType,
      date: _selectedDate,
      note: _note,
    );

    if (mounted) {
      Toast.success(context, '记账成功');
      Navigator.of(context).pop();
    }
  }
}
