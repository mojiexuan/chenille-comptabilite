import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

/// 权限请求结果
enum PermissionResult {
  /// 已授权
  granted,

  /// 用户拒绝
  denied,

  /// 用户永久拒绝（需要去设置页面）
  permanentlyDenied,
}

/// 权限工具类
class PermissionUtil {
  /// 请求存储权限
  static Future<PermissionResult> requestStoragePermission() async {
    if (!Platform.isAndroid) {
      return PermissionResult.granted;
    }

    // 统一使用权限请求流程
    // Android 13+ 系统会自动适配存储权限，无需特殊处理
    final status = await Permission.storage.status;

    if (status.isGranted) {
      return PermissionResult.granted;
    }

    if (status.isPermanentlyDenied) {
      return PermissionResult.permanentlyDenied;
    }

    // 请求权限
    final result = await Permission.storage.request();

    if (result.isGranted) {
      return PermissionResult.granted;
    }

    if (result.isPermanentlyDenied) {
      return PermissionResult.permanentlyDenied;
    }

    return PermissionResult.denied;
  }

  /// 请求管理所有文件的权限（用于打开文件管理器等操作）
  /// Android 11+ 需要这个权限来访问所有文件
  static Future<PermissionResult> requestManageStoragePermission() async {
    if (!Platform.isAndroid) {
      return PermissionResult.granted;
    }

    // 检查当前权限状态
    final status = await Permission.manageExternalStorage.status;

    if (status.isGranted) {
      return PermissionResult.granted;
    }

    if (status.isPermanentlyDenied) {
      return PermissionResult.permanentlyDenied;
    }

    // 请求权限
    final result = await Permission.manageExternalStorage.request();

    if (result.isGranted) {
      return PermissionResult.granted;
    }

    if (result.isPermanentlyDenied) {
      return PermissionResult.permanentlyDenied;
    }

    return PermissionResult.denied;
  }

  /// 打开应用设置页面
  static Future<bool> openSettings() async {
    return await openAppSettings();
  }
}
