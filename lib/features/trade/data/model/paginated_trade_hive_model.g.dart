// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_trade_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PaginatedTradeHiveModelAdapter
    extends TypeAdapter<PaginatedTradeHiveModel> {
  @override
  final int typeId = 11;

  @override
  PaginatedTradeHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PaginatedTradeHiveModel(
      trades: (fields[0] as List).cast<TradeHiveModel>(),
      currentPage: fields[1] as int,
      totalPages: fields[2] as int,
      totalTrades: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, PaginatedTradeHiveModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.trades)
      ..writeByte(1)
      ..write(obj.currentPage)
      ..writeByte(2)
      ..write(obj.totalPages)
      ..writeByte(3)
      ..write(obj.totalTrades);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaginatedTradeHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
