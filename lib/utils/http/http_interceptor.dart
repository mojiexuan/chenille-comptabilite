import 'package:dio/dio.dart';

/// HTTP拦截器接口
abstract class HttpInterceptor {
  /// 请求拦截
  /// 返回 null 表示继续请求，返回 Response 表示提前结束请求
  Future<Response?> onRequest(RequestOptions options);

  /// 响应拦截
  /// 返回处理后的响应
  Future<Response> onResponse(Response response);

  /// 错误拦截
  /// 返回 null 表示继续抛出错误，返回 Response 表示错误已处理
  Future<Response?> onError(DioException error);
}

/// 日志拦截器
class LogInterceptor extends HttpInterceptor {
  final String tag;
  final bool enabled;

  LogInterceptor({
    this.tag = '🌐 HTTP',
    this.enabled = true,
  });

  @override
  Future<Response?> onRequest(RequestOptions options) async {
    if (!enabled) return null;

    print('\n$tag ====== 请求开始 ======');
    print('$tag URL: ${options.method} ${options.uri}');
    print('$tag Headers: ${options.headers}');
    if (options.data != null) {
      print('$tag Data: ${options.data}');
    }
    if (options.queryParameters.isNotEmpty) {
      print('$tag Query: ${options.queryParameters}');
    }
    print('$tag ====== 请求结束 ======\n');

    return null;
  }

  @override
  Future<Response> onResponse(Response response) async {
    if (!enabled) return response;

    print('\n$tag ====== 响应开始 ======');
    print('$tag URL: ${response.requestOptions.uri}');
    print('$tag Status: ${response.statusCode}');
    print('$tag Data: ${response.data}');
    print('$tag ====== 响应结束 ======\n');

    return response;
  }

  @override
  Future<Response?> onError(DioException error) async {
    if (!enabled) return null;

    print('\n$tag ====== 错误开始 ======');
    print('$tag URL: ${error.requestOptions.uri}');
    print('$tag Type: ${error.type}');
    print('$tag Message: ${error.message}');
    if (error.response != null) {
      print('$tag Status: ${error.response?.statusCode}');
      print('$tag Data: ${error.response?.data}');
    }
    print('$tag ====== 错误结束 ======\n');

    return null;
  }
}

/// Token拦截器（示例）
class TokenInterceptor extends HttpInterceptor {
  final String Function() getToken;
  final String tokenKey;

  TokenInterceptor({
    required this.getToken,
    this.tokenKey = 'Authorization',
  });

  @override
  Future<Response?> onRequest(RequestOptions options) async {
    final token = getToken();
    if (token.isNotEmpty) {
      options.headers[tokenKey] = 'Bearer $token';
    }
    return null;
  }

  @override
  Future<Response> onResponse(Response response) async {
    return response;
  }

  @override
  Future<Response?> onError(DioException error) async {
    // 401 未授权时可以在这里处理刷新token等逻辑
    if (error.response?.statusCode == 401) {
      // TODO: 实现token刷新逻辑
    }
    return null;
  }
}

/// 重试拦截器
class RetryInterceptor extends HttpInterceptor {
  final int maxRetries;
  final Duration retryDelay;

  RetryInterceptor({
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 1),
  });

  @override
  Future<Response?> onRequest(RequestOptions options) async {
    return null;
  }

  @override
  Future<Response> onResponse(Response response) async {
    return response;
  }

  @override
  Future<Response?> onError(DioException error) async {
    final extra = error.requestOptions.extra;
    final retryCount = extra['retryCount'] as int? ?? 0;

    // 判断是否应该重试
    if (retryCount < maxRetries && _shouldRetry(error)) {
      extra['retryCount'] = retryCount + 1;

      // 等待后重试
      await Future.delayed(retryDelay * (retryCount + 1));

      // 重新发起请求
      final dio = Dio();
      try {
        return await dio.fetch(error.requestOptions);
      } catch (e) {
        // 重试失败，返回null继续抛出错误
        return null;
      }
    }

    return null;
  }

  /// 判断是否应该重试
  bool _shouldRetry(DioException error) {
    return error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.connectionError ||
        (error.response?.statusCode ?? 0) >= 500;
  }
}
