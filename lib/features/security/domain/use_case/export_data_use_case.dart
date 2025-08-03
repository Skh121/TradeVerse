import 'package:dartz/dartz.dart';
import 'package:tradeverse/core/error/failure.dart';
import 'package:tradeverse/features/security/domain/entity/security_entity.dart';
import 'package:tradeverse/features/security/domain/repository/security_repository.dart';

/// Use case for exporting user data.
class ExportData {
  final ISecurityRepository repository;

  ExportData(this.repository);

  Future<Either<Failure, UserDataExportEntity>> call() async {
    return await repository.exportMyData();
  }
}
