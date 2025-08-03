// lib/features/security/presentation/pages/security_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradeverse/features/security/domain/entity/security_entity.dart';
import 'package:tradeverse/features/security/presentation/view_model/security_event.dart';
import 'package:tradeverse/features/security/presentation/view_model/security_state.dart';
import 'package:tradeverse/features/security/presentation/view_model/security_view_model.dart';
import 'package:intl/intl.dart'; // For date formatting

class SecurityView extends StatefulWidget {
  const SecurityView({super.key});

  @override
  State<SecurityView> createState() => _SecurityViewState();
}

class _SecurityViewState extends State<SecurityView> {
  final _changePasswordFormKey = GlobalKey<FormState>();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }

  /// Helper method to build consistent TextFormFields
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.black), // Black text input
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.grey), // Grey label
        filled: true,
        fillColor: Colors.white, // White background for text field
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey), // Grey border
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.blue), // Blue focus border
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red), // Red error border
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
      validator: validator,
    );
  }

  /// Shows a confirmation dialog for account deletion.
  Future<void> _showDeleteConfirmationDialog() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text(
            'Delete Account',
            style: TextStyle(color: Colors.black),
          ),
          content: const Text(
            'Are you sure you want to permanently delete your account? This action cannot be undone.',
            style: TextStyle(color: Colors.black87),
          ),
          backgroundColor: Colors.white,
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      // Dispatch DeleteAccountEvent if confirmed
      context.read<SecurityViewModel>().add(DeleteAccountEvent());
    }
  }

  /// Shows a dialog with exported data.
  void _showExportedDataDialog(UserDataExportEntity data) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text(
            'Exported Data',
            style: TextStyle(color: Colors.black),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // To make the dialog content wrap
              children: [
                Text(
                  'User:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  '  ID: ${data.user?.id ?? 'N/A'}',
                  style: const TextStyle(color: Colors.black),
                ),
                Text(
                  '  Full Name: ${data.user?.fullName ?? 'N/A'}',
                  style: const TextStyle(color: Colors.black),
                ),
                Text(
                  '  Email: ${data.user?.email ?? 'N/A'}',
                  style: const TextStyle(color: Colors.black),
                ),
                Text(
                  '  Role: ${data.user?.role ?? 'N/A'}',
                  style: const TextStyle(color: Colors.black),
                ),
                Text(
                  '  Created At: ${data.user?.createdAt != null ? formatter.format(data.user!.createdAt!) : 'N/A'}',
                  style: const TextStyle(color: Colors.black),
                ),
                Text(
                  '  Updated At: ${data.user?.updatedAt != null ? formatter.format(data.user!.updatedAt!) : 'N/A'}',
                  style: const TextStyle(color: Colors.black),
                ),
                const SizedBox(height: 10),

                Text(
                  'Profile:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  '  ID: ${data.profile?.id ?? 'N/A'}',
                  style: const TextStyle(color: Colors.black),
                ),
                Text(
                  '  User ID: ${data.profile?.userId ?? 'N/A'}',
                  style: const TextStyle(color: Colors.black),
                ),
                Text(
                  '  First Name: ${data.profile?.firstName ?? 'N/A'}',
                  style: const TextStyle(color: Colors.black),
                ),
                Text(
                  '  Last Name: ${data.profile?.lastName ?? 'N/A'}',
                  style: const TextStyle(color: Colors.black),
                ),
                Text(
                  '  Bio: ${data.profile?.bio ?? 'N/A'}',
                  style: const TextStyle(color: Colors.black),
                ),
                Text(
                  '  Avatar: ${data.profile?.avatar ?? 'N/A'}',
                  style: const TextStyle(color: Colors.black),
                ),
                Text(
                  '  Subscription ID: ${data.profile?.subscriptionId ?? 'N/A'}',
                  style: const TextStyle(color: Colors.black),
                ),
                Text(
                  '  Created At: ${data.profile?.createdAt != null ? formatter.format(data.profile!.createdAt!) : 'N/A'}',
                  style: const TextStyle(color: Colors.black),
                ),
                Text(
                  '  Updated At: ${data.profile?.updatedAt != null ? formatter.format(data.profile!.updatedAt!) : 'N/A'}',
                  style: const TextStyle(color: Colors.black),
                ),
                const SizedBox(height: 10),

                Text(
                  'Subscription:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  '  ID: ${data.subscription?.id ?? 'N/A'}',
                  style: const TextStyle(color: Colors.black),
                ),
                Text(
                  '  User ID: ${data.subscription?.userId ?? 'N/A'}',
                  style: const TextStyle(color: Colors.black),
                ),
                Text(
                  '  Plan: ${data.subscription?.plan ?? 'N/A'}',
                  style: const TextStyle(color: Colors.black),
                ),
                Text(
                  '  Billing Cycle: ${data.subscription?.billingCycle ?? 'N/A'}',
                  style: const TextStyle(color: Colors.black),
                ),
                Text(
                  '  Price: \$${data.subscription?.price?.toStringAsFixed(2) ?? 'N/A'}',
                  style: const TextStyle(color: Colors.black),
                ),
                Text(
                  '  Status: ${data.subscription?.status ?? 'N/A'}',
                  style: const TextStyle(color: Colors.black),
                ),
                Text(
                  '  Start Date: ${data.subscription?.startDate != null ? formatter.format(data.subscription!.startDate!) : 'N/A'}',
                  style: const TextStyle(color: Colors.black),
                ),
                Text(
                  '  End Date: ${data.subscription?.endDate != null ? formatter.format(data.subscription!.endDate!) : 'N/A'}',
                  style: const TextStyle(color: Colors.black),
                ),
                Text(
                  '  Created At: ${data.subscription?.createdAt != null ? formatter.format(data.subscription!.createdAt!) : 'N/A'}',
                  style: const TextStyle(color: Colors.black),
                ),
                Text(
                  '  Updated At: ${data.subscription?.updatedAt != null ? formatter.format(data.subscription!.updatedAt!) : 'N/A'}',
                  style: const TextStyle(color: Colors.black),
                ),
                const SizedBox(height: 10),

                const Text(
                  'Payments:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                if (data.payments != null && data.payments!.isNotEmpty)
                  ...data.payments!.map(
                    (p) => Padding(
                      padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '  ID: ${p.id}',
                            style: const TextStyle(color: Colors.black),
                          ),
                          Text(
                            '  User ID: ${p.userId}',
                            style: const TextStyle(color: Colors.black),
                          ),
                          Text(
                            '  Subscription ID: ${p.subscriptionId}',
                            style: const TextStyle(color: Colors.black),
                          ),
                          Text(
                            '  Amount: \$${p.amount?.toStringAsFixed(2)}',
                            style: const TextStyle(color: Colors.black),
                          ),
                          Text(
                            '  Currency: ${p.currency}',
                            style: const TextStyle(color: Colors.black),
                          ),
                          Text(
                            '  Method: ${p.paymentMethod}',
                            style: const TextStyle(color: Colors.black),
                          ),
                          Text(
                            '  Status: ${p.status}',
                            style: const TextStyle(color: Colors.black),
                          ),
                          Text(
                            '  Created At: ${p.createdAt != null ? formatter.format(p.createdAt!) : 'N/A'}',
                            style: const TextStyle(color: Colors.black),
                          ),
                          Text(
                            '  Updated At: ${p.updatedAt != null ? formatter.format(p.updatedAt!) : 'N/A'}',
                            style: const TextStyle(color: Colors.black),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  )
                else
                  const Text(
                    '  No payment data.',
                    style: TextStyle(color: Colors.black),
                  ),
                const SizedBox(height: 10),

                const Text(
                  'Trades:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                if (data.trades != null && data.trades!.isNotEmpty)
                  ...data.trades!.map(
                    (t) => Padding(
                      padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '  ID: ${t.id}',
                            style: const TextStyle(color: Colors.black),
                          ),
                          Text(
                            '  User ID: ${t.userId}',
                            style: const TextStyle(color: Colors.black),
                          ),
                          Text(
                            '  Symbol: ${t.symbol}',
                            style: const TextStyle(color: Colors.black),
                          ),
                          Text(
                            '  Status: ${t.status}',
                            style: const TextStyle(color: Colors.black),
                          ),
                          Text(
                            '  Asset Class: ${t.assetClass}',
                            style: const TextStyle(color: Colors.black),
                          ),
                          Text(
                            '  Direction: ${t.tradeDirection}',
                            style: const TextStyle(color: Colors.black),
                          ),
                          Text(
                            '  Entry Date: ${t.entryDate != null ? formatter.format(t.entryDate!) : 'N/A'}',
                            style: const TextStyle(color: Colors.black),
                          ),
                          Text(
                            '  Entry Price: ${t.entryPrice}',
                            style: const TextStyle(color: Colors.black),
                          ),
                          Text(
                            '  Position Size: ${t.positionSize}',
                            style: const TextStyle(color: Colors.black),
                          ),
                          Text(
                            '  Exit Date: ${t.exitDate != null ? formatter.format(t.exitDate!) : 'N/A'}',
                            style: const TextStyle(color: Colors.black),
                          ),
                          Text(
                            '  Exit Price: ${t.exitPrice}',
                            style: const TextStyle(color: Colors.black),
                          ),
                          Text(
                            '  Fees: ${t.fees}',
                            style: const TextStyle(color: Colors.black),
                          ),
                          Text(
                            '  Profit/Loss: ${t.profitLoss.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '  Tags: ${t.tags?.join(', ') ?? 'N/A'}',
                            style: const TextStyle(color: Colors.black),
                          ),
                          Text(
                            '  Notes: ${t.notes ?? 'N/A'}',
                            style: const TextStyle(color: Colors.black),
                          ),
                          Text(
                            '  Chart URL: ${t.chartScreenshotUrl ?? 'N/A'}',
                            style: const TextStyle(color: Colors.black),
                          ),
                          Text(
                            '  Created At: ${t.createdAt != null ? formatter.format(t.createdAt!) : 'N/A'}',
                            style: const TextStyle(color: Colors.black),
                          ),
                          Text(
                            '  Updated At: ${t.updatedAt != null ? formatter.format(t.updatedAt!) : 'N/A'}',
                            style: const TextStyle(color: Colors.black),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  )
                else
                  const Text(
                    '  No trade data.',
                    style: TextStyle(color: Colors.black),
                  ),
              ],
            ),
          ),
          backgroundColor: Colors.white,
          actions: <Widget>[
            TextButton(
              child: const Text('Close', style: TextStyle(color: Colors.blue)),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // White theme
      appBar: AppBar(
        title: const Text(
          'Security Settings',
          style: TextStyle(color: Colors.black), // Black text for app bar title
        ),
        backgroundColor: Colors.white, // White app bar
        elevation: 0, // No shadow for app bar
        iconTheme: const IconThemeData(color: Colors.black), // Black back arrow
      ),
      body: BlocConsumer<SecurityViewModel, SecurityState>(
        listener: (context, state) {
          if (state is PasswordChangedSuccess) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
            // Clear password fields on success
            _currentPasswordController.clear();
            _newPasswordController.clear();
            _confirmNewPasswordController.clear();
          } else if (state is AccountDeletedSuccess) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is DataExportedSuccess) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Data exported successfully!')),
            );
            _showExportedDataDialog(
              state.exportedData,
            ); // Show exported data in a dialog
          } else if (state is SecurityError) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Error: ${state.message}')));
          } else if (state is SecurityLoading) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Processing...')));
          }
        },
        builder: (context, state) {
          final bool isLoading = state is SecurityLoading;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Change Password Section
                Text(
                  'Change Password',
                  style: Theme.of(
                    context,
                  ).textTheme.headlineSmall?.copyWith(color: Colors.black),
                ),
                const SizedBox(height: 16),
                Form(
                  key: _changePasswordFormKey,
                  child: Column(
                    children: [
                      _buildTextField(
                        controller: _currentPasswordController,
                        labelText: 'Current Password',
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your current password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _newPasswordController,
                        labelText: 'New Password',
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a new password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters long';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _confirmNewPasswordController,
                        labelText: 'Confirm New Password',
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your new password';
                          }
                          if (value != _newPasswordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed:
                              isLoading
                                  ? null
                                  : () {
                                    if (_changePasswordFormKey.currentState!
                                        .validate()) {
                                      context.read<SecurityViewModel>().add(
                                        ChangePasswordEvent(
                                          currentPassword:
                                              _currentPasswordController.text,
                                          newPassword:
                                              _newPasswordController.text,
                                          confirmPassword:
                                              _confirmNewPasswordController
                                                  .text,
                                        ),
                                      );
                                    }
                                  },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 15,
                            ),
                          ),
                          child:
                              isLoading
                                  ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : const Text(
                                    'Change Password',
                                    style: TextStyle(fontSize: 16),
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // Export Data Section
                Text(
                  'Export My Data',
                  style: Theme.of(
                    context,
                  ).textTheme.headlineSmall?.copyWith(color: Colors.black),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Download a copy of all your personal data stored in the application.',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton(
                    onPressed:
                        isLoading
                            ? null
                            : () {
                              context.read<SecurityViewModel>().add(
                                ExportDataEvent(),
                              );
                            },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.blueGrey, // A distinct color for export
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                    ),
                    child:
                        isLoading
                            ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                                strokeWidth: 2,
                              ),
                            )
                            : const Text(
                              'Export Data',
                              style: TextStyle(fontSize: 16),
                            ),
                  ),
                ),
                const SizedBox(height: 40),

                // Delete Account Section
                Text(
                  'Delete Account',
                  style: Theme.of(
                    context,
                  ).textTheme.headlineSmall?.copyWith(color: Colors.black),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Permanently delete your account and all associated data. This action cannot be undone.',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _showDeleteConfirmationDialog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // Red for destructive action
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                    ),
                    child:
                        isLoading
                            ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                                strokeWidth: 2,
                              ),
                            )
                            : const Text(
                              'Delete Account',
                              style: TextStyle(fontSize: 16),
                            ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
