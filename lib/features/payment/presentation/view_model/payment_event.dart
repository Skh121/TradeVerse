import 'package:equatable/equatable.dart';
import 'package:tradeverse/features/payment/domain/entity/payment_plan_entity.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object?> get props => [];
}

class LoadPaymentPlans extends PaymentEvent {}

class TogglePlanDuration extends PaymentEvent {
  final bool isYearly;

  const TogglePlanDuration(this.isYearly);

  @override
  List<Object?> get props => [isYearly];
}

class SelectPaymentPlan extends PaymentEvent {
  final PaymentPlanEntity selectedPlan;

  const SelectPaymentPlan(this.selectedPlan);

  @override
  List<Object?> get props => [selectedPlan];
}

class StartCheckout extends PaymentEvent {
  final String email;

  const StartCheckout(this.email);

  @override
  List<Object?> get props => [email];
}

class VerifyPayment extends PaymentEvent {
  final String sessionId;
  final String email;

  const VerifyPayment({required this.sessionId, required this.email});

  @override
  List<Object?> get props => [sessionId, email];
}
