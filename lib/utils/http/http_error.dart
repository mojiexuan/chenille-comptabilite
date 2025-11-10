import 'package:dio/dio.dart';

/// HTTP错误类型枚举
enum HttpErrorType {
  /// 网络连接错误
  network,

  /// 请求超时
  timeout,

  /// 取消请求
  cancel,

  /// 服务器错误
  server,

  /// 客户端错误
  client,

  /// 解析错误
  parse,

  /// 未知错误
  unknown,
}

/// HTTP错误异常类
class HttpException implements Exception {
  /// 错误消息
  final String message;

  /// 错误类型
  final HttpErrorType type;

  /// 状态码
  final int? statusCode;

  /// 原始错误对象
  final dynamic error;

  /// 堆栈信息
  final StackTrace? stackTrace;

  HttpException({
    required this.message,
    required this.type,
    this.statusCode,
    this.error,
    this.stackTrace,
  });

  /// 从Dio错误创建
  factory HttpException.fromDioError(DioException dioError) {
    String message;
    HttpErrorType type;
    int? statusCode = dioError.response?.statusCode;

    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        message = '请求超时，请检查网络连接';
        type = HttpErrorType.timeout;
        break;

      case DioExceptionType.badResponse:
        statusCode = dioError.response?.statusCode;
        message = _parseStatusCode(statusCode);
        type = statusCode != null && statusCode >= 500
            ? HttpErrorType.server
            : HttpErrorType.client;
        break;

      case DioExceptionType.cancel:
        message = '请求已取消';
        type = HttpErrorType.cancel;
        break;

      case DioExceptionType.connectionError:
        message = '网络连接失败，请检查网络设置';
        type = HttpErrorType.network;
        break;

      case DioExceptionType.badCertificate:
        message = 'SSL证书验证失败';
        type = HttpErrorType.network;
        break;

      case DioExceptionType.unknown:
        message = '未知错误：${dioError.message ?? "请稍后重试"}';
        type = HttpErrorType.unknown;
        break;
    }

    return HttpException(
      message: message,
      type: type,
      statusCode: statusCode,
      error: dioError,
      stackTrace: dioError.stackTrace,
    );
  }

  /// 解析HTTP状态码
  static String _parseStatusCode(int? statusCode) {
    if (statusCode == null) return '未知错误';

    switch (statusCode) {
      case 400:
        return '请求参数错误';
      case 401:
        return '未授权，请先登录';
      case 403:
        return '拒绝访问';
      case 404:
        return '请求的资源不存在';
      case 405:
        return '请求方法不允许';
      case 408:
        return '请求超时';
      case 500:
        return '服务器内部错误';
      case 502:
        return '网关错误';
      case 503:
        return '服务不可用';
      case 504:
        return '网关超时';
      default:
        return '请求失败 (错误码: $statusCode)';
    }
  }

  /// 是否为网络错误
  bool get isNetworkError => type == HttpErrorType.network;

  /// 是否为超时错误
  bool get isTimeoutError => type == HttpErrorType.timeout;

  /// 是否为取消错误
  bool get isCancelError => type == HttpErrorType.cancel;

  @override
  String toString() {
    return 'HttpException{type: $type, statusCode: $statusCode, message: $message}';
  }
}
