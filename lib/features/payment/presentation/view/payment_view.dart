import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradeverse/app/service_locator/service_locator.dart';
import 'package:tradeverse/features/auth/presentation/view/login_view.dart';
import 'package:tradeverse/features/payment/presentation/view_model/payment_event.dart';
import 'package:tradeverse/features/payment/presentation/view_model/payment_state.dart';
import 'package:tradeverse/features/payment/presentation/view_model/payment_view_model.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentView extends StatelessWidget {
  final String email;

  const PaymentView({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => PaymentViewModel(
            getPlansUseCase: serviceLocator(),
            checkoutUseCase: serviceLocator(),
            verifyPaymentUseCase: serviceLocator(),
          )..add(LoadPaymentPlans()),
      child: BlocConsumer<PaymentViewModel, PaymentState>(
        listenWhen:
            (previous, current) =>
                previous.status != current.status ||
                previous.checkoutResponse != current.checkoutResponse ||
                previous.verifyResult != current.verifyResult,
        listener: (context, state) async {
          debugPrint(
            '✅ App-level listener triggered. Current state verifyResult: ${state.verifyResult}',
          );
          // Show error message
          if (state.status == PaymentStatus.failure && state.message != null) {
            if (context.mounted) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message!)));
            }
          }

          if (state.status == PaymentStatus.success &&
              state.checkoutResponse != null &&
              state.checkoutResponse!.checkoutUrl.isNotEmpty) {
            final url = state.checkoutResponse!.checkoutUrl;

            try {
              await launchUrl(
                Uri.parse(url),
                mode: LaunchMode.externalApplication,
              );
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Could not launch Stripe checkout'),
                  ),
                );
              }
            }
          }
          if (state.verifyResult != null && state.verifyResult!.success) {
            debugPrint(
              'Attempting to navigate from App to LoginView via _navigatorKey...',
            );
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (context.mounted) {
                // Re-check mounted status for safety
                print("Navigating to LoginView via addPostFrameCallback...");
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => LoginView()),
                  (route) => false,
                );
              } else {
                print(
                  "Context not mounted when addPostFrameCallback executed. Widget disposed.",
                );
              }
            });
          }
        },
        builder: (context, state) {
          final viewModel = context.read<PaymentViewModel>();

          return Scaffold(
            appBar: AppBar(title: const Text('Choose Your Plan')),
            body:
                state.status == PaymentStatus.loading
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                      children: [
                        SwitchListTile(
                          title: const Text("Yearly Billing"),
                          value: state.isYearly,
                          onChanged: (val) {
                            viewModel.add(TogglePlanDuration(val));
                          },
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: state.plans.length,
                            itemBuilder: (_, index) {
                              final plan = state.plans[index];
                              final isSelected = plan == state.selectedPlan;
                              final price =
                                  state.isYearly
                                      ? plan.yearlyPrice
                                      : plan.monthlyPrice;

                              return Card(
                                elevation: isSelected ? 8 : 2,
                                shape: RoundedRectangleBorder(
                                  side:
                                      isSelected
                                          ? BorderSide(
                                            color:
                                                Theme.of(context).primaryColor,
                                            width: 2,
                                          )
                                          : BorderSide.none,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ListTile(
                                  title: Text(
                                    '${plan.name} Plan - \$${price.toStringAsFixed(2)}',
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children:
                                        plan.features
                                            .map(
                                              (f) => Row(
                                                children: [
                                                  Icon(
                                                    f.included
                                                        ? Icons.check
                                                        : Icons.close,
                                                    color:
                                                        f.included
                                                            ? Colors.green
                                                            : Colors.red,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(f.text),
                                                ],
                                              ),
                                            )
                                            .toList(),
                                  ),
                                  onTap: () {
                                    viewModel.add(SelectPaymentPlan(plan));
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ElevatedButton(
                            onPressed:
                                () => viewModel.add(StartCheckout(email)),
                            child: const Text('Continue to Payment'),
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
