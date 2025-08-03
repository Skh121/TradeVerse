import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tradeverse/features/notification/domain/entity/sender_entity.dart';

part 'sender_api_model.g.dart';

@JsonSerializable()
class SenderApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String id;
  final String fullName;

  const SenderApiModel({required this.id, required this.fullName});

  factory SenderApiModel.fromJson(Map<String, dynamic> json) =>
      _$SenderApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$SenderApiModelToJson(this);

  SenderEntity toEntity() {
    return SenderEntity(id: id, fullName: fullName);
  }

  factory SenderApiModel.fromEntity(SenderEntity entity) {
    return SenderApiModel(id: entity.id, fullName: entity.fullName);
  }

  @override
  List<Object?> get props => [id, fullName];
}
