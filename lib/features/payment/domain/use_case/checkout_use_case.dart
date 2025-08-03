import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tradeverse/core/error/failure.dart';
import 'package:tradeverse/app/use_case/use_case.dart';
import 'package:tradeverse/features/payment/domain/entity/checkout_response_entity.dart';
import 'package:tradeverse/features/payment/domain/repository/payment_repository.dart';

class CheckoutParams extends Equatable {
  final String name;
  final double monthlyPrice;
  final double yearlyPrice;
  final bool isYearly;
  final String email;
  final String clientUrl;

  const CheckoutParams({
    required this.name,
    required this.monthlyPrice,
    required this.yearlyPrice,
    required this.isYearly,
    required this.email,
    required this.clientUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      "plan": {
        "name": name,
        "monthlyPrice": monthlyPrice,
        "yearlyPrice": yearlyPrice,
      },
      "isYearly": isYearly,
      "email": email,
      "clientUrl": clientUrl,
    };
  }

  @override
  List<Object?> get props => [
    name,
    monthlyPrice,
    yearlyPrice,
    isYearly,
    email,
    clientUrl,
  ];
}

class CheckoutUseCase
    implements UseCaseWithParams<CheckoutResponseEntity, CheckoutParams> {
  final IPaymentRepository _paymentRepository;

  CheckoutUseCase({required IPaymentRepository paymentRepository})
    : _paymentRepository = paymentRepository;

  @override
  Future<Either<Failure, CheckoutResponseEntity>> call(
    CheckoutParams params,
  ) async {
    return await _paymentRepository.checkoutPlan(params);
  }
}
