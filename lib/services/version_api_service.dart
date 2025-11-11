import 'package:chenille_comptabilite/utils/http/http.dart';
import 'package:chenille_comptabilite/models/version_info.dart';

/// 版本API服务
class VersionApiService {
  final HttpClient _client = HttpClient();

  /// 检查更新
  /// 返回最新版本信息
  Future<HttpResponse<VersionInfo>> checkUpdate() async {
    try {
      // 初始化配置（如果还没初始化）
      _initHttpClient();

      final response = await _client.get<VersionInfo>(
        '',
        parser: (data) => VersionInfo.fromJson(data),
      );

      return response;
    } catch (e) {
      // 如果请求失败，返回失败响应
      return HttpResponse.failure(
        message: '检查更新失败：$e',
      );
    }
  }

  /// 初始化HTTP客户端
  void _initHttpClient() {
    try {
      _client.init(HttpConfig(
        baseUrl: 'https://chenille.chenjiabao.cn',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        enableLog: false, // 版本检查不需要日志
      ));
    } catch (e) {
      // 如果已经初始化过，会抛出异常，忽略即可
    }
  }
}

