import 'package:flutter/material.dart';

/// 空数据视图组件
class EmptyView extends StatelessWidget {
  final String message;
  final IconData? icon;
  final VoidCallback? onRefresh;

  const EmptyView({
    super.key,
    this.message = '暂无数据',
    this.icon,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon ?? Icons.inbox_outlined,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          if (onRefresh != null) ...[
            const SizedBox(height: 16),
            TextButton(
              onPressed: onRefresh,
              child: const Text('刷新'),
            ),
          ],
        ],
      ),
    );
  }
}

