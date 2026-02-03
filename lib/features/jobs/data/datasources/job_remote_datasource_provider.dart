import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:job_board_flutter/core/dio_interceptors.dart';
import '../../../../core/constants/api_constants.dart';
import 'job_remote_datasource/job_remote_datasource.dart';

class JobRemoteDataSourceProvider {
  static JobRemoteDataSource create({Dio? dio}) {
    final dioInstance = dio ?? _createDefaultDio();
    return JobRemoteDataSource(dioInstance);
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

    return dio;
  }
}
