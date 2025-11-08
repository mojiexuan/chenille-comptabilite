import 'package:flutter/material.dart';

/// 交易页面顶部栏组件
class TransactionHeader extends StatelessWidget {
  final VoidCallback onClose;

  const TransactionHeader({
    super.key,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: onClose,
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
}
