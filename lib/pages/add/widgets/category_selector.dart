import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chenille_comptabilite/config/theme.dart';
import 'package:chenille_comptabilite/models/category.dart';
import 'package:chenille_comptabilite/providers/data_provider.dart';
import 'package:chenille_comptabilite/pages/add/widgets/add_category_dialog.dart';

/// 分类选择器
class CategorySelector extends StatelessWidget {
  final String transactionType;
  final String? selectedCategoryId;
  final ValueChanged<String> onCategorySelected;

  const CategorySelector({
    super.key,
    required this.transactionType,
    required this.selectedCategoryId,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '分类',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppTheme.textSecondary,
              ),
            ),
            TextButton.icon(
              onPressed: () => _showAddCategoryDialog(context),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('添加', style: TextStyle(fontSize: 13)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Consumer<DataProvider>(
          builder: (context, dataProvider, child) {
            final categories = dataProvider.getCategoriesByType(transactionType);
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: categories.map((category) {
                return _buildCategoryChip(category);
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  /// 构建分类芯片
  Widget _buildCategoryChip(Category category) {
    final isSelected = selectedCategoryId == category.id;
    return GestureDetector(
      onTap: () => onCategorySelected(category.id),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryColor
              : AppTheme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              IconData(category.iconCode, fontFamily: 'MaterialIcons'),
              size: 18,
              color: isSelected ? Colors.white : AppTheme.primaryColor,
            ),
            const SizedBox(width: 6),
            Text(
              category.name,
              style: TextStyle(
                fontSize: 14,
                color: isSelected ? Colors.white : AppTheme.textPrimary,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 显示添加分类对话框
  Future<void> _showAddCategoryDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => AddCategoryDialog(type: transactionType),
    );
  }
}

