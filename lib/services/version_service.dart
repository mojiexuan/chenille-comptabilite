import 'package:flutter/foundation.dart';
import 'package:chenille_comptabilite/models/version_info.dart';
import 'package:chenille_comptabilite/services/storage_service.dart';
import 'package:chenille_comptabilite/services/version_api_service.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// 版本管理服务
class VersionService {
  static final VersionService _instance = VersionService._internal();
  factory VersionService() => _instance;
  VersionService._internal();

  final VersionApiService _apiService = VersionApiService();

  /// 存储键
  static const String _keyLastCheckDate = 'last_check_update_date';
  static const String _keyLatestVersion = 'latest_version_info';
  static const String _keyHasNewVersion = 'has_new_version';

  /// 当前应用版本信息
  String? _currentVersion;
  int? _currentVersionCode;

  /// 最新版本信息
  VersionInfo? _latestVersionInfo;

  /// 是否有新版本
  bool _hasNewVersion = false;

  /// 获取是否有新版本
  bool get hasNewVersion => _hasNewVersion;

  /// 获取最新版本信息
  VersionInfo? get latestVersionInfo => _latestVersionInfo;

  /// 获取当前版本号
  String get currentVersion => _currentVersion ?? '1.0.0';

  /// 获取当前版本代码
  int get currentVersionCode => _currentVersionCode ?? 1;

  /// 初始化
  Future<void> init() async {
    // 获取当前应用版本信息
    final packageInfo = await PackageInfo.fromPlatform();
    _currentVersion = packageInfo.version;
    _currentVersionCode = int.tryParse(packageInfo.buildNumber) ?? 1;

    // 加载缓存的版本信息
    await _loadCachedVersionInfo();

    debugPrint('[VersionService] 当前版本：$_currentVersion ($currentVersionCode)');
  }

  /// 加载缓存的版本信息
  Future<void> _loadCachedVersionInfo() async {
    final hasNew = StorageService.getBool(_keyHasNewVersion) ?? false;
    final versionJson = StorageService.getJson(_keyLatestVersion);

    if (versionJson != null) {
      try {
        _latestVersionInfo = VersionInfo.fromJson(versionJson);
        _hasNewVersion = hasNew;
        debugPrint('[VersionService] 加载缓存版本信息：$_latestVersionInfo');
      } catch (e) {
        debugPrint('[VersionService] 解析缓存版本信息失败：$e');
      }
    }
  }

  /// 检查是否需要自动检测更新（每天只检测一次）
  bool shouldAutoCheck() {
    final lastCheckDate = StorageService.getString(_keyLastCheckDate);
    if (lastCheckDate == null) return true;

    final lastCheck = DateTime.tryParse(lastCheckDate);
    if (lastCheck == null) return true;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lastCheckDay =
        DateTime(lastCheck.year, lastCheck.month, lastCheck.day);

    // 如果不是同一天，则需要检测
    return !today.isAtSameMomentAs(lastCheckDay);
  }

  /// 检查更新
  /// [manual] 是否为手动检查（手动检查会忽略每日限制）
  Future<bool> checkUpdate({bool manual = false}) async {
    // 如果是自动检查，判断是否需要检测
    if (!manual && !shouldAutoCheck()) {
      debugPrint('[VersionService] 今天已检查过，跳过自动检测');
      return _hasNewVersion;
    }

    try {
      debugPrint('[VersionService] 开始检查更新...');

      final response = await _apiService.checkUpdate();

      if (response.success && response.data != null) {
        _latestVersionInfo = response.data;

        // 比较版本
        _hasNewVersion = _latestVersionInfo!.isNewerThan(currentVersionCode);

        // 保存检查时间
        await StorageService.setString(
          _keyLastCheckDate,
          DateTime.now().toIso8601String(),
        );

        // 保存最新版本信息
        await StorageService.setJson(
          _keyLatestVersion,
          _latestVersionInfo!.toJson(),
        );

        // 保存是否有新版本
        await StorageService.setBool(_keyHasNewVersion, _hasNewVersion);

        if (_hasNewVersion) {
          debugPrint('[VersionService] 发现新版本：${_latestVersionInfo!.name}');
        } else {
          debugPrint('[VersionService] 已是最新版本');
        }

        return _hasNewVersion;
      } else {
        debugPrint('[VersionService] 检查更新失败：${response.message}');
        return false;
      }
    } catch (e) {
      debugPrint('[VersionService] 检查更新异常：$e');
      return false;
    }
  }

  /// 清除新版本标记（用户查看更新详情后可调用）
  Future<void> clearNewVersionFlag() async {
    _hasNewVersion = false;
    await StorageService.setBool(_keyHasNewVersion, false);
  }

  /// 重置检查时间（用于测试）
  Future<void> resetCheckTime() async {
    await StorageService.remove(_keyLastCheckDate);
  }
}

