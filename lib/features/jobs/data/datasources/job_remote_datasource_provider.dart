import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import 'job_remote_datasource.dart';

class JobRemoteDataSourceProvider {
  static JobRemoteDataSource create({Dio? dio}) {
    final dioInstance = dio ?? _createDefaultDio();
    return JobRemoteDataSource(dioInstance);
  }

  static Dio _createDefaultDio() {
    return Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        responseType: ResponseType.json,
      ),
    );
  }
}
