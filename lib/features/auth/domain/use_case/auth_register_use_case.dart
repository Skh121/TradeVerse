import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tradeverse/app/use_case/use_case.dart';
import 'package:tradeverse/core/error/failure.dart';
import 'package:tradeverse/features/auth/domain/entity/user_entity.dart';
import 'package:tradeverse/features/auth/domain/repository/auth_repository.dart';

class AuthRegisterParams extends Equatable {
  final String email;
  final String fullName;
  final String password;
 
  const AuthRegisterParams({
    required this.email,
    required this.fullName,
    required this.password,
  });
 
  const AuthRegisterParams.initial({
    required this.email,
    required this.fullName,
    required this.password,
  });
 
  @override
  List<Object?> get props => [email, fullName, password];
}
 
 
class AuthRegisterUsecase implements UseCaseWithParams<void, AuthRegisterParams>{
 
  final IAuthRepository _authRepository;
 
  AuthRegisterUsecase({ required IAuthRepository authRepository}) : _authRepository = authRepository;
 
  @override
  Future<Either<Failure, void>> call(AuthRegisterParams params) {
    final userEntity = UserEntity(
      email: params.email,
      fullName: params.fullName,
      password: params.password,
    );

    return _authRepository.createAccount(userEntity);
  }
}