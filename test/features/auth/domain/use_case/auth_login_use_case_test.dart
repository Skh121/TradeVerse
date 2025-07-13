import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tradeverse/core/error/failure.dart';
import 'package:tradeverse/features/auth/domain/repository/auth_repository.dart';
import 'package:tradeverse/features/auth/domain/use_case/auth_login_use_case.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late AuthLoginUsecase authLoginUsecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    authLoginUsecase = AuthLoginUsecase(authRepository: mockAuthRepository);
  });

  const testEmail = 'test@example.com';
  const testPassword = 'password123';
  const testToken = 'mocked_token';
  const loginParams = LoginParams(email: testEmail, password: testPassword);

  test('should return token string when login is successful', () async {
    when(
      () => mockAuthRepository.loginToAccount(testEmail, testPassword),
    ).thenAnswer((_) async => const Right(testToken));

    final result = await authLoginUsecase(loginParams);

    expect(result, const Right(testToken));
    verify(
      () => mockAuthRepository.loginToAccount(testEmail, testPassword),
    ).called(1);
    verifyNoMoreInteractions(mockAuthRepository);
  });

  test('should return failure when login fails', () async {
    final failure = ApiFailure(message: 'Invalid credentials');
    when(
      () => mockAuthRepository.loginToAccount(testEmail, testPassword),
    ).thenAnswer((_) async => Left(failure));

    final result = await authLoginUsecase(loginParams);

    expect(result, Left(failure));
    verify(
      () => mockAuthRepository.loginToAccount(testEmail, testPassword),
    ).called(1);
    verifyNoMoreInteractions(mockAuthRepository);
  });

  test(
    'should call repository with empty credentials when LoginParams.initial is used',
    () async {
      const emptyParams = LoginParams.initial();
      when(
        () => mockAuthRepository.loginToAccount('', ''),
      ).thenAnswer((_) async => const Right('empty_token'));

      final result = await authLoginUsecase(emptyParams);

      expect(result, const Right('empty_token'));
      verify(() => mockAuthRepository.loginToAccount('', '')).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    },
  );

  test('should handle login with whitespace-only credentials', () async {
    const whitespaceParams = LoginParams(email: ' ', password: ' ');
    when(
      () => mockAuthRepository.loginToAccount(' ', ' '),
    ).thenAnswer((_) async => const Right('whitespace_token'));

    final result = await authLoginUsecase(whitespaceParams);

    expect(result, const Right('whitespace_token'));
    verify(() => mockAuthRepository.loginToAccount(' ', ' ')).called(1);
    verifyNoMoreInteractions(mockAuthRepository);
  });

  test('LoginParams equality should match props correctly', () {
    const p1 = LoginParams(email: 'a@b.com', password: '123');
    const p2 = LoginParams(email: 'a@b.com', password: '123');
    const p3 = LoginParams(email: 'x@b.com', password: '123');
    const p4 = LoginParams(email: 'a@b.com', password: 'x');

    expect(p1, p2);
    expect(p1 == p3, false);
    expect(p1 == p4, false);
  });

  test('LoginParams.initial constructor sets empty values', () {
    const initial = LoginParams.initial();

    expect(initial.email, '');
    expect(initial.password, '');
    expect(initial, const LoginParams(email: '', password: ''));
  });
}
