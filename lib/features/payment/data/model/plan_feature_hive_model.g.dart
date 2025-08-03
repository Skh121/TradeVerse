// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan_feature_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlanFeatureHiveModelAdapter extends TypeAdapter<PlanFeatureHiveModel> {
  @override
  final int typeId = 2;

  @override
  PlanFeatureHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlanFeatureHiveModel(
      text: fields[0] as String,
      included: fields[1] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, PlanFeatureHiveModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.text)
      ..writeByte(1)
      ..write(obj.included);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlanFeatureHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
