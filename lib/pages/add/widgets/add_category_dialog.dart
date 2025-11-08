import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chenille_comptabilite/config/constants.dart';
import 'package:chenille_comptabilite/config/theme.dart';
import 'package:chenille_comptabilite/providers/data_provider.dart';
import 'package:chenille_comptabilite/widgets/toast.dart';

/// 添加自定义分类对话框
class AddCategoryDialog extends StatefulWidget {
  final String type;

  const AddCategoryDialog({
    super.key,
    required this.type,
  });

  @override
  State<AddCategoryDialog> createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  final TextEditingController _nameController = TextEditingController();
  int _selectedIconCode = 0xe88a; // 默认图标

  // 常用图标列表
  final List<int> _iconCodes = [
    0xe88a,
    0xe533,
    0xe530,
    0xe59c,
    0xe30a,
    0xe3bf,
    0xe318,
    0xe5c3,
    0xe0b0,
    0xe556,
    0xe4dc,
    0xe53d,
    0xe91d,
    0xe227,
    0xe8d3,
    0xe8f9,
    0xe926,
    0xe8f6,
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('添加分类'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              maxLength: AppConstants.maxCategoryNameLength,
              decoration: InputDecoration(
                labelText: '分类名称',
                hintText: '请输入分类名称',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '选择图标',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _iconCodes.map((iconCode) {
                return _buildIconButton(iconCode);
              }).toList(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
        TextButton(
          onPressed: _saveCategory,
          child: const Text('保存'),
        ),
      ],
    );
  }

  /// 构建图标按钮
  Widget _buildIconButton(int iconCode) {
    final isSelected = _selectedIconCode == iconCode;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIconCode = iconCode;
        });
      },
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          IconData(iconCode, fontFamily: 'MaterialIcons'),
          color: isSelected ? Colors.white : Colors.grey[700],
          size: 24,
        ),
      ),
    );
  }

  /// 保存分类
  Future<void> _saveCategory() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      Toast.warning(context, '请输入分类名称');
      return;
    }

    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    await dataProvider.addCategory(name, widget.type, _selectedIconCode);

    if (mounted) {
      Toast.success(context, '添加成功');
      Navigator.of(context).pop();
    }
  }
}
