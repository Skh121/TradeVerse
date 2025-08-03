import 'package:json_annotation/json_annotation.dart';
import 'package:tradeverse/features/dashboard/domain/entity/recent_trade_entity.dart';

part 'recent_trade_api_model.g.dart';

@JsonSerializable() // This annotation enables code generation for JSON serialization
class RecentTradeApiModel extends RecentTradeEntity {
  @JsonKey(name: 'status')
  final String? statusModel;
  const RecentTradeApiModel({
    required super.ticker,
    required super.type,
    this.statusModel,
    required super.pnl,
    required super.date,
  }): super(
          // When calling the super constructor (RecentTradeEntity),
          // provide a default value (e.g., an empty string) if statusModel is null.
          status: statusModel ?? '', // <<< CRITICAL: Handle null status here
        );

  // Factory constructor to deserialize JSON into a RecentTradeApiModel instance.
  // This now calls the auto-generated function.
  factory RecentTradeApiModel.fromJson(Map<String, dynamic> json) =>
      _$RecentTradeApiModelFromJson(json);

  // Method to serialize a RecentTradeApiModel instance into JSON.
  // This now calls the auto-generated function.
  @override // Keep @override because it overrides a method from Equatable implicitly (though not toJson specifically)
  Map<String, dynamic> toJson() => _$RecentTradeApiModelToJson(this);

  // You can also add a toEntity() method for explicit conversion,
  // although since RecentTradeApiModel already extends RecentTradeEntity,
  // it can often be used directly as an entity.
  // This is for consistency with CheckoutResponseModel's pattern.
  RecentTradeEntity toEntity() {
    return RecentTradeEntity(
      ticker: ticker,
      type: type,
      status: statusModel ?? "",
      pnl: pnl,
      date: date,
    );
  }
}
