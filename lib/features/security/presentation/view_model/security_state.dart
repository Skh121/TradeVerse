// lib/features/security/presentation/bloc/security_state.dart

import 'package:equatable/equatable.dart';
import 'package:tradeverse/features/security/domain/entity/security_entity.dart';

/// Base class for all Security states.
abstract class SecurityState extends Equatable {
  const SecurityState();

  @override
  List<Object> get props => [];
}

/// Initial state for the Security Bloc, indicating no operation is in progress.
class SecurityInitial extends SecurityState {}

/// State indicating that a security operation is currently loading.
class SecurityLoading extends SecurityState {}

/// State indicating that a password change was successful.
class PasswordChangedSuccess extends SecurityState {
  final String message;

  const PasswordChangedSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

/// State indicating that account deletion was successful.
class AccountDeletedSuccess extends SecurityState {
  final String message;

  const AccountDeletedSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

/// State indicating that data export was successful.
class DataExportedSuccess extends SecurityState {
  final UserDataExportEntity exportedData;

  const DataExportedSuccess({required this.exportedData});

  @override
  List<Object> get props => [exportedData];
}

/// State indicating that an error occurred during a security operation.
class SecurityError extends SecurityState {
  final String message;

  const SecurityError({required this.message});

  @override
  List<Object> get props => [message];
}
