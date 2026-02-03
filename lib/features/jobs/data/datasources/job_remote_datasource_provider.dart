import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:job_board_flutter/core/auth/firebase_token_provider.dart';
import 'package:job_board_flutter/core/dio_interceptors.dart';
import '../../../../core/constants/api_constants.dart';
import 'job_remote_datasource/job_remote_datasource.dart';

class JobRemoteDataSourceProvider {
  static Dio? _defaultDio;
  static DioCacheInterceptor? _cacheInterceptor;

  static JobRemoteDataSource create({Dio? dio}) {
    final dioInstance = dio ?? _createDefaultDio();
    return JobRemoteDataSource(dioInstance, baseUrl: ApiConstants.baseUrl);
  }

  static void clearJobCache(String jobId) {
    _cacheInterceptor?.clearCacheForPath('/jobs/$jobId');
  }

  static Dio _createDefaultDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        responseType: ResponseType.json,
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    // Add logging interceptor first (in debug mode)
    if (kDebugMode) {
      dio.interceptors.add(DioLoggingInterceptor());
    }

    // Add authentication interceptor - must be before other interceptors
    // Pass the dio instance so it can retry requests on 401 errors
    final tokenProvider = FirebaseTokenProvider(FirebaseAuth.instance);
    dio.interceptors.add(DioAuthInterceptor(tokenProvider, dio: dio));

    // Add cache interceptor and store reference for cache clearing
    _cacheInterceptor = DioCacheInterceptor();
    dio.interceptors.add(_cacheInterceptor!);

    _defaultDio = dio;
    return dio;
  }
}
