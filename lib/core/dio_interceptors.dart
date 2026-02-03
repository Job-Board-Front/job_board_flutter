import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Logging interceptor for Dio to log all HTTP requests and responses.
///
/// This interceptor logs:
/// - Request method, path, and headers
/// - Request body/query parameters
/// - Response status code and body
/// - Error details
///
/// Only logs in debug mode to avoid logging in production.
class DioLoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      print('');
      print(
        '╔════════════════════════════════════════════════════════════════',
      );
      print('║ [DIO REQUEST]');
      print('╠ ${options.method.toUpperCase()} ${options.path}');
      print('╠ Headers:');
      options.headers.forEach((key, value) {
        print('║   $key: $value');
      });
      if (options.queryParameters.isNotEmpty) {
        print('╠ Query Parameters:');
        options.queryParameters.forEach((key, value) {
          print('║   $key: $value');
        });
      }
      if (options.data != null) {
        print('╠ Body: ${options.data}');
      }
      print(
        '╚════════════════════════════════════════════════════════════════',
      );
      print('');
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      print('');
      print(
        '╔════════════════════════════════════════════════════════════════',
      );
      print('║ [DIO RESPONSE]');
      print('╠ ${response.statusCode} ${response.requestOptions.path}');
      print('╠ Headers:');
      response.headers.forEach((key, value) {
        print('║   $key: ${value.join(', ')}');
      });
      print('╠ Body: ${response.data}');
      print(
        '╚════════════════════════════════════════════════════════════════',
      );
      print('');
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      print('');
      print(
        '╔════════════════════════════════════════════════════════════════',
      );
      print('║ [DIO ERROR]');
      print(
        '╠ ${err.response?.statusCode ?? 'NO STATUS'} ${err.requestOptions.path}',
      );
      print('╠ Error Type: ${err.type}');
      print('╠ Error Message: ${err.message}');
      if (err.response != null) {
        print('╠ Response Body: ${err.response?.data}');
      }
      print(
        '╚════════════════════════════════════════════════════════════════',
      );
      print('');
    }
    super.onError(err, handler);
  }
}

/// Retry interceptor that automatically retries failed requests.
///
/// This interceptor retries requests that fail due to:
/// - Connection timeouts
/// - Network errors (but not 4xx or 5xx responses)
/// - Configurable retry count and delay
class DioRetryInterceptor extends Interceptor {
  final int retryCount;
  final Duration retryDelay;
  final Dio dio;

  DioRetryInterceptor({
    this.retryCount = 3,
    this.retryDelay = const Duration(milliseconds: 500),
    required this.dio,
  });

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_shouldRetry(err)) {
      try {
        await Future.delayed(retryDelay);
        final response = await _retry(err);
        return handler.resolve(response);
      } catch (e) {
        return handler.next(err);
      }
    }
    handler.next(err);
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.unknown;
  }

  Future<Response> _retry(DioException err) async {
    final options = err.requestOptions;
    return dio.request(
      options.path,
      data: options.data,
      queryParameters: options.queryParameters,
      options: Options(method: options.method, headers: options.headers),
    );
  }
}

/// Authentication interceptor for handling JWT tokens.
///
/// This interceptor:
/// - Adds Bearer token to all requests
/// - Handles token refresh on 401 responses
/// - Requires a TokenProvider implementation
abstract class TokenProvider {
  Future<String?> getToken();
  Future<String?> refreshToken();
}

class DioAuthInterceptor extends Interceptor {
  final TokenProvider tokenProvider;
  final Dio dio;

  DioAuthInterceptor(this.tokenProvider, {required this.dio});

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await tokenProvider.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      try {
        final newToken = await tokenProvider.refreshToken();
        if (newToken != null) {
          final options = err.requestOptions;
          options.headers['Authorization'] = 'Bearer $newToken';

          // Retry the request with the new token using the same Dio instance
          final response = await dio.request(
            options.path,
            data: options.data,
            queryParameters: options.queryParameters,
            options: Options(
              method: options.method,
              headers: options.headers,
              extra: options.extra,
            ),
            cancelToken: options.cancelToken,
          );
          return handler.resolve(response);
        }
      } catch (e) {
        // Token refresh failed, let the error propagate
        print('Token refresh failed: $e');
      }
    }
    super.onError(err, handler);
  }
}

/// Request/Response interceptor for adding custom headers or modifying requests.
///
/// Use this for common operations like:
/// - Adding API version headers
/// - Adding custom user-agent
/// - Adding request ID for tracking
/// - Modifying request/response payloads
class DioCustomHeadersInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add custom headers to all requests
    options.headers['X-API-Version'] = '1.0';
    options.headers['X-Request-ID'] = _generateRequestId();

    super.onRequest(options, handler);
  }

  String _generateRequestId() {
    return '${DateTime.now().millisecondsSinceEpoch}-${(100000 + (99999 * 0.5)).toInt()}';
  }
}

/// Cache interceptor for caching GET requests locally.
///
/// This is a simple example. For production, consider using:
/// - GetStorage
/// - Hive
/// - Floor
class DioCacheInterceptor extends Interceptor {
  final Map<String, Response> _cache = {};

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.method.toUpperCase() == 'GET') {
      final cacheKey = _getCacheKey(options);
      if (_cache.containsKey(cacheKey)) {
        return handler.resolve(_cache[cacheKey]!);
      }
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.requestOptions.method.toUpperCase() == 'GET') {
      final cacheKey = _getCacheKey(response.requestOptions);
      _cache[cacheKey] = response;
    }
    super.onResponse(response, handler);
  }

  String _getCacheKey(RequestOptions options) {
    return '${options.method}-${options.path}-${options.queryParameters}';
  }

  void clearCache() {
    _cache.clear();
  }

  void clearCacheForPath(String path) {
    final keysToRemove = _cache.keys.where((key) => key.contains(path)).toList();
    for (final key in keysToRemove) {
      _cache.remove(key);
    }
  }
}

/// Example of how to set up all interceptors in your DioProvider
/*
class JobRemoteDataSourceProvider {
  static JobRemoteDataSource create({Dio? dio}) {
    final dioInstance = dio ?? _createDefaultDio();
    return JobRemoteDataSource(dioInstance);
  }

  static Dio _createDefaultDio() {
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        responseType: ResponseType.json,
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    // Add interceptors in order of execution
    if (kDebugMode) {
      dio.interceptors.add(DioLoggingInterceptor());
    }

    // Authentication must be before retry to avoid re-adding expired token
    // dio.interceptors.add(DioAuthInterceptor(MyTokenProvider()));

    // Custom headers
    dio.interceptors.add(DioCustomHeadersInterceptor());

    // Retry failed requests
    dio.interceptors.add(DioRetryInterceptor(retryCount: 3));

    // Optional: Caching for GET requests
    // dio.interceptors.add(DioCacheInterceptor());

    return dio;
  }
}
*/
