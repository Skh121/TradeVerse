import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:tradeverse/app/constant/api/api_endpoint.dart';
import 'package:tradeverse/core/network/dio_error_interceptor.dart';

class ApiService {
  final Dio _dio;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Dio get dio => _dio;

  ApiService(this._dio) {
    _dio
      ..options.baseUrl = ApiEndpoints.baseUrl
      ..options.connectTimeout = ApiEndpoints.connectionTimeout
      ..options.receiveTimeout = ApiEndpoints.receiveTimeout
      ..options.headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      }
      ..interceptors.add(DioErrorInterceptor())
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            final token = await _secureStorage.read(key: 'token');

            if (token != null && token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
            }

            return handler.next(options);
          },
        ),
      )
      ..interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
        ),
      );
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParams}) async {
    return await _dio.get(path, queryParameters: queryParams);
  }

  // Modified post method to handle FormData content type
  Future<Response> post(String path, {dynamic data, Options? options}) async {
    Options requestOptions = options ?? Options();
    if (data is FormData) {
      requestOptions = requestOptions.copyWith(
        headers: {
          ...(requestOptions.headers ?? {}),
          'Content-Type': 'multipart/form-data',
        },
      );
    }
    return await _dio.post(path, data: data, options: requestOptions);
  }

  Future<Response> put(String path, {dynamic data, Options? options}) async {
    Options requestOptions = options ?? Options();
    if (data is FormData) {
      requestOptions = requestOptions.copyWith(
        headers: {
          ...(requestOptions.headers ?? {}),
          'Content-Type': 'multipart/form-data',
        },
      );
    }
    return await _dio.put(path, data: data, options: requestOptions);
  }

  // Modified patch method to handle FormData content type
  Future<Response> patch(String path, {dynamic data, Options? options}) async {
    Options requestOptions = options ?? Options();
    if (data is FormData) {
      requestOptions = requestOptions.copyWith(
        headers: {
          ...(requestOptions.headers ?? {}),
          'Content-Type': 'multipart/form-data',
        },
      );
    }
    return await _dio.patch(path, data: data, options: requestOptions);
  }

  Future<Response> delete(String path, {dynamic data}) async {
    return await _dio.delete(path, data: data);
  }
}
