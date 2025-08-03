import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tradeverse/features/auth/domain/repository/auth_repository.dart';
import 'package:tradeverse/features/auth/domain/use_case/logout_use_case.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late MockAuthRepository mockRepository;
  late LogoutUseCase useCase;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = LogoutUseCase(repository: mockRepository);
  });

  test('should call logout on repository once', () async {
    // Arrange
    when(() => mockRepository.logout()).thenAnswer((_) async {});

    // Act
    await useCase.call();

    // Assert
    verify(() => mockRepository.logout()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should propagate exception if repository.logout throws', () async {
    // Arrange
    when(() => mockRepository.logout()).thenThrow(Exception('Logout error'));

    // Act & Assert
    expect(() => useCase.call(), throwsA(isA<Exception>()));
    verify(() => mockRepository.logout()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
