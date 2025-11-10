/// HTTP响应包装类
class HttpResponse<T> {
  /// 响应数据
  final T? data;

  /// 响应状态码
  final int statusCode;

  /// 响应消息
  final String message;

  /// 是否成功
  final bool success;

  /// 额外信息
  final Map<String, dynamic>? extra;

  /// 时间戳
  final DateTime timestamp;

  HttpResponse({
    this.data,
    this.statusCode = 200,
    this.message = '',
    this.success = true,
    this.extra,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  /// 创建成功响应
  factory HttpResponse.success({
    T? data,
    int statusCode = 200,
    String message = '请求成功',
    Map<String, dynamic>? extra,
  }) {
    return HttpResponse<T>(
      data: data,
      statusCode: statusCode,
      message: message,
      success: true,
      extra: extra,
    );
  }

  /// 创建失败响应
  factory HttpResponse.failure({
    int statusCode = 500,
    String message = '请求失败',
    T? data,
    Map<String, dynamic>? extra,
  }) {
    return HttpResponse<T>(
      data: data,
      statusCode: statusCode,
      message: message,
      success: false,
      extra: extra,
    );
  }

  /// 从JSON创建
  factory HttpResponse.fromJson(
    Map<String, dynamic> json, {
    T Function(dynamic)? dataParser,
  }) {
    return HttpResponse<T>(
      data: dataParser != null && json['data'] != null
          ? dataParser(json['data'])
          : json['data'] as T?,
      statusCode: json['code'] as int? ?? json['statusCode'] as int? ?? 200,
      message: json['message'] as String? ?? json['msg'] as String? ?? '',
      success: json['success'] as bool? ?? true,
      extra: json['extra'] as Map<String, dynamic>?,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'data': data,
      'statusCode': statusCode,
      'message': message,
      'success': success,
      'extra': extra,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  /// 复制并转换数据类型
  HttpResponse<R> copyWith<R>({
    R? data,
    int? statusCode,
    String? message,
    bool? success,
    Map<String, dynamic>? extra,
  }) {
    return HttpResponse<R>(
      data: data ?? this.data as R?,
      statusCode: statusCode ?? this.statusCode,
      message: message ?? this.message,
      success: success ?? this.success,
      extra: extra ?? this.extra,
      timestamp: timestamp,
    );
  }

  @override
  String toString() {
    return 'HttpResponse{success: $success, statusCode: $statusCode, message: $message, data: $data}';
  }
}
