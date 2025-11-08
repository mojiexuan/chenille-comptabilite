import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:chenille_comptabilite/models/backup_file.dart';
import 'package:chenille_comptabilite/utils/file_util.dart';
import 'package:chenille_comptabilite/utils/permission_util.dart';

/// 导出结果
class ExportResult {
  final bool success;
  final File? file;
  final String? error;
  final bool needsPermission;
  final bool permanentlyDenied;

  ExportResult({
    required this.success,
    this.file,
    this.error,
    this.needsPermission = false,
    this.permanentlyDenied = false,
  });
}

/// 备份服务
class BackupService {
  /// Chenille 目录名称
  static const String _chenilleDirName = 'Chenille';

  /// 备份目录名称
  static const String _backupDirName = 'backup';

  /// 获取 Chenille 目录路径（位于 Documents 目录下）
  static Future<String> getChenilleDirectoryPath() async {
    if (Platform.isAndroid) {
      // Android 10+ 使用 Documents 目录（用户可访问）
      // 路径: /storage/emulated/0/Documents/Chenille
      final directory = await getExternalStorageDirectory();
      if (directory != null) {
        // 从应用私有目录回溯到外部存储根目录
        // /storage/emulated/0/Android/data/xxx -> /storage/emulated/0
        final pathParts = directory.path.split('/');
        final rootPath =
            pathParts.sublist(0, 4).join('/'); // /storage/emulated/0
        return '$rootPath/Documents/$_chenilleDirName';
      }
    }
    // 其他平台或失败时，使用应用文档目录
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/$_chenilleDirName';
  }

  /// 获取 backup 目录路径
  static Future<String> getBackupDirectoryPath() async {
    final chenillePath = await getChenilleDirectoryPath();
    return '$chenillePath/$_backupDirName';
  }

  /// 请求存储权限（已废弃，使用 PermissionUtil）
  @Deprecated('Use PermissionUtil.requestStoragePermission instead')
  static Future<bool> requestStoragePermission() async {
    final result = await PermissionUtil.requestStoragePermission();
    return result == PermissionResult.granted;
  }

  /// 确保备份目录存在
  static Future<bool> ensureBackupDirectoryExists() async {
    try {
      final backupPath = await getBackupDirectoryPath();
      print('尝试创建目录: $backupPath'); // 调试信息

      // 先确保 Documents 目录存在
      if (Platform.isAndroid) {
        final directory = await getExternalStorageDirectory();
        if (directory != null) {
          final pathParts = directory.path.split('/');
          final rootPath = pathParts.sublist(0, 4).join('/');
          final documentsPath = '$rootPath/Documents';
          final documentsDir = Directory(documentsPath);

          if (!await documentsDir.exists()) {
            await documentsDir.create(recursive: true);
            print('Documents 目录已创建: $documentsPath');
          }
        }
      }

      // 创建备份目录
      final directory = Directory(backupPath);
      if (!await directory.exists()) {
        await directory.create(recursive: true);
        print('目录创建成功: $backupPath');
      } else {
        print('目录已存在: $backupPath');
      }

      return true;
    } catch (e) {
      // 打印错误信息用于调试
      print('创建备份目录失败: $e');
      print('错误类型: ${e.runtimeType}');
      return false;
    }
  }

  /// 导出数据到文件
  /// 返回导出结果
  static Future<ExportResult> exportToFile(Map<String, dynamic> data) async {
    try {
      // 请求权限
      final permissionResult = await PermissionUtil.requestStoragePermission();

      if (permissionResult == PermissionResult.permanentlyDenied) {
        return ExportResult(
          success: false,
          error: '存储权限被永久拒绝',
          needsPermission: true,
          permanentlyDenied: true,
        );
      }

      if (permissionResult == PermissionResult.denied) {
        return ExportResult(
          success: false,
          error: '需要存储权限才能导出数据',
          needsPermission: true,
        );
      }

      // 确保目录存在
      final dirCreated = await ensureBackupDirectoryExists();
      if (!dirCreated) {
        return ExportResult(success: false, error: '无法创建备份目录');
      }

      // 生成文件名和路径
      final fileName = FileUtil.generateBackupFileName();
      final backupPath = await getBackupDirectoryPath();
      final file = File('$backupPath/$fileName');

      // 格式化 JSON 并写入文件
      final jsonString = const JsonEncoder.withIndent('  ').convert(data);
      await FileUtil.writeFileAsString(file, jsonString);

      return ExportResult(success: true, file: file);
    } catch (e) {
      return ExportResult(success: false, error: '导出失败：${e.toString()}');
    }
  }

  /// 获取所有备份文件（按修改时间降序排列）
  static Future<List<BackupFile>> getBackupFiles() async {
    try {
      final backupPath = await getBackupDirectoryPath();
      final files = await FileUtil.getFilesInDirectory(
        backupPath,
        extension: '.json',
      );

      // 创建 BackupFile 列表
      final List<BackupFile> backupFiles = [];
      for (final file in files) {
        final modifiedTime = await FileUtil.getFileModifiedTime(file);
        final size = await FileUtil.getFileSize(file);
        backupFiles.add(
          BackupFile(file: file, modifiedTime: modifiedTime, sizeInBytes: size),
        );
      }

      // 按修改时间降序排序
      backupFiles.sort((a, b) => b.modifiedTime.compareTo(a.modifiedTime));

      return backupFiles;
    } catch (e) {
      return [];
    }
  }

  /// 从文件导入数据
  static Future<Map<String, dynamic>?> importFromFile(File file) async {
    try {
      final jsonString = await FileUtil.readFileAsString(file);
      final data = json.decode(jsonString) as Map<String, dynamic>;
      return data;
    } catch (e) {
      return null;
    }
  }

  /// 删除备份文件
  static Future<bool> deleteBackupFile(File file) async {
    try {
      await FileUtil.deleteFile(file);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// 获取 Chenille 目录的完整路径（用于显示）
  static Future<String> getChenilleDirectoryForDisplay() async {
    final path = await getChenilleDirectoryPath();
    // 简化显示路径
    if (path.contains('/storage/emulated/0/')) {
      return path.replaceFirst('/storage/emulated/0/', '内部存储/');
    }
    return path;
  }

  /// 获取实际路径用于调试
  static Future<String> getActualPath() async {
    return await getChenilleDirectoryPath();
  }
}
