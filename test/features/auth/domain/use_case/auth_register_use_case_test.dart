import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tradeverse/core/error/failure.dart';
import 'package:tradeverse/features/auth/domain/entity/user_entity.dart';
import 'package:tradeverse/features/auth/domain/repository/auth_repository.dart';
import 'package:tradeverse/features/auth/domain/use_case/auth_register_use_case.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late AuthRegisterUsecase usecase;
  late MockAuthRepository mockAuthRepository;

  // Register fallback value for UserEntity used in any()
  setUpAll(() {
    registerFallbackValue(UserEntity(email: '', fullName: '', password: ''));
  });

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = AuthRegisterUsecase(authRepository: mockAuthRepository);
  });

  const tParams = AuthRegisterParams(
    email: 'test@example.com',
    fullName: 'Test User',
    password: 'password123',
  );

  final tUserEntity = UserEntity(
    email: tParams.email,
    fullName: tParams.fullName,
    password: tParams.password,
  );

  group('AuthRegisterParams', () {
    test('initial constructor should create object with empty strings', () {
      const params = AuthRegisterParams.initial(
        email: '',
        fullName: '',
        password: '',
      );

      expect(params.email, '');
      expect(params.fullName, '');
      expect(params.password, '');
    });

    test('supports equality and hashCode', () {
      const p1 = AuthRegisterParams(
        email: 'a@b.com',
        fullName: 'User',
        password: 'pass',
      );
      const p2 = AuthRegisterParams(
        email: 'a@b.com',
        fullName: 'User',
        password: 'pass',
      );
      const p3 = AuthRegisterParams(
        email: 'diff@b.com',
        fullName: 'User',
        password: 'pass',
      );

      expect(p1, equals(p2));
      expect(p1.hashCode, equals(p2.hashCode));
      expect(p1 == p3, isFalse);
    });
  });

  group('AuthRegisterUsecase', () {
    test('should call repository createAccount and return Right(void)', () async {
      // Arrange
      when(
        () => mockAuthRepository.createAccount(any()),
      ).thenAnswer((_) async => const Right(null));

      // Act
      final result = await usecase(tParams);

      // Assert
      expect(result, const Right(null));

      final captured =
          verify(
                () => mockAuthRepository.createAccount(captureAny()),
              ).captured.single
              as UserEntity;
      expect(captured.email, tUserEntity.email);
      expect(captured.fullName, tUserEntity.fullName);
      expect(captured.password, tUserEntity.password);
      // If you have age in UserEntity and it should be checked, add here as well:
      // expect(captured.age, tUserEntity.age);

      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return Failure when repository createAccount fails', () async {
      // Arrange
      final tFailure = ApiFailure(message: "Failed Registering users");
      when(
        () => mockAuthRepository.createAccount(any()),
      ).thenAnswer((_) async => Left(tFailure));

      // Act
      final result = await usecase(tParams);

      // Assert
      expect(result, equals(Left(tFailure)));

      final captured =
          verify(
                () => mockAuthRepository.createAccount(captureAny()),
              ).captured.single
              as UserEntity;
      expect(captured.email, tUserEntity.email);
      expect(captured.fullName, tUserEntity.fullName);
      expect(captured.password, tUserEntity.password);
      // expect(captured.age, tUserEntity.age);

      verifyNoMoreInteractions(mockAuthRepository);
    });
  });
}
