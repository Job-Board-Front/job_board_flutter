import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:job_board_flutter/core/dio_interceptors.dart';
import 'package:job_board_flutter/features/auth/providers/firebase_token_provider.dart';
import 'package:job_board_flutter/features/bookmarks/data/datasources/bookmarks_remote_datasource/bookmarks_remote_datasource.dart';
import '../../../../core/constants/api_constants.dart';

class BookmarksRemoteDataSourceProvider {
  static BookmarksRemoteDataSource create({Dio? dio}) {
    final dioInstance = dio ?? _createDefaultDio();
    return BookmarksRemoteDataSource(dioInstance);
  }

  static Dio _createDefaultDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        responseType: ResponseType.json,
      ),
    );

    if (kDebugMode) {
      dio.interceptors.add(DioLoggingInterceptor());
    }
    dio.interceptors.add(DioCacheInterceptor());
    dio.interceptors.add(DioAuthInterceptor(FirebaseTokenProvider()));

    return dio;
  }
}
