import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tradeverse/app/use_case/use_case.dart';
import 'package:tradeverse/features/auth/domain/repository/auth_repository.dart';
import '../../../../core/error/failure.dart';

class ResetPasswordWithOtpUsecase
    implements UseCaseWithParams<void, ResetPasswordWithOtpParams> {
  final IAuthRepository repository;

  ResetPasswordWithOtpUsecase({required this.repository});

  @override
  Future<Either<Failure, void>> call(ResetPasswordWithOtpParams params) async {
    return await repository.resetPasswordWithOtp(
      params.resetToken,
      params.newPassword,
    );
  }
}

class ResetPasswordWithOtpParams extends Equatable {
  final String resetToken;
  final String newPassword;

  const ResetPasswordWithOtpParams({
    required this.resetToken,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [resetToken, newPassword];
}
