import 'package:dartz/dartz.dart';
import 'package:tradeverse/core/error/failure.dart';
import 'package:tradeverse/features/profile/domain/entity/profile_entity.dart';
import 'package:tradeverse/features/profile/domain/repository/profile_repository.dart';

class GetProfileUseCase {
  final IProfileRepository _repository;

  GetProfileUseCase(this._repository);

  Future<Either<Failure, ProfileEntity>> call() async {
    return await _repository.getMyProfile();
  }
}
