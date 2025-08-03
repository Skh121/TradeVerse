import 'package:tradeverse/features/security/data/model/security_api_model.dart';

/// Abstract interface for the remote data source for security operations.
abstract class ISecurityDataSource {
  /// Calls the API to change the user's password.
  Future<SuccessMessageModel> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  });

  /// Calls the API to delete the user's account.
  Future<SuccessMessageModel> deleteMyAccount();

  /// Calls the API to export all user data.
  Future<UserDataExportModel> exportMyData();
}
