import 'package:hive_flutter/hive_flutter.dart';
import 'package:tradeverse/app/constant/hive/hive_table_constant.dart';
import 'package:tradeverse/features/trade/domain/entity/trade_entity.dart';

part 'trade_hive_model.g.dart'; // For Hive code generation

@HiveType(typeId: HiveTableConstant.tradeTableId)
class TradeHiveModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  
  final String userId;

  @HiveField(2)
  final String symbol;

  @HiveField(3)
  final String status;

  @HiveField(4)
  final String assetClass;

  @HiveField(5)
  final String tradeDirection;

  @HiveField(6)
  final DateTime entryDate;

  @HiveField(7)
  final double entryPrice;

  @HiveField(8)
  final int positionSize;

  @HiveField(9)
  final DateTime? exitDate;

  @HiveField(10)
  final double? exitPrice;

  @HiveField(11)
  final double? stopLoss;

  @HiveField(12)
  final double? takeProfit;

  @HiveField(13)
  final double fees;

  @HiveField(14)
  final List<String> tags;

  @HiveField(15)
  final String? notes;

  @HiveField(16)
  final String? chartScreenshotUrl;

  @HiveField(17)
  final double? rMultiple;

  @HiveField(18)
  final DateTime? createdAt;

  @HiveField(19)
  final DateTime? updatedAt;

  TradeHiveModel({
    required this.id,
    required this.userId,
    required this.symbol,
    required this.status,
    required this.assetClass,
    required this.tradeDirection,
    required this.entryDate,
    required this.entryPrice,
    required this.positionSize,
    this.exitDate,
    this.exitPrice,
    this.stopLoss,
    this.takeProfit,
    required this.fees,
    required this.tags,
    this.notes,
    this.chartScreenshotUrl,
    this.rMultiple,
    this.createdAt,
    this.updatedAt,
  });

  // Convert from Hive model to domain entity
  TradeEntity toEntity() {
    return TradeEntity(
      id: id,
      userId: userId,
      symbol: symbol,
      status: status,
      assetClass: assetClass,
      tradeDirection: tradeDirection,
      entryDate: entryDate,
      entryPrice: entryPrice,
      positionSize: positionSize,
      exitDate: exitDate,
      exitPrice: exitPrice,
      stopLoss: stopLoss,
      takeProfit: takeProfit,
      fees: fees,
      tags: tags,
      notes: notes,
      chartScreenshotUrl: chartScreenshotUrl,
      rMultiple: rMultiple,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  // Convert from domain entity to Hive model
  factory TradeHiveModel.fromEntity(TradeEntity entity) {
    return TradeHiveModel(
      id: entity.id,
      userId: entity.userId,
      symbol: entity.symbol,
      status: entity.status,
      assetClass: entity.assetClass,
      tradeDirection: entity.tradeDirection,
      entryDate: entity.entryDate,
      entryPrice: entity.entryPrice,
      positionSize: entity.positionSize,
      exitDate: entity.exitDate,
      exitPrice: entity.exitPrice,
      stopLoss: entity.stopLoss,
      takeProfit: entity.takeProfit,
      fees: entity.fees,
      tags: entity.tags,
      notes: entity.notes,
      chartScreenshotUrl: entity.chartScreenshotUrl,
      rMultiple: entity.rMultiple,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
