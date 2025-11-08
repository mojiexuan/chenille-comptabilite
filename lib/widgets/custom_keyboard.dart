import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chenille_comptabilite/config/theme.dart';

/// 自定义数字键盘
class CustomKeyboard extends StatelessWidget {
  final ValueChanged<String> onKeyTap;
  final VoidCallback onDelete;
  final VoidCallback onConfirm;

  const CustomKeyboard({
    super.key,
    required this.onKeyTap,
    required this.onDelete,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 第一行：1 2 3
              _buildKeyRow(['1', '2', '3']),
              const SizedBox(height: 8),
              // 第二行：4 5 6
              _buildKeyRow(['4', '5', '6']),
              const SizedBox(height: 8),
              // 第三行：7 8 9
              _buildKeyRow(['7', '8', '9']),
              const SizedBox(height: 8),
              // 第四行：. 0 删除
              Row(
                children: [
                  Expanded(child: _buildKey('.')),
                  const SizedBox(width: 8),
                  Expanded(child: _buildKey('0')),
                  const SizedBox(width: 8),
                  Expanded(child: _buildDeleteKey()),
                ],
              ),
              const SizedBox(height: 8),
              // 确定按钮
              _buildConfirmButton(),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建键盘行
  Widget _buildKeyRow(List<String> keys) {
    return Row(
      children: keys.map((key) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: _buildKey(key),
          ),
        );
      }).toList(),
    );
  }

  /// 构建按键
  Widget _buildKey(String key) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact(); // 轻微震动反馈
          onKeyTap(key);
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 56,
          alignment: Alignment.center,
          child: Text(
            key,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: AppTheme.textPrimary,
            ),
          ),
        ),
      ),
    );
  }

  /// 构建删除按键
  Widget _buildDeleteKey() {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact(); // 轻微震动反馈
          onDelete();
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 56,
          alignment: Alignment.center,
          child: const Icon(
            Icons.backspace_outlined,
            size: 24,
            color: AppTheme.textSecondary,
          ),
        ),
      ),
    );
  }

  /// 构建确定按钮
  Widget _buildConfirmButton() {
    return Material(
      color: AppTheme.primaryColor,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () {
          HapticFeedback.mediumImpact(); // 中等震动反馈（确定按钮）
          onConfirm();
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 56,
          alignment: Alignment.center,
          child: const Text(
            '确定',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
