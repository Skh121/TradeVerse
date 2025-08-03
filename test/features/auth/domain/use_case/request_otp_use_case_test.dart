import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:tradeverse/core/error/failure.dart';
import 'package:tradeverse/features/auth/domain/repository/auth_repository.dart';
import 'package:tradeverse/features/auth/domain/use_case/request_otp_use_case.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late MockAuthRepository mockRepository;
  late RequestOtpUsecase usecase;

  const tEmail = 'test@example.com';
  final tParams = RequestOtpParams(email: tEmail);

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = RequestOtpUsecase(repository: mockRepository);
  });

  test('RequestOtpParams props should contain email', () {
    expect(tParams.props, [tEmail]);
  });

  test('should return Right(void) when requestOtp succeeds', () async {
    // Arrange
    when(
      () => mockRepository.requestOtp(tEmail),
    ).thenAnswer((_) async => const Right(null));

    // Act
    final result = await usecase.call(tParams);

    // Assert
    expect(result, const Right(null));
    verify(() => mockRepository.requestOtp(tEmail)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return Left(Failure) when requestOtp fails', () async {
    // Arrange
    final failure = ServerFailure(message: 'Failed to send OTP');
    when(
      () => mockRepository.requestOtp(tEmail),
    ).thenAnswer((_) async => Left(failure));

    // Act
    final result = await usecase.call(tParams);

    // Assert
    expect(result, Left(failure));
    verify(() => mockRepository.requestOtp(tEmail)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test(
    'should return Left(ServerFailure) when repository throws exception',
    () async {
      // Arrange
      when(() => mockRepository.requestOtp(tEmail)).thenThrow(Exception());

      // Act
      final result = await usecase.call(tParams);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('Expected a failure'),
      );
      verify(() => mockRepository.requestOtp(tEmail)).called(1);
    },
  );
}
