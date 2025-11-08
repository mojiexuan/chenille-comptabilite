import 'dart:io';

/// 备份文件模型
class BackupFile {
  /// 文件对象
  final File file;

  /// 文件修改时间
  final DateTime modifiedTime;

  /// 文件大小（字节）
  final int sizeInBytes;

  BackupFile({
    required this.file,
    required this.modifiedTime,
    required this.sizeInBytes,
  });

  /// 获取显示名称（从文件名中提取）
  String get displayName => file.path.split('/').last;

  /// 获取格式化的文件大小
  String get formattedSize {
    if (sizeInBytes < 1024) {
      return '$sizeInBytes B';
    } else if (sizeInBytes < 1024 * 1024) {
      return '${(sizeInBytes / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(sizeInBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
  }

  /// 获取格式化的修改时间（友好显示）
  String get formattedTime {
    final now = DateTime.now();
    final difference = now.difference(modifiedTime);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return '刚刚';
        }
        return '${difference.inMinutes}分钟前';
      }
      return '${difference.inHours}小时前';
    } else if (difference.inDays == 1) {
      return '昨天';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}天前';
    } else {
      return '${modifiedTime.year}-${modifiedTime.month.toString().padLeft(2, '0')}-${modifiedTime.day.toString().padLeft(2, '0')}';
    }
  }

  /// 获取详细的时间信息
  String get detailedTime {
    return '${modifiedTime.year}-${modifiedTime.month.toString().padLeft(2, '0')}-${modifiedTime.day.toString().padLeft(2, '0')} '
        '${modifiedTime.hour.toString().padLeft(2, '0')}:${modifiedTime.minute.toString().padLeft(2, '0')}';
  }
}
