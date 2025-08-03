import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:tradeverse/core/error/failure.dart';
import 'package:tradeverse/features/auth/domain/repository/auth_repository.dart';
import 'package:tradeverse/features/auth/domain/use_case/reset_password_with_otp_use_case.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late MockAuthRepository mockRepository;
  late ResetPasswordWithOtpUsecase usecase;

  const tResetToken = 'resetToken123';
  const tNewPassword = 'newPassword!@#';
  final tParams = ResetPasswordWithOtpParams(
    resetToken: tResetToken,
    newPassword: tNewPassword,
  );

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = ResetPasswordWithOtpUsecase(repository: mockRepository);
  });

  test('ResetPasswordWithOtpParams props contains all fields', () {
    expect(tParams.props, [tResetToken, tNewPassword]);
  });

  test(
    'should return Right(void) when resetPasswordWithOtp succeeds',
    () async {
      // Arrange
      when(
        () => mockRepository.resetPasswordWithOtp(tResetToken, tNewPassword),
      ).thenAnswer((_) async => const Right(null));

      // Act
      final result = await usecase.call(tParams);

      // Assert
      expect(result, const Right(null));
      verify(
        () => mockRepository.resetPasswordWithOtp(tResetToken, tNewPassword),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test('should return Left(Failure) when resetPasswordWithOtp fails', () async {
    // Arrange
    final failure = ServerFailure(message: 'Reset password failed');
    when(
      () => mockRepository.resetPasswordWithOtp(tResetToken, tNewPassword),
    ).thenAnswer((_) async => Left(failure));

    // Act
    final result = await usecase.call(tParams);

    // Assert
    expect(result, Left(failure));
    verify(
      () => mockRepository.resetPasswordWithOtp(tResetToken, tNewPassword),
    ).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
