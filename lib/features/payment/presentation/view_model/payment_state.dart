// payment_state.dart
import 'package:equatable/equatable.dart';
import 'package:tradeverse/features/payment/domain/entity/payment_plan_entity.dart';
import 'package:tradeverse/features/payment/domain/entity/checkout_response_entity.dart';
import 'package:tradeverse/features/payment/domain/entity/verify_payment_entity.dart';

enum PaymentStatus { initial, loading, success, failure }

class PaymentState extends Equatable {
  final List<PaymentPlanEntity> plans;
  final PaymentPlanEntity? selectedPlan;
  final bool isYearly;
  final PaymentStatus status;
  final String? message;
  final CheckoutResponseEntity? checkoutResponse;
  final VerifyPaymentEntity? verifyResult;

  const PaymentState({
    this.plans = const [],
    this.selectedPlan,
    this.isYearly = false,
    this.status = PaymentStatus.initial,
    this.message,
    this.checkoutResponse,
    this.verifyResult,
  });

  PaymentState copyWith({
    List<PaymentPlanEntity>? plans,
    PaymentPlanEntity? selectedPlan,
    bool? isYearly,
    PaymentStatus? status,
    String? message,
    CheckoutResponseEntity? checkoutResponse,
    VerifyPaymentEntity? verifyResult,
  }) {
    return PaymentState(
      plans: plans ?? this.plans,
      selectedPlan: selectedPlan ?? this.selectedPlan,
      isYearly: isYearly ?? this.isYearly,
      status: status ?? this.status,
      message: message ?? this.message,
      checkoutResponse: checkoutResponse ?? this.checkoutResponse,
      verifyResult: verifyResult ?? this.verifyResult,
    );
  }

  @override
  List<Object?> get props => [
    plans,
    selectedPlan,
    isYearly,
    status,
    message,
    checkoutResponse,
    verifyResult,
  ];
}
