import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chenille_comptabilite/config/constants.dart';
import 'package:chenille_comptabilite/config/theme.dart';
import 'package:chenille_comptabilite/providers/data_provider.dart';
import 'package:chenille_comptabilite/pages/add/widgets/type_toggle.dart';
import 'package:chenille_comptabilite/pages/add/widgets/category_selector.dart';
import 'package:chenille_comptabilite/pages/add/widgets/amount_note_row.dart';
import 'package:chenille_comptabilite/widgets/custom_keyboard.dart';
import 'package:chenille_comptabilite/widgets/toast.dart';
import 'package:chenille_comptabilite/utils/number_util.dart';
import 'package:chenille_comptabilite/utils/date_util.dart';

/// 添加交易记录页面（重构版）
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
  bool _showCalendar = false; // 控制日历显示

  /// 金额上限（1千万）
  static const double _maxAmount = 10000000.0;

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
              _buildCustomHeader(),
              // 日期显示栏（点击展开日历）
              _buildDateBar(),
              const SizedBox(height: 12),
              // 可滚动内容区域
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(top: 8, bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 分类选择
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: CategorySelector(
                          transactionType: _transactionType,
                          selectedCategoryId: _selectedCategoryId,
                          onCategorySelected: (categoryId) {
                            setState(() {
                              _selectedCategoryId = categoryId;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 16), // 适当留白即可
                    ],
                  ),
                ),
              ),
              // 类型切换（放在底部）
              TypeToggle(
                selectedType: _transactionType,
                onTypeChanged: (type) {
                  setState(() {
                    _transactionType = type;
                    _setDefaultCategory();
                  });
                },
              ),
              // 金额和备注行（在键盘上方）
              AmountNoteRow(
                amount: _amount,
                note: _note,
                onNoteChanged: (value) {
                  setState(() {
                    _note = value;
                  });
                },
              ),
              // 自定义数字键盘（固定在底部）
              CustomKeyboard(
                onKeyTap: _handleKeyTap,
                onDelete: _handleDelete,
                onConfirm: _submitTransaction,
              ),
            ],
          ),
          // 浮动日历（在Stack顶层）
          if (_showCalendar)
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _showCalendar = false;
                  });
                },
                child: Container(
                  color: Colors.black54,
                  child: Center(
                    child: GestureDetector(
                      onTap: () {}, // 阻止冒泡
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // 日历标题
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  '选择日期',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    setState(() {
                                      _showCalendar = false;
                                    });
                                  },
                                ),
                              ],
                            ),
                            // 日历选择器
                            SizedBox(
                              height: 320,
                              child: Theme(
                                data: ThemeData(
                                  // 修复日历选中日期文字颜色问题
                                  // 使用深色主题色，确保白色文字在深色背景上清晰可见
                                  primaryColor: AppTheme.primaryColor,
                                  colorScheme: const ColorScheme.light(
                                    primary:
                                        AppTheme.primaryColor, // 选中日期的圆形背景（橙色）
                                    onPrimary: AppTheme
                                        .textPrimary, // 选中日期的文字（深色，在橙色背景上可见）
                                    onSurface:
                                        AppTheme.textPrimary, // 未选中日期的文字颜色
                                    surface: Colors.white, // 日历背景色
                                  ),
                                  // 强制设置文字样式为深色，确保在橙色背景上可见
                                  textTheme: const TextTheme(
                                    titleMedium: TextStyle(
                                      color: AppTheme.textPrimary, // 深色文字
                                      fontWeight: FontWeight.w600,
                                    ),
                                    bodyLarge:
                                        TextStyle(color: AppTheme.textPrimary),
                                    bodyMedium:
                                        TextStyle(color: AppTheme.textPrimary),
                                    labelLarge: TextStyle(
                                      color: AppTheme.textPrimary, // 选中日期的深色文字
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  // 使用 Material 2 设计
                                  useMaterial3: false,
                                ),
                                child: CalendarDatePicker(
                                  initialDate: _selectedDate,
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime.now(),
                                  onDateChanged: (date) {
                                    setState(() {
                                      _selectedDate = date;
                                      _showCalendar = false;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// 构建自定义顶部栏
  Widget _buildCustomHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const Expanded(
            child: Text(
              '记一笔',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 48), // 平衡布局
        ],
      ),
    );
  }

  /// 构建日期显示栏
  Widget _buildDateBar() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showCalendar = true;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today,
              size: 18,
              color: AppTheme.primaryColor,
            ),
            const SizedBox(width: 12),
            Text(
              DateUtil.formatFull(_selectedDate),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppTheme.textPrimary,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_drop_down,
              color: AppTheme.primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  /// 设置默认分类（选择第一个）
  void _setDefaultCategory() {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    final categories = dataProvider.getCategoriesByType(_transactionType);
    if (categories.isNotEmpty) {
      setState(() {
        _selectedCategoryId = categories.first.id;
      });
    }
  }

  /// 处理键盘输入
  void _handleKeyTap(String key) {
    setState(() {
      if (key == '.') {
        if (_amount.contains('.')) return;
        if (_amount.isEmpty) {
          _amount = '0.';
        } else {
          _amount += '.';
        }
      } else {
        String newAmount;
        if (_amount == '0') {
          newAmount = key;
        } else {
          newAmount = _amount + key;
        }

        final parsedAmount = NumberUtil.parseMoney(newAmount);
        if (parsedAmount != null && parsedAmount > _maxAmount) {
          Toast.warning(context, '单笔金额不能超过1千万');
          return;
        }

        if (newAmount.contains('.')) {
          final parts = newAmount.split('.');
          if (parts[1].length > 2) return;
        }

        _amount = newAmount;
      }
    });
  }

  /// 处理删除
  void _handleDelete() {
    setState(() {
      if (_amount.isNotEmpty) {
        _amount = _amount.substring(0, _amount.length - 1);
      }
    });
  }

  /// 提交交易记录
  Future<void> _submitTransaction() async {
    if (_amount.isEmpty) {
      Toast.warning(context, '请输入金额');
      return;
    }

    final amountValue = NumberUtil.parseMoney(_amount);
    if (amountValue == null || amountValue <= 0) {
      Toast.error(context, '请输入有效的金额');
      return;
    }

    if (amountValue > _maxAmount) {
      Toast.error(context, '单笔金额不能超过1千万');
      return;
    }

    if (_selectedCategoryId == null) {
      Toast.warning(context, '请选择分类');
      return;
    }

    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    await dataProvider.addTransaction(
      amount: amountValue,
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
