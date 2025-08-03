import 'package:hive_flutter/hive_flutter.dart';
import 'package:tradeverse/app/constant/hive/hive_table_constant.dart';
import 'trade_hive_model.dart';
import 'package:tradeverse/features/trade/domain/entity/trade_entity.dart';

part 'paginated_trade_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.paginatedTradeTableId)
class PaginatedTradeHiveModel extends HiveObject {
  @HiveField(0)
  final List<TradeHiveModel> trades;

  @HiveField(1)
  final int currentPage;

  @HiveField(2)
  final int totalPages;

  @HiveField(3)
  final int totalTrades;

  PaginatedTradeHiveModel({
    required this.trades,
    required this.currentPage,
    required this.totalPages,
    required this.totalTrades,
  });

  PaginatedTradesEntity toEntity() {
    return PaginatedTradesEntity(
      trades: trades.map((e) => e.toEntity()).toList(),
      currentPage: currentPage,
      totalPages: totalPages,
      totalTrades: totalTrades,
    );
  }

  factory PaginatedTradeHiveModel.fromEntity(PaginatedTradesEntity entity) {
    return PaginatedTradeHiveModel(
      trades: entity.trades.map((e) => TradeHiveModel.fromEntity(e)).toList(),
      currentPage: entity.currentPage,
      totalPages: entity.totalPages,
      totalTrades: entity.totalTrades,
    );
  }
}
