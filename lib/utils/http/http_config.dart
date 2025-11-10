/// HTTP请求配置类
class HttpConfig {
  /// 基础URL
  final String baseUrl;

  /// 连接超时时间（毫秒）
  final Duration connectTimeout;

  /// 接收超时时间（毫秒）
  final Duration receiveTimeout;

  /// 发送超时时间（毫秒）
  final Duration sendTimeout;

  /// 请求头
  final Map<String, dynamic> headers;

  /// 是否启用日志
  final bool enableLog;

  /// 日志标签
  final String logTag;

  /// 是否启用缓存
  final bool enableCache;

  /// 缓存有效期（毫秒）
  final Duration cacheMaxAge;

  /// 内容类型
  final String contentType;

  /// 响应类型
  final String responseType;

  const HttpConfig({
    this.baseUrl = '',
    this.connectTimeout = const Duration(seconds: 30),
    this.receiveTimeout = const Duration(seconds: 30),
    this.sendTimeout = const Duration(seconds: 30),
    this.headers = const {},
    this.enableLog = true,
    this.logTag = '🌐 HTTP',
    this.enableCache = false,
    this.cacheMaxAge = const Duration(minutes: 5),
    this.contentType = 'application/json',
    this.responseType = 'json',
  });

  /// 复制配置
  HttpConfig copyWith({
    String? baseUrl,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Duration? sendTimeout,
    Map<String, dynamic>? headers,
    bool? enableLog,
    String? logTag,
    bool? enableCache,
    Duration? cacheMaxAge,
    String? contentType,
    String? responseType,
  }) {
    return HttpConfig(
      baseUrl: baseUrl ?? this.baseUrl,
      connectTimeout: connectTimeout ?? this.connectTimeout,
      receiveTimeout: receiveTimeout ?? this.receiveTimeout,
      sendTimeout: sendTimeout ?? this.sendTimeout,
      headers: headers ?? this.headers,
      enableLog: enableLog ?? this.enableLog,
      logTag: logTag ?? this.logTag,
      enableCache: enableCache ?? this.enableCache,
      cacheMaxAge: cacheMaxAge ?? this.cacheMaxAge,
      contentType: contentType ?? this.contentType,
      responseType: responseType ?? this.responseType,
    );
  }

  /// 合并请求头
  Map<String, dynamic> mergeHeaders(Map<String, dynamic>? customHeaders) {
    if (customHeaders == null || customHeaders.isEmpty) {
      return Map.from(headers);
    }
    return {...headers, ...customHeaders};
  }
}
