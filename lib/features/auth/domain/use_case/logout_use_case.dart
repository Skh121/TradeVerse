import 'package:tradeverse/features/auth/domain/repository/auth_repository.dart';

class LogoutUseCase {
  final IAuthRepository repository;

  LogoutUseCase({required this.repository});

  Future<void> call() async {
    await repository.logout();
  }
}
