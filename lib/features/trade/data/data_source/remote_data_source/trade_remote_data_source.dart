import 'dart:io';
import 'dart:convert'; // For json.encode
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart'; // For MediaType
import 'package:tradeverse/app/constant/api/api_endpoint.dart';
import 'package:tradeverse/core/network/api_service.dart';
import 'package:tradeverse/features/trade/data/data_source/trade_data_source.dart';
import 'package:tradeverse/features/trade/data/model/trade_api_model.dart';
import 'package:tradeverse/features/trade/domain/entity/trade_entity.dart';

class TradeRemoteDataSource implements ITradeDataSource {
  final ApiService _apiService;

  TradeRemoteDataSource({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<TradeModel> createTrade({
    required String symbol,
    required String assetClass,
    required String tradeDirection,
    required DateTime entryDate,
    required double entryPrice,
    required int positionSize,
    DateTime? exitDate,
    double? exitPrice,
    double? stopLoss,
    double? takeProfit,
    required double fees,
    required List<String> tags,
    String? notes,
    File? chartScreenshotFile,
  }) async {
    try {
      final Map<String, dynamic> dataMap = {
        'symbol': symbol,
        'assetClass': assetClass,
        'tradeDirection': tradeDirection,
        'entryDate': entryDate.toUtc().toIso8601String(),
        'entryPrice': entryPrice,
        'positionSize': positionSize,
        'fees': fees,
        'tags': json.encode(tags), // JSON encode tags list
        'notes': notes,
      };

      if (exitDate != null) {
        dataMap['exitDate'] = exitDate.toUtc().toIso8601String();
      }
      if (exitPrice != null) dataMap['exitPrice'] = exitPrice;
      if (stopLoss != null) dataMap['stopLoss'] = stopLoss;
      if (takeProfit != null) dataMap['takeProfit'] = takeProfit;

      FormData formData = FormData.fromMap(dataMap);

      if (chartScreenshotFile != null) {
        String? mimeType;
        if (chartScreenshotFile.path.endsWith('.png')) {
          mimeType = 'image/png';
        } else if (chartScreenshotFile.path.endsWith('.jpg') ||
            chartScreenshotFile.path.endsWith('.jpeg')) {
          mimeType = 'image/jpeg';
        } else if (chartScreenshotFile.path.endsWith('.gif')) {
          mimeType = 'image/gif';
        }

        formData.files.add(
          MapEntry(
            'chartScreenshot',
            await MultipartFile.fromFile(
              chartScreenshotFile.path,
              filename: chartScreenshotFile.path.split('/').last,
              contentType: mimeType != null ? MediaType.parse(mimeType) : null,
            ),
          ),
        );
      }

      final response = await _apiService.post(
        ApiEndpoints.trades,
        data: formData,
      );

      if (response.statusCode == 201) {
        return TradeModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to create trade: ${response.statusMessage}',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Future<PaginatedTradesModel> getAllTrades({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await _apiService.get(
        ApiEndpoints.trades,
        queryParams: {'page': page, 'limit': limit},
      );

      if (response.statusCode == 200) {
        return PaginatedTradesModel.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to fetch trades: ${response.statusMessage}',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Future<TradeModel> getTradeById(String id) async {
    try {
      final response = await _apiService.get(ApiEndpoints.tradeById(id));

      if (response.statusCode == 200) {
        return TradeModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to get trade: ${response.statusMessage}',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Future<TradeModel> updateTrade({
    required String id,
    String? symbol,
    String? status,
    String? assetClass,
    String? tradeDirection,
    DateTime? entryDate,
    double? entryPrice,
    int? positionSize,
    DateTime? exitDate,
    double? exitPrice,
    double? stopLoss,
    double? takeProfit,
    double? fees,
    List<String>? tags,
    String? notes,
    File? chartScreenshotFile,
    bool clearChartScreenshot = false,
  }) async {
    try {
      final Map<String, dynamic> updateData = {};

      if (symbol != null) updateData['symbol'] = symbol;
      if (status != null) updateData['status'] = status;
      if (assetClass != null) updateData['assetClass'] = assetClass;
      if (tradeDirection != null) updateData['tradeDirection'] = tradeDirection;
      if (entryDate != null) {
        updateData['entryDate'] = entryDate.toUtc().toIso8601String();
      }
      if (entryPrice != null) updateData['entryPrice'] = entryPrice;
      if (positionSize != null) updateData['positionSize'] = positionSize;
      if (exitDate != null) {
        updateData['exitDate'] = exitDate.toUtc().toIso8601String();
      }
      if (exitPrice != null) updateData['exitPrice'] = exitPrice;
      if (stopLoss != null) updateData['stopLoss'] = stopLoss;
      if (takeProfit != null) updateData['takeProfit'] = takeProfit;
      if (fees != null) updateData['fees'] = fees;
      if (tags != null) updateData['tags'] = json.encode(tags);
      if (notes != null) updateData['notes'] = notes;
      if (clearChartScreenshot) updateData['chartScreenshotUrl'] = '';

      dynamic requestData = updateData;
      Options? requestOptions;

      if (chartScreenshotFile != null) {
        FormData formData = FormData.fromMap(updateData);
        String? mimeType;

        if (chartScreenshotFile.path.endsWith('.png')) {
          mimeType = 'image/png';
        } else if (chartScreenshotFile.path.endsWith('.jpg') ||
            chartScreenshotFile.path.endsWith('.jpeg')) {
          mimeType = 'image/jpeg';
        } else if (chartScreenshotFile.path.endsWith('.gif')) {
          mimeType = 'image/gif';
        }

        formData.files.add(
          MapEntry(
            'chartScreenshot',
            await MultipartFile.fromFile(
              chartScreenshotFile.path,
              filename: chartScreenshotFile.path.split('/').last,
              contentType: mimeType != null ? MediaType.parse(mimeType) : null,
            ),
          ),
        );

        requestData = formData;
      }

      final response = await _apiService.patch(
        ApiEndpoints.tradeById(id),
        data: requestData,
        options: requestOptions,
      );

      if (response.statusCode == 200) {
        return TradeModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to update trade: ${response.statusMessage}',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Future<String> deleteTrade(String id) async {
    try {
      final response = await _apiService.delete(ApiEndpoints.tradeById(id));
      if (response.statusCode == 200) {
        return (response.data as Map<String, dynamic>)['message'] as String;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to delete trade: ${response.statusMessage}',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Future<void> cacheTradeList(PaginatedTradesEntity data) {
    throw UnimplementedError(
      'Remote data source does not implement cacheTradeList',
    );
  }

  @override
  Future<PaginatedTradesEntity> getCachedTradeList() {
    throw UnimplementedError(
      'Remote data source does not implement getCachedTradeList',
    );
  }
}
