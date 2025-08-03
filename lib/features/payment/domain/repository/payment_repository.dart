import 'package:dartz/dartz.dart';
import 'package:tradeverse/core/error/failure.dart';
import 'package:tradeverse/features/payment/domain/entity/checkout_response_entity.dart';
import 'package:tradeverse/features/payment/domain/entity/payment_plan_entity.dart';
import 'package:tradeverse/features/payment/domain/entity/verify_payment_entity.dart';
import 'package:tradeverse/features/payment/domain/use_case/checkout_use_case.dart';

abstract interface class IPaymentRepository {
  Future<Either<Failure, List<PaymentPlanEntity>>> getAllPlans();
  Future<Either<Failure, CheckoutResponseEntity>> checkoutPlan(
    CheckoutParams params,
  );
  Future<Either<Failure, VerifyPaymentEntity>> verifyPayment(
    String sessionId,
    String email,
  );
}
