import 'package:dartz/dartz.dart';
import 'package:tradeverse/core/error/failure.dart';
 
abstract interface class UseCaseWithParams<SuccessType, Params> {
  Future<Either<Failure, SuccessType>> call(Params params);
}
 
abstract interface class UseCaseWithoutParams<SuccessType> {
  Future<Either<Failure, SuccessType>> call();
}