// lib/features/trade/data/models/trade_model.dart

import 'package:json_annotation/json_annotation.dart';
import 'package:tradeverse/features/trade/domain/entity/trade_entity.dart';
import '../../../../app/constant/api/api_endpoint.dart'; // Import ApiEndpoints for serverAddress

part 'trade_api_model.g.dart'; // Generated file

@JsonSerializable()
class TradeModel extends TradeEntity {
  @JsonKey(name: '_id')
  final String idModel;
  @JsonKey(name: 'user')
  final String userIdModel;
  @JsonKey(name: 'symbol')
  final String symbolModel;
  @JsonKey(name: 'status')
  final String statusModel;
  @JsonKey(name: 'assetClass')
  final String assetClassModel;
  @JsonKey(name: 'tradeDirection')
  final String tradeDirectionModel;
  @JsonKey(name: 'entryDate')
  final DateTime entryDateModel;
  @JsonKey(name: 'entryPrice')
  final double entryPriceModel;
  @JsonKey(name: 'positionSize')
  final int positionSizeModel;
  @JsonKey(name: 'exitDate')
  final DateTime? exitDateModel;
  @JsonKey(name: 'exitPrice')
  final double? exitPriceModel;
  @JsonKey(name: 'stopLoss')
  final double? stopLossModel;
  @JsonKey(name: 'takeProfit')
  final double? takeProfitModel;
  @JsonKey(name: 'fees')
  final double feesModel;
  @JsonKey(name: 'tags')
  final List<String> tagsModel;
  @JsonKey(name: 'notes')
  final String? notesModel;
  @JsonKey(name: 'chartScreenshotUrl')
  final String? chartScreenshotUrlModel; // This is the raw URL from backend
  @JsonKey(name: 'rMultiple')
  final double? rMultipleModel;
  @JsonKey(name: 'createdAt')
  final DateTime? createdAtModel;
  @JsonKey(name: 'updatedAt')
  final DateTime? updatedAtModel;

  const TradeModel({
    required this.idModel,
    required this.userIdModel,
    required this.symbolModel,
    required this.statusModel,
    required this.assetClassModel,
    required this.tradeDirectionModel,
    required this.entryDateModel,
    required this.entryPriceModel,
    required this.positionSizeModel,
    this.exitDateModel,
    this.exitPriceModel,
    this.stopLossModel,
    this.takeProfitModel,
    required this.feesModel,
    required this.tagsModel,
    this.notesModel,
    this.chartScreenshotUrlModel, // Assign to the raw model field
    this.rMultipleModel,
    this.createdAtModel,
    this.updatedAtModel,
  }) : super(
         id: idModel,
         userId: userIdModel,
         symbol: symbolModel,
         status: statusModel,
         assetClass: assetClassModel,
         tradeDirection: tradeDirectionModel,
         entryDate: entryDateModel,
         entryPrice: entryPriceModel,
         positionSize: positionSizeModel,
         exitDate: exitDateModel,
         exitPrice: exitPriceModel,
         stopLoss: stopLossModel,
         takeProfit: takeProfitModel,
         fees: feesModel,
         tags: tagsModel,
         notes: notesModel,
         chartScreenshotUrl:
             chartScreenshotUrlModel, // Pass the raw URL to entity
         rMultiple: rMultipleModel,
         createdAt: createdAtModel,
         updatedAt: updatedAtModel,
       );

  factory TradeModel.fromJson(Map<String, dynamic> json) {
    // Perform URL transformation during deserialization
    final rawChartScreenshotUrl = json['chartScreenshotUrl'] as String?;
    final transformedChartScreenshotUrl = rawChartScreenshotUrl?.replaceAll(
      'http://localhost:5050',
      ApiEndpoints.serverAddress, // Use the configured server address
    );

    // Create a temporary map to modify the chartScreenshotUrl before passing to generated fromJson
    final Map<String, dynamic> modifiedJson = Map.from(json);
    if (transformedChartScreenshotUrl != null) {
      modifiedJson['chartScreenshotUrl'] = transformedChartScreenshotUrl;
    }

    return _$TradeModelFromJson(modifiedJson);
  }

  Map<String, dynamic> toJson() => _$TradeModelToJson(this);
}

@JsonSerializable()
class PaginatedTradesModel extends PaginatedTradesEntity {
  @JsonKey(name: 'trades')
  final List<TradeModel> tradesModel;
  @JsonKey(name: 'currentPage')
  final int currentPageModel;
  @JsonKey(name: 'totalPages')
  final int totalPagesModel;
  @JsonKey(name: 'totalTrades')
  final int totalTradesModel;

  const PaginatedTradesModel({
    required this.tradesModel,
    required this.currentPageModel,
    required this.totalPagesModel,
    required this.totalTradesModel,
  }) : super(
         trades: tradesModel,
         currentPage: currentPageModel,
         totalPages: totalPagesModel,
         totalTrades: totalTradesModel,
       );

  factory PaginatedTradesModel.fromJson(Map<String, dynamic> json) =>
      _$PaginatedTradesModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaginatedTradesModelToJson(this);
}
