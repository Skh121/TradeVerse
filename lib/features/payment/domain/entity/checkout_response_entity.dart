import 'package:equatable/equatable.dart';

class CheckoutResponseEntity extends Equatable {
  final String sessionId;
  final String checkoutUrl;

  const CheckoutResponseEntity({
    required this.sessionId,
    required this.checkoutUrl,
  });

  @override
  List<Object?> get props => [sessionId, checkoutUrl];
}
