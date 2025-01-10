import 'package:dio/dio.dart';
import '../models/auth/auth_token.dart';
import '../services/logger_service.dart';

class DioClient {
  late Dio _dio;
  final String baseUrl;
  AuthToken? _authToken;
  final void Function(AuthToken?)? onTokenRefreshed;

  DioClient({
    required this.baseUrl,
    this.onTokenRefreshed,
  }) {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      validateStatus: (status) => status! < 500,
    ));

    _dio.interceptors.addAll([
      InterceptorsWrapper(
        onRequest: _onRequest,
        onResponse: _onResponse,
        onError: _onError,
      ),
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (obj) {
          // Prevent double logging
          if (obj.toString().contains('► REQUEST')) return;
          if (obj.toString().contains('◄ RESPONSE')) return;
        },
      ),
    ]);
  }

  void setAuthToken(AuthToken? token) {
    _authToken = token;
  }

  Future<void> _onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Log the request
    LoggerService.debug(
      '► API Request',
      {
        'method': options.method,
        'endpoint': '${options.baseUrl}${options.path}',
        'headers': options.headers,
        'data': options.data,
        'queryParameters': options.queryParameters,
      },
    );

    if (_authToken != null) {
      options.headers['Authorization'] = 'Bearer ${_authToken!.accessToken}';
    }
    return handler.next(options);
  }

  Future<void> _onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    final statusCode = response.statusCode;
    final isSuccess =
        statusCode != null && statusCode >= 200 && statusCode < 300;

    final responseData = {
      'endpoint':
          '${response.requestOptions.baseUrl}${response.requestOptions.path}',
      'statusCode': statusCode,
      'data': _formatResponseData(response.data),
      'headers': response.headers.map,
      'body': response.data,
    };

    if (isSuccess) {
      LoggerService.success('◄ API Response', responseData);
    } else {
      LoggerService.error('◄ API Response', error: responseData.toString());
    }

    return handler.next(response);
  }

  Future<void> _onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final errorData = err.response?.data is Map
        ? err.response?.data
        : {'message': err.message};

    LoggerService.error(
      '✖ API Error',
      error: {
        'endpoint': '${err.requestOptions.baseUrl}${err.requestOptions.path}',
        'statusCode': err.response?.statusCode,
        'error': errorData,
        'type': err.type.toString(),
        'requestData': err.requestOptions.data,
      },
    );

    if (err.response?.statusCode == 401 && _authToken != null) {
      try {
        final newToken = await _refreshToken();
        if (newToken != null) {
          // Retry the original request with new token
          final opts = err.requestOptions;
          opts.headers['Authorization'] = 'Bearer ${newToken.accessToken}';
          final response = await _dio.fetch(opts);
          return handler.resolve(response);
        }
      } catch (e) {
        LoggerService.error('Token refresh failed', error: e);
        onTokenRefreshed?.call(null);
      }
    }
    return handler.next(err);
  }

  Future<AuthToken?> _refreshToken() async {
    try {
      LoggerService.debug('Attempting to refresh token');

      final response = await _dio.post('/auth/refresh-token', data: {
        'refresh_token': _authToken?.refreshToken,
      });

      if (response.statusCode == 200) {
        final newToken = AuthToken.fromJson(response.data);
        _authToken = newToken;
        onTokenRefreshed?.call(newToken);
        LoggerService.success('Token refreshed successfully');
        return newToken;
      }

      LoggerService.error(
        'Token refresh failed',
        error: {'statusCode': response.statusCode, 'data': response.data},
      );
    } catch (e) {
      LoggerService.error('Token refresh error', error: e);
    }
    return null;
  }

  Map<String, dynamic> _formatResponseData(dynamic data) {
    if (data == null) return {'data': null};

    if (data is Map) {
      // Remove sensitive data
      final sanitizedData = Map<String, dynamic>.from(data);
      if (sanitizedData.containsKey('password')) {
        sanitizedData['password'] = '***';
      }
      if (sanitizedData.containsKey('access_token')) {
        sanitizedData['access_token'] = '***';
      }
      if (sanitizedData.containsKey('refresh_token')) {
        sanitizedData['refresh_token'] = '***';
      }
      return sanitizedData;
    }

    return {'data': data.toString()};
  }

  Future<Response> get(String path,
      {Map<String, dynamic>? queryParameters}) async {
    return _dio.get(path, queryParameters: queryParameters);
  }

  Future<Response> post(String path, {dynamic data}) async {
    return _dio.post(path, data: data);
  }

  Future<Response> put(String path, {dynamic data}) async {
    return _dio.put(path, data: data);
  }

  Future<Response> delete(String path) async {
    return _dio.delete(path);
  }

  Future<Response> patch(String path, {dynamic data}) async {
    return _dio.patch(path, data: data);
  }
}
