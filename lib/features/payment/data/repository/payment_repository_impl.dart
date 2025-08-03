import 'package:dartz/dartz.dart';
import 'package:tradeverse/core/error/failure.dart';
import 'package:tradeverse/features/payment/data/data_source/local_data_source/payment_local_data_source.dart';
import 'package:tradeverse/features/payment/data/data_source/remote_data_source/payment_remote_data_source.dart';
import 'package:tradeverse/features/payment/domain/entity/checkout_response_entity.dart';
import 'package:tradeverse/features/payment/domain/entity/payment_plan_entity.dart';
import 'package:tradeverse/features/payment/domain/entity/verify_payment_entity.dart';
import 'package:tradeverse/features/payment/domain/repository/payment_repository.dart';
import 'package:tradeverse/features/payment/domain/use_case/checkout_use_case.dart';

class PaymentRepositoryImpl implements IPaymentRepository {
  final PaymentRemoteDataSource remoteDataSource;
  final PaymentLocalDataSource localDataSource;

  PaymentRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<PaymentPlanEntity>>> getAllPlans() async {
    try {
      final remotePlans = await remoteDataSource.getAllPlans();

      // final hivePlans =
      //     remotePlans
      //         .map(
      //           (apiModel) => PaymentHiveModel.fromEntity(apiModel.toEntity()),
      //         )
      //         .toList();

      // await localDataSource.cachePlans(hivePlans);

      return Right(remotePlans.map((e) => e.toEntity()).toList());
    } catch (e) {
      try {
        final cachedPlans = await localDataSource.getCachedPlans();
        return Right(cachedPlans.map((e) => e.toEntity()).toList());
      } catch (_) {
        return const Left(
          ServerFailure(message: 'Failed to fetch payment plans'),
        );
      }
    }
  }

  @override
  Future<Either<Failure, CheckoutResponseEntity>> checkoutPlan(
    CheckoutParams params,
  ) async {
    try {
      print("Repository: Starting checkout with params: ${params.toJson()}");
      final response = await remoteDataSource.checkoutPlan(params);
      print("Repository: Checkout success with response: ${response.toJson()}");
      return Right(response.toEntity());
    } catch (e, stacktrace) {
      print("Repository: Checkout failed with error: $e");
      print(stacktrace);
      return const Left(ServerFailure(message: 'Checkout failed'));
    }
  }

  @override
  Future<Either<Failure, VerifyPaymentEntity>> verifyPayment(
    String sessionId,
    String email,
  ) async {
    try {
      final verifyResponse = await remoteDataSource.verifyPayment(
        sessionId,
        email,
      );
      return Right(verifyResponse.toEntity());
    } catch (e) {
      return const Left(ServerFailure(message: 'Payment verification failed'));
    }
  }
}
