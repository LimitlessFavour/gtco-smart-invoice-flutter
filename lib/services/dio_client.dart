import 'package:dio/dio.dart';
import '../models/auth/auth_token.dart';

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

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: _onRequest,
        onError: _onError,
      ),
    );
  }

  void setAuthToken(AuthToken? token) {
    _authToken = token;
  }

  Future<void> _onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (_authToken != null) {
      options.headers['Authorization'] = 'Bearer ${_authToken!.accessToken}';
    }
    return handler.next(options);
  }

  Future<void> _onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
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
        // Token refresh failed
        onTokenRefreshed?.call(null);
      }
    }
    return handler.next(err);
  }

  Future<AuthToken?> _refreshToken() async {
    try {
      final response = await _dio.post('/auth/refresh-token', data: {
        'refresh_token': _authToken?.refreshToken,
      });

      if (response.statusCode == 200) {
        final newToken = AuthToken.fromJson(response.data);
        _authToken = newToken;
        onTokenRefreshed?.call(newToken);
        return newToken;
      }
    } catch (e) {
      // Handle refresh token error
    }
    return null;
  }

  Future<Response> get(String path) async {
    return _dio.get(path);
  }

  Future<Response> post(String path, {dynamic data}) async {
    return _dio.post(path, data: data);
  }

  // Add other methods as needed
}
