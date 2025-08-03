import 'package:equatable/equatable.dart';
import 'package:tradeverse/features/chat/domain/entity/user.dart';

class Conversation extends Equatable {
  final String id;
  final List<User> participants;
  final DateTime updatedAt;

  const Conversation({
    required this.id,
    required this.participants,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [id, participants, updatedAt];
}
