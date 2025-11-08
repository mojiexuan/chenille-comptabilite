import 'package:flutter/material.dart';
import 'package:chenille_comptabilite/config/constants.dart';

/// 交易类型切换组件（支出/收入）
class TypeToggle extends StatelessWidget {
  final String selectedType;
  final ValueChanged<String> onTypeChanged;

  const TypeToggle({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTypeButton(
              '支出',
              AppConstants.typeExpense,
              Colors.red,
            ),
          ),
          Expanded(
            child: _buildTypeButton(
              '收入',
              AppConstants.typeIncome,
              Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建类型按钮
  Widget _buildTypeButton(String label, String type, Color activeColor) {
    final isSelected = selectedType == type;
    return GestureDetector(
      onTap: () => onTypeChanged(type),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? activeColor : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected ? Colors.white : Colors.grey[700],
          ),
        ),
      ),
    );
  }
}
