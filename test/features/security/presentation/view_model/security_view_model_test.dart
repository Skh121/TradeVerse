// test/features/security/presentation/bloc/security_view_model_test.dart

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tradeverse/core/error/failure.dart';
import 'package:tradeverse/features/security/domain/entity/security_entity.dart';
import 'package:tradeverse/features/security/domain/use_case/change_password_use_case.dart';
import 'package:tradeverse/features/security/domain/use_case/delete_account_use_case.dart';
import 'package:tradeverse/features/security/domain/use_case/export_data_use_case.dart';
import 'package:tradeverse/features/security/presentation/view_model/security_event.dart';
import 'package:tradeverse/features/security/presentation/view_model/security_state.dart';
import 'package:tradeverse/features/security/presentation/view_model/security_view_model.dart';

class MockChangePassword extends Mock implements ChangePassword {}

class MockDeleteAccount extends Mock implements DeleteAccount {}

class MockExportData extends Mock implements ExportData {}

class ChangePasswordParamsFake extends Fake implements ChangePasswordParams {}

void main() {
  setUpAll(() {
    registerFallbackValue(ChangePasswordParamsFake());
  });
  late SecurityViewModel viewModel;
  late MockChangePassword mockChangePassword;
  late MockDeleteAccount mockDeleteAccount;
  late MockExportData mockExportData;

  setUp(() {
    mockChangePassword = MockChangePassword();
    mockDeleteAccount = MockDeleteAccount();
    mockExportData = MockExportData();

    viewModel = SecurityViewModel(
      changePassword: mockChangePassword,
      deleteAccount: mockDeleteAccount,
      exportData: mockExportData,
    );
  });

  const testFailure = ServerFailure(message: 'Something went wrong');

  group('ChangePasswordEvent', () {
    blocTest<SecurityViewModel, SecurityState>(
      'emits [SecurityLoading, PasswordChangedSuccess] on success',
      build: () {
        when(() => mockChangePassword(any())).thenAnswer(
          (_) async =>
              const Right(SuccessMessageEntity(message: 'Password updated')),
        );
        return viewModel;
      },
      act:
          (bloc) => bloc.add(
            const ChangePasswordEvent(
              currentPassword: 'old',
              newPassword: 'new',
              confirmPassword: 'new',
            ),
          ),
      expect:
          () => [
            SecurityLoading(),
            const PasswordChangedSuccess(message: 'Password updated'),
          ],
    );

    blocTest<SecurityViewModel, SecurityState>(
      'emits [SecurityLoading, SecurityError] on failure',
      build: () {
        when(
          () => mockChangePassword(any()),
        ).thenAnswer((_) async => const Left(testFailure));
        return viewModel;
      },
      act:
          (bloc) => bloc.add(
            const ChangePasswordEvent(
              currentPassword: 'old',
              newPassword: 'new',
              confirmPassword: 'new',
            ),
          ),
      expect:
          () => [
            SecurityLoading(),
            const SecurityError(message: 'Something went wrong'),
          ],
    );
  });

  group('DeleteAccountEvent', () {
    blocTest<SecurityViewModel, SecurityState>(
      'emits [SecurityLoading, AccountDeletedSuccess] on success',
      build: () {
        when(() => mockDeleteAccount()).thenAnswer(
          (_) async =>
              const Right(SuccessMessageEntity(message: 'Account deleted')),
        );
        return viewModel;
      },
      act: (bloc) => bloc.add(DeleteAccountEvent()),
      expect:
          () => [
            SecurityLoading(),
            const AccountDeletedSuccess(message: 'Account deleted'),
          ],
    );

    blocTest<SecurityViewModel, SecurityState>(
      'emits [SecurityLoading, SecurityError] on failure',
      build: () {
        when(
          () => mockDeleteAccount(),
        ).thenAnswer((_) async => const Left(testFailure));
        return viewModel;
      },
      act: (bloc) => bloc.add(DeleteAccountEvent()),
      expect:
          () => [
            SecurityLoading(),
            const SecurityError(message: 'Something went wrong'),
          ],
    );
  });

  group('ExportDataEvent', () {
    final exported = UserDataExportEntity();

    blocTest<SecurityViewModel, SecurityState>(
      'emits [SecurityLoading, DataExportedSuccess] on success',
      build: () {
        when(() => mockExportData()).thenAnswer((_) async => Right(exported));
        return viewModel;
      },
      act: (bloc) => bloc.add(ExportDataEvent()),
      expect:
          () => [
            SecurityLoading(),
            DataExportedSuccess(exportedData: exported),
          ],
    );

    blocTest<SecurityViewModel, SecurityState>(
      'emits [SecurityLoading, SecurityError] on failure',
      build: () {
        when(
          () => mockExportData(),
        ).thenAnswer((_) async => const Left(testFailure));
        return viewModel;
      },
      act: (bloc) => bloc.add(ExportDataEvent()),
      expect:
          () => [
            SecurityLoading(),
            const SecurityError(message: 'Something went wrong'),
          ],
    );
  });
}
