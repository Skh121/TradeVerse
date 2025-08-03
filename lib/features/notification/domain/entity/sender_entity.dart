import 'package:equatable/equatable.dart';

class SenderEntity extends Equatable {
  final String id;
  final String fullName;

  const SenderEntity({required this.id, required this.fullName});

  @override
  List<Object?> get props => [id, fullName];
}
