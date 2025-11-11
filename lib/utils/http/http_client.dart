import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:chenille_comptabilite/utils/http/http_config.dart';
import 'package:chenille_comptabilite/utils/http/http_error.dart';
import 'package:chenille_comptabilite/utils/http/http_interceptor.dart'
    as custom;
import 'package:chenille_comptabilite/utils/http/http_response.dart' as custom;

/// 企业级HTTP客户端
class HttpClient {
  static HttpClient? _instance;
  late Dio _dio;
  late HttpConfig _config;
  final List<custom.HttpInterceptor> _customInterceptors = [];

  /// 获取单例
  factory HttpClient() {
    _instance ??= HttpClient._internal();
    return _instance!;
  }

  HttpClient._internal();

  /// 初始化配置
  void init(HttpConfig config) {
    _config = config;
    _dio = Dio(BaseOptions(
      baseUrl: config.baseUrl,
      connectTimeout: config.connectTimeout,
      receiveTimeout: config.receiveTimeout,
      sendTimeout: config.sendTimeout,
      headers: config.headers,
      contentType: config.contentType,
      responseType: ResponseType.json,
    ));

    // 添加日志拦截器
    if (config.enableLog) {
      addInterceptor(custom.LogInterceptor(tag: config.logTag, enabled: true));
    }
  }

  /// 添加拦截器
  void addInterceptor(custom.HttpInterceptor interceptor) {
    _customInterceptors.add(interceptor);
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final response = await interceptor.onRequest(options);
        if (response != null) {
          handler.resolve(response);
        } else {
          handler.next(options);
        }
      },
      onResponse: (response, handler) async {
        final newResponse = await interceptor.onResponse(response);
        handler.next(newResponse);
      },
      onError: (error, handler) async {
        final response = await interceptor.onError(error);
        if (response != null) {
          handler.resolve(response);
        } else {
          handler.next(error);
        }
      },
    ));
  }

  /// 清空拦截器
  void clearInterceptors() {
    _customInterceptors.clear();
    _dio.interceptors.clear();
  }

  /// GET请求
  Future<custom.HttpResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
    T Function(dynamic)? parser,
  }) async {
    return _request<T>(
      path,
      method: 'GET',
      queryParameters: queryParameters,
      headers: headers,
      cancelToken: cancelToken,
      parser: parser,
    );
  }

  /// POST请求
  Future<custom.HttpResponse<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
    T Function(dynamic)? parser,
  }) async {
    return _request<T>(
      path,
      method: 'POST',
      data: data,
      queryParameters: queryParameters,
      headers: headers,
      cancelToken: cancelToken,
      parser: parser,
    );
  }

  /// PUT请求
  Future<custom.HttpResponse<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
    T Function(dynamic)? parser,
  }) async {
    return _request<T>(
      path,
      method: 'PUT',
      data: data,
      queryParameters: queryParameters,
      headers: headers,
      cancelToken: cancelToken,
      parser: parser,
    );
  }

  /// DELETE请求
  Future<custom.HttpResponse<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
    T Function(dynamic)? parser,
  }) async {
    return _request<T>(
      path,
      method: 'DELETE',
      data: data,
      queryParameters: queryParameters,
      headers: headers,
      cancelToken: cancelToken,
      parser: parser,
    );
  }

  /// PATCH请求
  Future<custom.HttpResponse<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
    T Function(dynamic)? parser,
  }) async {
    return _request<T>(
      path,
      method: 'PATCH',
      data: data,
      queryParameters: queryParameters,
      headers: headers,
      cancelToken: cancelToken,
      parser: parser,
    );
  }

  /// 文件上传
  Future<custom.HttpResponse<T>> upload<T>(
    String path, {
    required File file,
    String fileKey = 'file',
    Map<String, dynamic>? data,
    ProgressCallback? onProgress,
    CancelToken? cancelToken,
    T Function(dynamic)? parser,
  }) async {
    final fileName = file.path.split('/').last;
    final formData = FormData.fromMap({
      fileKey: await MultipartFile.fromFile(file.path, filename: fileName),
      if (data != null) ...data,
    });

    return post<T>(
      path,
      data: formData,
      cancelToken: cancelToken,
      parser: parser,
    );
  }

  /// 文件下载
  Future<custom.HttpResponse<String>> download(
    String urlPath,
    String savePath, {
    ProgressCallback? onProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      await _dio.download(
        urlPath,
        savePath,
        onReceiveProgress: onProgress,
        cancelToken: cancelToken,
      );
      return custom.HttpResponse.success(
        data: savePath,
        message: '下载成功',
      );
    } on DioException catch (e) {
      throw HttpException.fromDioError(e);
    } catch (e) {
      throw HttpException(
        message: '下载失败：$e',
        type: HttpErrorType.unknown,
        error: e,
      );
    }
  }

  /// 通用请求方法
  Future<custom.HttpResponse<T>> _request<T>(
    String path, {
    required String method,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
    T Function(dynamic)? parser,
  }) async {
    try {
      final options = Options(
        method: method,
        headers: _config.mergeHeaders(headers),
      );

      final response = await _dio.request(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      // 解析响应
      return _parseResponse<T>(response, parser);
    } on DioException catch (e) {
      throw HttpException.fromDioError(e);
    } catch (e) {
      throw HttpException(
        message: '请求异常：$e',
        type: HttpErrorType.unknown,
        error: e,
      );
    }
  }

  /// 解析响应
  custom.HttpResponse<T> _parseResponse<T>(
    Response response,
    T Function(dynamic)? parser,
  ) {
    try {
      var data = response.data;

      // 如果返回的是字符串，尝试解析为JSON
      if (data is String) {
        try {
          data = jsonDecode(data);
        } catch (e) {
          // 如果不是JSON格式，保持原样
        }
      }

      // 如果返回的是标准格式 {code, data, message}
      if (data is Map<String, dynamic>) {
        // 检查是否有标准的响应格式字段
        if (data.containsKey('code') ||
            data.containsKey('data') ||
            data.containsKey('message')) {
          return custom.HttpResponse.fromJson(
            data,
            dataParser: parser,
          );
        }

        // 否则将整个 Map 作为数据返回
        return custom.HttpResponse.success(
          data: parser != null ? parser(data) : data as T,
        );
      }

      // 如果返回的直接是数据
      return custom.HttpResponse.success(
        data: parser != null ? parser(data) : data as T,
      );
    } catch (e) {
      throw HttpException(
        message: '数据解析失败：$e',
        type: HttpErrorType.parse,
        error: e,
      );
    }
  }
}
