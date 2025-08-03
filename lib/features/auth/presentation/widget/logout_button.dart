import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradeverse/features/auth/presentation/view/login_view.dart';
import 'package:tradeverse/features/auth/presentation/view_model/logout_view_model/logout_event.dart';
import 'package:tradeverse/features/auth/presentation/view_model/logout_view_model/logout_state.dart';
import 'package:tradeverse/features/auth/presentation/view_model/logout_view_model/logout_view_model.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LogoutViewModel, LogoutState>(
      listener: (context, state) {
        if (state is LogoutSuccess) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => LoginView()),
            (route) => false,
          );
        } else if (state is LogoutFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        return ElevatedButton(
          onPressed:
              state is LogoutLoading
                  ? null
                  : () => context.read<LogoutViewModel>().add(PerformLogout()),
          child:
              state is LogoutLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Logout"),
        );
      },
    );
  }
}
