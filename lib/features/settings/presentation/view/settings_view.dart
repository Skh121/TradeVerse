import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:tradeverse/core/utils/biometric_auth_service.dart';
import 'package:tradeverse/features/auth/presentation/view_model/logout_view_model/logout_event.dart';
import 'package:tradeverse/features/auth/presentation/view_model/logout_view_model/logout_state.dart';
import 'package:tradeverse/features/auth/presentation/view_model/logout_view_model/logout_view_model.dart';
import 'package:tradeverse/features/goal/presentation/view/goal_view.dart';
import 'package:tradeverse/features/security/presentation/view/security_view.dart';
import 'package:tradeverse/features/profile/presentation/view/profile_view.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final BiometricAuthService _authService = BiometricAuthService();

  static const double shakeThreshold = 15.0;
  static const int shakeDebounceMs = 500;
  late final StreamSubscription _accelerometerSub;
  int _lastShakeTimestamp = 0;

  @override
  void initState() {
    super.initState();

    _accelerometerSub = accelerometerEvents.listen((event) {
      final now = DateTime.now().millisecondsSinceEpoch;
      final acceleration = sqrt(
        event.x * event.x + event.y * event.y + event.z * event.z,
      );

      if (acceleration > shakeThreshold &&
          now - _lastShakeTimestamp > shakeDebounceMs) {
        _lastShakeTimestamp = now;
        _confirmAndLogout();
      }
    });
  }

  Future<void> _confirmAndLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Logout'),
            content: const Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text('Logout'),
              ),
            ],
          ),
    );

    if (confirmed == true && context.mounted) {
      context.read<LogoutViewModel>().add(PerformLogout());
    }
  }

  @override
  void dispose() {
    _accelerometerSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 1,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: BlocConsumer<LogoutViewModel, LogoutState>(
        listener: (context, state) {
          if (state is LogoutSuccess) {
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil('/login', (route) => false);
          } else if (state is LogoutFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                const Text(
                  'Manage your account settings',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                _buildSettingsCard(
                  context,
                  icon: Icons.person,
                  title: 'Profile',
                  subtitle: 'Edit your personal information',
                  destination: const ProfileView(),
                ),
                _buildSettingsCard(
                  context,
                  icon: Icons.lock,
                  title: 'Security Settings',
                  subtitle: 'Change password and security options',
                  onTap: () async {
                    final canAuth = await _authService.canAuthenticate();
                    if (canAuth) {
                      final didAuthenticate = await _authService.authenticate(
                        'Please authenticate to access security settings',
                      );
                      if (didAuthenticate && context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SecurityView(),
                          ),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Biometrics not available."),
                        ),
                      );
                    }
                  },
                ),
                _buildSettingsCard(
                  context,
                  icon: Icons.flag,
                  title: 'Goal',
                  subtitle: 'View and manage your trading goals',
                  destination: const GoalView(),
                ),
                const SizedBox(height: 10),
                _buildSettingsCard(
                  context,
                  icon: Icons.logout,
                  title: 'Logout',
                  subtitle: 'Sign out of your account',
                  onTap: () {
                    context.read<LogoutViewModel>().add(PerformLogout());
                  },
                  trailing:
                      state is LogoutLoading
                          ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.grey,
                          ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSettingsCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? destination,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap:
            onTap ??
            () {
              if (destination != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => destination),
                );
              }
            },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.blue.shade50,
                child: Icon(icon, color: Colors.red),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              trailing ??
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
