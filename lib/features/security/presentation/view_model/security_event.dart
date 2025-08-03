// lib/features/security/presentation/bloc/security_event.dart

import 'package:equatable/equatable.dart';

/// Base class for all Security events.
abstract class SecurityEvent extends Equatable {
  const SecurityEvent();

  @override
  List<Object> get props => [];
}

/// Event to trigger a password change.
class ChangePasswordEvent extends SecurityEvent {
  final String currentPassword;
  final String newPassword;
  final String confirmPassword;

  const ChangePasswordEvent({
    required this.currentPassword,
    required this.newPassword,
    required this.confirmPassword,
  });

  @override
  List<Object> get props => [currentPassword, newPassword, confirmPassword];
}

/// Event to trigger account deletion.
class DeleteAccountEvent extends SecurityEvent {}

/// Event to trigger data export.
class ExportDataEvent extends SecurityEvent {}
