import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradeverse/features/auth/presentation/view/verify_otp_view.dart';
import 'package:tradeverse/features/auth/presentation/view_model/forgot_password_view_model.dart/forgot_password_event.dart';
import 'package:tradeverse/features/auth/presentation/view_model/forgot_password_view_model.dart/forgot_password_state.dart';
import 'package:tradeverse/features/auth/presentation/view_model/forgot_password_view_model.dart/forgot_password_view_model.dart';

class RequestOtpView extends StatefulWidget {
  const RequestOtpView({super.key});

  @override
  State<RequestOtpView> createState() => _RequestOtpViewState();
}

class _RequestOtpViewState extends State<RequestOtpView> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _requestOtp() {
    // Renamed function
    if (_formKey.currentState?.validate() ?? false) {
      context.read<ForgotPasswordViewModel>().add(
        RequestOtpEvent(email: _emailController.text.trim()),
      ); // Dispatch new event
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: BlocListener<ForgotPasswordViewModel, ForgotPasswordState>(
        listener: (context, state) {
          if (state is OtpRequestedSuccess) {
            // Listen for new success state
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
            // Navigate to OTP verification screen, passing the email
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (_) => BlocProvider.value(
                      // Pass existing Bloc
                      value: context.read<ForgotPasswordViewModel>(),
                      child: VerifyOtpView(email: state.email), // Pass email
                    ),
              ),
            );
          } else if (state is ForgotPasswordError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Enter your email to receive a One-Time Password (OTP).',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your registered email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    prefixIcon: const Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                BlocBuilder<ForgotPasswordViewModel, ForgotPasswordState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed:
                          state is ForgotPasswordLoading ? null : _requestOtp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child:
                          state is ForgotPasswordLoading
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                              : const Text(
                                'Send OTP', // Renamed button text
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
