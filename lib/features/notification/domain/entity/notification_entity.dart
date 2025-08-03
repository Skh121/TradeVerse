import 'package:equatable/equatable.dart';
import 'package:tradeverse/features/notification/domain/entity/sender_entity.dart';

class NotificationEntity extends Equatable {
  final String id;
  final String type;
  final String text;
  final String? link;
  final bool isRead;
  final DateTime createdAt;
  final SenderEntity? sender;

  const NotificationEntity({
    required this.id,
    required this.type,
    required this.text,
    this.link,
    required this.isRead,
    required this.createdAt,
    this.sender,
  });

  @override
  List<Object?> get props => [id, type, text, link, isRead, createdAt, sender];
}
