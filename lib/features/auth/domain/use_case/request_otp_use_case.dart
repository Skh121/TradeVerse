import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tradeverse/app/use_case/use_case.dart';
import 'package:tradeverse/features/auth/domain/repository/auth_repository.dart';
import '../../../../core/error/failure.dart';

class RequestOtpUsecase implements UseCaseWithParams<void, RequestOtpParams> {
  final IAuthRepository repository;

  RequestOtpUsecase({required this.repository});

  @override
  Future<Either<Failure, void>> call(RequestOtpParams params) async {
    try {
      return await repository.requestOtp(params.email);
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error'));
    }
  }
}

class RequestOtpParams extends Equatable {
  final String email;

  const RequestOtpParams({required this.email});

  @override
  List<Object?> get props => [email];
}
