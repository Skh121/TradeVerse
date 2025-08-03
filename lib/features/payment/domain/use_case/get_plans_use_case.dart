import 'package:dartz/dartz.dart';
import 'package:tradeverse/core/error/failure.dart';
import 'package:tradeverse/app/use_case/use_case.dart';
import 'package:tradeverse/features/payment/domain/entity/payment_plan_entity.dart';
import 'package:tradeverse/features/payment/domain/repository/payment_repository.dart';

class GetPlansUseCase implements UseCaseWithoutParams<List<PaymentPlanEntity>> {
  final IPaymentRepository _paymentRepository;

  GetPlansUseCase({required IPaymentRepository paymentRepository})
    : _paymentRepository = paymentRepository;

  @override
  Future<Either<Failure, List<PaymentPlanEntity>>> call() async {
    return await _paymentRepository.getAllPlans();
  }
}
