import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:tradeverse/app/constant/api/api_endpoint.dart';
import 'package:tradeverse/core/network/dio_error_interceptor.dart';
 
class ApiService {
  final Dio _dio;
 
  Dio get dio => _dio;
 
  ApiService(this._dio) {
    _dio
      ..options.baseUrl = ApiEndpoints.baseUrl
      ..options.connectTimeout = ApiEndpoints.connectionTimeout
      ..options.receiveTimeout = ApiEndpoints.receiveTimeout
      ..interceptors.add(DioErrorInterceptor())
      ..interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
 
          requestBody: true,
 
          responseHeader: true,
        ),
      )
      ..options.headers = {
        'Accept': 'application/json',
 
        'Content-Type': 'application/json',
      };
  }
}
 