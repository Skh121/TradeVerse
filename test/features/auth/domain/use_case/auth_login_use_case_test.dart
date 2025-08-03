import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tradeverse/core/error/failure.dart';
import 'package:tradeverse/features/auth/domain/entity/user_entity.dart';
import 'package:tradeverse/features/auth/domain/repository/auth_repository.dart';
import 'package:tradeverse/features/auth/domain/use_case/auth_login_use_case.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late MockAuthRepository mockRepository;
  late AuthLoginUsecase usecase;

  const tEmail = 'test@example.com';
  const tPassword = 'password123';
  final tParams = LoginParams(email: tEmail, password: tPassword);
  final tUser = UserEntity(
    id: '1',
    fullName: 'Test User',
    email: tEmail,
    password: tPassword,
    token: 'mock_token',
    role: 'member',
  );

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = AuthLoginUsecase(authRepository: mockRepository);
  });

  test('UserEntity props contains all fields', () {
    expect(tUser.props, [
      '1',
      'Test User',
      tEmail,
      tPassword,
      'mock_token',
      'member',
    ]);
  });

  test('LoginParams props contains email and password', () {
    expect(tParams.props, [tEmail, tPassword]);
  });

  test('should return UserEntity when login is successful', () async {
    when(
      () => mockRepository.loginToAccount(tEmail, tPassword),
    ).thenAnswer((_) async => Right(tUser));

    final result = await usecase(tParams);

    expect(result, Right(tUser));
    verify(() => mockRepository.loginToAccount(tEmail, tPassword)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return Failure when login fails from repository', () async {
    final failure = ServerFailure(message: 'Invalid credentials');
    when(
      () => mockRepository.loginToAccount(tEmail, tPassword),
    ).thenAnswer((_) async => Left(failure));

    final result = await usecase(tParams);

    expect(result, Left(failure));
    verify(() => mockRepository.loginToAccount(tEmail, tPassword)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return ServerFailure when Exception is thrown', () async {
    when(
      () => mockRepository.loginToAccount(tEmail, tPassword),
    ).thenThrow(Exception('Network error'));

    final result = await usecase(tParams);

    expect(result, isA<Left<Failure, UserEntity>>());
    final failure = (result as Left).value as ServerFailure;
    expect(failure.message, contains('Network error'));
    verify(() => mockRepository.loginToAccount(tEmail, tPassword)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test(
    'should return ServerFailure when non-Exception error is thrown',
    () async {
      when(
        () => mockRepository.loginToAccount(tEmail, tPassword),
      ).thenThrow('Unexpected String error');

      final result = await usecase(tParams);

      expect(result, isA<Left<Failure, UserEntity>>());
      final failure = (result as Left).value as ServerFailure;
      expect(failure.message, contains('Unexpected String error'));
      verify(() => mockRepository.loginToAccount(tEmail, tPassword)).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );
}
