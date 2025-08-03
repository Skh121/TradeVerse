import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tradeverse/core/error/failure.dart';
import 'package:tradeverse/features/auth/domain/repository/auth_repository.dart';
import 'package:tradeverse/features/auth/domain/use_case/verify_otp_use_case.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late MockAuthRepository mockRepository;
  late VerifyOtpUsecase usecase;

  const tEmail = 'test@example.com';
  const tOtp = '123456';
  const tResetToken = 'reset-token-xyz';
  final tParams = VerifyOtpParams(email: tEmail, otp: tOtp);

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = VerifyOtpUsecase(repository: mockRepository);
  });

  test('VerifyOtpParams props contains email and otp', () {
    expect(tParams.props, [tEmail, tOtp]);
  });

  test('should return reset token when OTP verification succeeds', () async {
    // Arrange
    when(
      () => mockRepository.verifyOtp(tEmail, tOtp),
    ).thenAnswer((_) async => const Right(tResetToken));

    // Act
    final result = await usecase.call(tParams);

    // Assert
    expect(result, const Right(tResetToken));
    verify(() => mockRepository.verifyOtp(tEmail, tOtp)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return Failure when OTP verification fails', () async {
    // Arrange
    final failure = ServerFailure(message: 'OTP verification failed');
    when(
      () => mockRepository.verifyOtp(tEmail, tOtp),
    ).thenAnswer((_) async => Left(failure));

    // Act
    final result = await usecase.call(tParams);

    // Assert
    expect(result, Left(failure));
    verify(() => mockRepository.verifyOtp(tEmail, tOtp)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
