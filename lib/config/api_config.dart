/// API配置文件
/// 所有的API地址和配置都在这里集中管理
class ApiConfig {
  /// ==================== 基础配置 ====================

  /// API基础地址（如果有统一的后端API）
  static const String baseUrl = 'https://chenille.chenjiabao.cn';

  /// 连接超时时间（秒）
  static const int connectTimeout = 10;

  /// 接收超时时间（秒）
  static const int receiveTimeout = 10;

  /// 是否启用日志（生产环境建议关闭）
  static const bool enableLog = true;

  /// ==================== 版本更新相关 ====================

  /// 版本检查API地址
  static const String versionCheckUrl = '/';

  /// 版本检查超时时间（秒）
  static const int versionCheckTimeout = 15;

  /// ==================== 其他API地址 ====================

  // 示例：用户相关API
  // static const String loginUrl = '/api/user/login';
  // static const String registerUrl = '/api/user/register';

  // 示例：数据相关API
  // static const String dataListUrl = '/api/data/list';
  // static const String dataDetailUrl = '/api/data/detail';
}
