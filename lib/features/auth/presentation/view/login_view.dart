import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradeverse/app/service_locator/service_locator.dart';
import 'package:tradeverse/features/auth/presentation/view/signup_view.dart';
import 'package:tradeverse/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:tradeverse/features/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:tradeverse/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:tradeverse/features/auth/presentation/view_model/signup_view_model/signup_view_model.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bloc = context.read<LoginViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: BlocListener<LoginViewModel, LoginState>(
            listener: (context, state) {
              if (state.formStatus == FormStatus.failure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.red,
                    content: Text(
                      style: TextStyle(color: Colors.white),
                      state.message ?? "Login Failed",
                    ),
                  ),
                );
                bloc.add(ResetFormStatus());
              } else if (state.formStatus == FormStatus.success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.green,
                    content: Text(
                      style: TextStyle(color: Colors.white),
                      state.message ?? "Login Successfull",
                    ),
                  ),
                );
                bloc.add(ResetFormStatus());
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: size.height * 0.35,
                      child: Image.asset(
                        'assets/images/backgroundImage.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 160,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Image.asset(
                          'assets/images/appLogo.png',
                          width: 92,
                          height: 92,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back!',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Email Address',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        onChanged:
                            (email) => bloc.add(LoginEmailChanged(email)),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email address';
                          }

                          final emailRegex = RegExp(
                            r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
                          );

                          if (!emailRegex.hasMatch(value)) {
                            return 'Please enter a valid email';
                          }

                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter your email address',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Password',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        onChanged:
                            (password) =>
                                bloc.add(LoginPasswordChanged(password)),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter your password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            // Add forgot password logic
                          },
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xffff575a),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 26),
                      SizedBox(
                        width: double.infinity,
                        child: BlocBuilder<LoginViewModel, LoginState>(
                          builder: (context, state) {
                            return ElevatedButton(
                              onPressed: () {
                                
                                if (_formKey.currentState!.validate()) {
                                  
                                  bloc.add(
                                    LoginSubmitted(state.email, state.password),
                                  );
                                  Navigator.pushReplacementNamed(context, "/dashboard");
                                }
                              },
                              child: Text('Login Now'),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 26),
                      Row(
                        children: [
                          const Expanded(
                            child: Divider(
                              thickness: 1,
                              color: Colors.black87,
                              endIndent: 12,
                            ),
                          ),
                          const Text(
                            'or continue with',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const Expanded(
                            child: Divider(
                              indent: 12,
                              color: Colors.black87,
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Add Google sign-in logic
                          },
                          label: Text('Signin with google'),
                          icon: Image.asset('assets/images/googleLogo.png'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black87,
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.grey, width: 1.0),
                              borderRadius: BorderRadius.all(
                                Radius.circular(24),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Center(
                        child: RichText(
                          text: TextSpan(
                            text: 'Don\'t have an account?',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                            children: [
                              TextSpan(
                                text: ' Signup',
                                style: TextStyle(
                                  color: Color(0xffff575a),
                                  fontWeight: FontWeight.w600,
                                ),
                                recognizer:
                                    TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) => BlocProvider(
                                                  create:
                                                      (context) =>
                                                          serviceLocator<
                                                            SignupViewModel
                                                          >(),
                                                  child: SignupView(),
                                                ),
                                          ),
                                        );
                                      },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
