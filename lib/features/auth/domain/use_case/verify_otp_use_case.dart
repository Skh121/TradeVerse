import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tradeverse/app/use_case/use_case.dart';
import 'package:tradeverse/features/auth/domain/repository/auth_repository.dart';
import '../../../../core/error/failure.dart';

class VerifyOtpUsecase implements UseCaseWithParams<String, VerifyOtpParams> {
  // Returns a resetToken string
  final IAuthRepository repository;

  VerifyOtpUsecase({required this.repository});

  @override
  Future<Either<Failure, String>> call(VerifyOtpParams params) async {
    return await repository.verifyOtp(params.email, params.otp);
  }
}

class VerifyOtpParams extends Equatable {
  final String email;
  final String otp;

  const VerifyOtpParams({required this.email, required this.otp});

  @override
  List<Object?> get props => [email, otp];
}
