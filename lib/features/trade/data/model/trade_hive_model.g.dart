// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trade_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TradeHiveModelAdapter extends TypeAdapter<TradeHiveModel> {
  @override
  final int typeId = 10;

  @override
  TradeHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TradeHiveModel(
      id: fields[0] as String,
      userId: fields[1] as String,
      symbol: fields[2] as String,
      status: fields[3] as String,
      assetClass: fields[4] as String,
      tradeDirection: fields[5] as String,
      entryDate: fields[6] as DateTime,
      entryPrice: fields[7] as double,
      positionSize: fields[8] as int,
      exitDate: fields[9] as DateTime?,
      exitPrice: fields[10] as double?,
      stopLoss: fields[11] as double?,
      takeProfit: fields[12] as double?,
      fees: fields[13] as double,
      tags: (fields[14] as List).cast<String>(),
      notes: fields[15] as String?,
      chartScreenshotUrl: fields[16] as String?,
      rMultiple: fields[17] as double?,
      createdAt: fields[18] as DateTime?,
      updatedAt: fields[19] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, TradeHiveModel obj) {
    writer
      ..writeByte(20)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.symbol)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.assetClass)
      ..writeByte(5)
      ..write(obj.tradeDirection)
      ..writeByte(6)
      ..write(obj.entryDate)
      ..writeByte(7)
      ..write(obj.entryPrice)
      ..writeByte(8)
      ..write(obj.positionSize)
      ..writeByte(9)
      ..write(obj.exitDate)
      ..writeByte(10)
      ..write(obj.exitPrice)
      ..writeByte(11)
      ..write(obj.stopLoss)
      ..writeByte(12)
      ..write(obj.takeProfit)
      ..writeByte(13)
      ..write(obj.fees)
      ..writeByte(14)
      ..write(obj.tags)
      ..writeByte(15)
      ..write(obj.notes)
      ..writeByte(16)
      ..write(obj.chartScreenshotUrl)
      ..writeByte(17)
      ..write(obj.rMultiple)
      ..writeByte(18)
      ..write(obj.createdAt)
      ..writeByte(19)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TradeHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
