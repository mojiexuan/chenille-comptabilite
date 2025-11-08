import 'dart:io';

/// 文件操作工具类
class FileUtil {
  /// 检查目录是否存在
  static Future<bool> directoryExists(String path) async {
    final directory = Directory(path);
    return await directory.exists();
  }

  /// 创建目录（如果不存在）
  static Future<Directory> createDirectory(String path) async {
    final directory = Directory(path);
    if (!await directory.exists()) {
      return await directory.create(recursive: true);
    }
    return directory;
  }

  /// 获取目录下的所有文件
  static Future<List<File>> getFilesInDirectory(
    String directoryPath, {
    String? extension,
  }) async {
    final directory = Directory(directoryPath);
    if (!await directory.exists()) {
      return [];
    }

    final List<File> files = [];
    await for (final entity in directory.list()) {
      if (entity is File) {
        if (extension == null ||
            entity.path.toLowerCase().endsWith(extension.toLowerCase())) {
          files.add(entity);
        }
      }
    }

    return files;
  }

  /// 读取文件内容
  static Future<String> readFileAsString(File file) async {
    return await file.readAsString();
  }

  /// 写入文件内容
  static Future<File> writeFileAsString(File file, String content) async {
    return await file.writeAsString(content);
  }

  /// 获取文件大小（字节）
  static Future<int> getFileSize(File file) async {
    return await file.length();
  }

  /// 获取文件修改时间
  static Future<DateTime> getFileModifiedTime(File file) async {
    final stat = await file.stat();
    return stat.modified;
  }

  /// 删除文件
  static Future<void> deleteFile(File file) async {
    if (await file.exists()) {
      await file.delete();
    }
  }

  /// 生成带时间戳的文件名
  static String generateBackupFileName() {
    final now = DateTime.now();
    final timestamp =
        '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}_'
        '${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}';
    return 'backup_$timestamp.json';
  }
}
