// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_hive_models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecentTradeHiveModelAdapter extends TypeAdapter<RecentTradeHiveModel> {
  @override
  final int typeId = 3;

  @override
  RecentTradeHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecentTradeHiveModel(
      ticker: fields[0] as String,
      type: fields[1] as String,
      status: fields[2] as String,
      pnl: fields[3] as double,
      date: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, RecentTradeHiveModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.ticker)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.status)
      ..writeByte(3)
      ..write(obj.pnl)
      ..writeByte(4)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecentTradeHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ThisWeekSummaryHiveModelAdapter
    extends TypeAdapter<ThisWeekSummaryHiveModel> {
  @override
  final int typeId = 4;

  @override
  ThisWeekSummaryHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ThisWeekSummaryHiveModel(
      dayIndex: fields[0] as int,
      pnl: fields[1] as double,
      isProfit: fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ThisWeekSummaryHiveModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.dayIndex)
      ..writeByte(1)
      ..write(obj.pnl)
      ..writeByte(2)
      ..write(obj.isProfit);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThisWeekSummaryHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DashboardStatsHiveModelAdapter
    extends TypeAdapter<DashboardStatsHiveModel> {
  @override
  final int typeId = 5;

  @override
  DashboardStatsHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DashboardStatsHiveModel(
      totalPL: fields[0] as double,
      equityCurve: (fields[1] as List).cast<FlSpot>(),
      thisWeeksSummaries: (fields[2] as List).cast<ThisWeekSummaryHiveModel>(),
      recentTrades: (fields[3] as List).cast<RecentTradeHiveModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, DashboardStatsHiveModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.totalPL)
      ..writeByte(1)
      ..write(obj.equityCurve)
      ..writeByte(2)
      ..write(obj.thisWeeksSummaries)
      ..writeByte(3)
      ..write(obj.recentTrades);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DashboardStatsHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
