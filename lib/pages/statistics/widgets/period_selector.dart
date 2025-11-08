import 'package:flutter/material.dart';
import 'package:chenille_comptabilite/config/constants.dart';
import 'package:chenille_comptabilite/config/theme.dart';

/// 周期选择器
class PeriodSelector extends StatelessWidget {
  final String selectedPeriod;
  final ValueChanged<String> onPeriodChanged;

  const PeriodSelector({
    super.key,
    required this.selectedPeriod,
    required this.onPeriodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildPeriodButton('周', AppConstants.periodWeek),
          _buildPeriodButton('月', AppConstants.periodMonth),
          _buildPeriodButton('年', AppConstants.periodYear),
        ],
      ),
    );
  }

  /// 构建周期按钮
  Widget _buildPeriodButton(String label, String period) {
    final isSelected = selectedPeriod == period;
    return Expanded(
      child: GestureDetector(
        onTap: () => onPeriodChanged(period),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected ? AppTheme.primaryColor : Colors.grey[700],
            ),
          ),
        ),
      ),
    );
  }
}

