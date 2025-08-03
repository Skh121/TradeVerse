import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tradeverse/core/error/failure.dart';
import 'package:tradeverse/app/use_case/use_case.dart';
import 'package:tradeverse/features/payment/domain/entity/verify_payment_entity.dart';
import 'package:tradeverse/features/payment/domain/repository/payment_repository.dart';

class VerifyPaymentParams extends Equatable {
  final String sessionId;
  final String email;

  const VerifyPaymentParams({required this.sessionId, required this.email});

  @override
  List<Object?> get props => [sessionId, email];
}

class VerifyPaymentUseCase
    implements UseCaseWithParams<VerifyPaymentEntity, VerifyPaymentParams> {
  final IPaymentRepository _paymentRepository;

  VerifyPaymentUseCase({required IPaymentRepository paymentRepository})
    : _paymentRepository = paymentRepository;

  @override
  Future<Either<Failure, VerifyPaymentEntity>> call(
    VerifyPaymentParams params,
  ) async {
    return await _paymentRepository.verifyPayment(
      params.sessionId,
      params.email,
    );
  }
}
