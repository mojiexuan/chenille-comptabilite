import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:chenille_comptabilite/config/theme.dart';
import 'package:chenille_comptabilite/models/backup_file.dart';
import 'package:chenille_comptabilite/services/backup_service.dart';
import 'package:chenille_comptabilite/widgets/toast.dart';
import 'package:chenille_comptabilite/widgets/backup_import/backup_file_list.dart';
import 'package:chenille_comptabilite/widgets/backup_import/backup_empty_view.dart';

/// 备份导入对话框
class BackupImportDialog extends StatefulWidget {
  const BackupImportDialog({super.key});

  @override
  State<BackupImportDialog> createState() => _BackupImportDialogState();
}

class _BackupImportDialogState extends State<BackupImportDialog> {
  List<BackupFile>? _backupFiles;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadBackupFiles();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        constraints: const BoxConstraints(
          maxHeight: 500,
          minWidth: 300,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题栏
            _buildHeader(),
            const SizedBox(height: 16),

            // 备份文件列表
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _backupFiles!.isEmpty
                      ? const BackupEmptyView()
                      : BackupFileList(
                          backupFiles: _backupFiles!,
                          onFileSelected: _selectFile,
                          onFileDelete: _deleteFile,
                        ),
            ),
            const SizedBox(height: 16),

            // 底部按钮
            _buildBottomButton(),
          ],
        ),
      ),
    );
  }

  /// 构建标题栏
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          '选择备份文件',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }

  /// 构建底部按钮
  Widget _buildBottomButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _selectOtherFile,
        icon: const Icon(Icons.file_open, size: 18),
        label: const Text('从文件管理器选择'),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          side: BorderSide(color: AppTheme.primaryColor),
          foregroundColor: AppTheme.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  /// 加载备份文件
  Future<void> _loadBackupFiles() async {
    final files = await BackupService.getBackupFiles();
    setState(() {
      _backupFiles = files;
      _loading = false;
    });
  }

  /// 选择文件
  void _selectFile(File file) {
    Navigator.of(context).pop(file);
  }

  /// 选择其他文件
  Future<void> _selectOtherFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        if (mounted) {
          Navigator.of(context).pop(file);
        }
      }
    } catch (e) {
      if (mounted) {
        Toast.error(context, '选择文件失败');
      }
    }
  }

  /// 删除备份文件
  Future<void> _deleteFile(BackupFile backupFile) async {
    // 显示确认对话框
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除备份文件 "${backupFile.displayName}" 吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('删除'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        final success = await BackupService.deleteBackupFile(backupFile.file);
        if (success) {
          if (mounted) {
            Toast.success(context, '已删除');
            // 重新加载文件列表
            setState(() {
              _loading = true;
            });
            _loadBackupFiles();
          }
        } else {
          if (mounted) {
            Toast.error(context, '删除失败');
          }
        }
      } catch (e) {
        if (mounted) {
          Toast.error(context, '删除失败：${e.toString()}');
        }
      }
    }
  }
}
