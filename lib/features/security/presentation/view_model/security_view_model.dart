// lib/features/security/presentation/bloc/security_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradeverse/features/security/domain/use_case/change_password_use_case.dart';
import 'package:tradeverse/features/security/domain/use_case/delete_account_use_case.dart';
import 'package:tradeverse/features/security/domain/use_case/export_data_use_case.dart';
import 'security_event.dart';
import 'security_state.dart';

class SecurityViewModel extends Bloc<SecurityEvent, SecurityState> {
  final ChangePassword _changePassword;
  final DeleteAccount _deleteAccount;
  final ExportData _exportData;

  SecurityViewModel({
    required ChangePassword changePassword,
    required DeleteAccount deleteAccount,
    required ExportData exportData,
  }) : _changePassword = changePassword,
       _deleteAccount = deleteAccount,
       _exportData = exportData,
       super(SecurityInitial()) {
    // Change initial state to SecurityInitial
    on<ChangePasswordEvent>(_onChangePassword);
    on<DeleteAccountEvent>(_onDeleteAccount);
    on<ExportDataEvent>(_onExportData);
  }

  /// Handles the [ChangePasswordEvent].
  Future<void> _onChangePassword(
    ChangePasswordEvent event,
    Emitter<SecurityState> emit,
  ) async {
    emit(SecurityLoading());
    final params = ChangePasswordParams(
      currentPassword: event.currentPassword,
      newPassword: event.newPassword,
      confirmPassword: event.confirmPassword,
    );
    final result = await _changePassword(params);
    result.fold(
      (failure) => emit(SecurityError(message: failure.message)),
      (success) => emit(PasswordChangedSuccess(message: success.message)),
    );
  }

  /// Handles the [DeleteAccountEvent].
  Future<void> _onDeleteAccount(
    DeleteAccountEvent event,
    Emitter<SecurityState> emit,
  ) async {
    emit(SecurityLoading());
    final result = await _deleteAccount();
    result.fold(
      (failure) => emit(SecurityError(message: failure.message)),
      (success) => emit(AccountDeletedSuccess(message: success.message)),
    );
  }

  /// Handles the [ExportDataEvent].
  Future<void> _onExportData(
    ExportDataEvent event,
    Emitter<SecurityState> emit,
  ) async {
    emit(SecurityLoading());
    final result = await _exportData();
    result.fold(
      (failure) => emit(SecurityError(message: failure.message)),
      (exportedData) => emit(DataExportedSuccess(exportedData: exportedData)),
    );
  }
}
