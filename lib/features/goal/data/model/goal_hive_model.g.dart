// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GoalHiveModelAdapter extends TypeAdapter<GoalHiveModel> {
  @override
  final int typeId = 6;

  @override
  GoalHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GoalHiveModel(
      id: fields[0] as String,
      type: fields[1] as String,
      period: fields[2] as String,
      targetValue: fields[3] as double,
      progress: fields[4] as double,
      startDate: fields[5] as DateTime,
      endDate: fields[6] as DateTime,
      achieved: fields[7] as bool,
      createdAt: fields[8] as DateTime?,
      updatedAt: fields[9] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, GoalHiveModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.period)
      ..writeByte(3)
      ..write(obj.targetValue)
      ..writeByte(4)
      ..write(obj.progress)
      ..writeByte(5)
      ..write(obj.startDate)
      ..writeByte(6)
      ..write(obj.endDate)
      ..writeByte(7)
      ..write(obj.achieved)
      ..writeByte(8)
      ..write(obj.createdAt)
      ..writeByte(9)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GoalHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
