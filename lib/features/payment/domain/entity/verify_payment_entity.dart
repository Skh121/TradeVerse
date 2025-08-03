import 'package:equatable/equatable.dart';

class VerifyPaymentEntity extends Equatable {
  final bool success;
  final String message;

  const VerifyPaymentEntity({required this.success, required this.message});

  @override
  List<Object?> get props => [success, message];
}
