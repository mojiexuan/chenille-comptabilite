import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:chenille_comptabilite/config/theme.dart';
import 'package:chenille_comptabilite/models/backup_file.dart';
import 'package:chenille_comptabilite/services/backup_service.dart';
import 'package:chenille_comptabilite/widgets/toast.dart';

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
                  ? _buildLoadingView()
                  : _backupFiles!.isEmpty
                      ? _buildEmptyView()
                      : _buildFileList(),
            ),
            const SizedBox(height: 16),

            // 底部按钮
            _buildBottomButtons(),
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

  /// 构建加载视图
  Widget _buildLoadingView() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  /// 构建空视图
  Widget _buildEmptyView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.folder_open,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 12),
            Text(
              '暂无应用备份文件',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '只显示应用导出的备份文件\n如需导入其他JSON文件，请点击下方按钮',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建文件列表
  Widget _buildFileList() {
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
            itemCount: _backupFiles!.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final backupFile = _backupFiles![index];
              return _buildFileItem(backupFile);
            },
          ),
        ),
      ],
    );
  }

  /// 构建文件项
  Widget _buildFileItem(BackupFile backupFile) {
    return InkWell(
      onTap: () => _selectFile(backupFile.file),
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
              onPressed: () => _deleteFile(backupFile),
              padding: const EdgeInsets.all(8),
              constraints: const BoxConstraints(),
              tooltip: '删除',
            ),
          ],
        ),
      ),
    );
  }

  /// 构建底部按钮
  Widget _buildBottomButtons() {
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
