import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tradeverse/app/use_case/use_case.dart';
import 'package:tradeverse/core/error/failure.dart';
import 'package:tradeverse/features/auth/domain/repository/auth_repository.dart';

class LoginParams extends Equatable {
  final String email;
  final String password;
 
  const LoginParams({required this.email, required this.password});
 
  const LoginParams.initial() : email = '', password = '';
  @override
  List<Object?> get props => [email, password];
}
 
class AuthLoginUsecase implements UseCaseWithParams<String, LoginParams> {
  final IAuthRepository _authRepository;
 
  AuthLoginUsecase({required IAuthRepository authRepository})
    : _authRepository = authRepository;
 
  @override
  Future<Either<Failure, String>> call(LoginParams params) async {
    return await _authRepository.loginToAccount(
      params.email,
      params.password,
    );
  }
}
 