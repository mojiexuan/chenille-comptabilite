import 'package:flutter/material.dart';
import 'package:chenille_comptabilite/config/theme.dart';
import 'package:chenille_comptabilite/models/backup_file.dart';

/// 备份文件项组件
class BackupFileItem extends StatelessWidget {
  final BackupFile backupFile;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const BackupFileItem({
    super.key,
    required this.backupFile,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          children: [
            // 文件图标
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.insert_drive_file,
                size: 20,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(width: 12),

            // 文件信息
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    backupFile.displayName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        backupFile.formattedTime,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '•',
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        backupFile.formattedSize,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 删除按钮
            IconButton(
              icon: Icon(
                Icons.delete_outline,
                color: Colors.red[400],
                size: 20,
              ),
              onPressed: onDelete,
              padding: const EdgeInsets.all(8),
              constraints: const BoxConstraints(),
              tooltip: '删除',
            ),
          ],
        ),
      ),
    );
  }
}
