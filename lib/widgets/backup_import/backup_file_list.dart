import 'dart:io';
import 'package:flutter/material.dart';
import 'package:chenille_comptabilite/config/theme.dart';
import 'package:chenille_comptabilite/models/backup_file.dart';
import 'package:chenille_comptabilite/widgets/backup_import/backup_file_item.dart';

/// 备份文件列表组件
class BackupFileList extends StatelessWidget {
  final List<BackupFile> backupFiles;
  final Function(File) onFileSelected;
  final Function(BackupFile) onFileDelete;

  const BackupFileList({
    super.key,
    required this.backupFiles,
    required this.onFileSelected,
    required this.onFileDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 说明文本
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 16,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '显示应用导出的备份 • 点击底部按钮可导入其他文件',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // 文件列表
        Expanded(
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: backupFiles.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final backupFile = backupFiles[index];
              return BackupFileItem(
                backupFile: backupFile,
                onTap: () => onFileSelected(backupFile.file),
                onDelete: () => onFileDelete(backupFile),
              );
            },
          ),
        ),
      ],
    );
  }
}
