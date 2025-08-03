import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradeverse/features/payment/domain/use_case/checkout_use_case.dart';
import 'package:tradeverse/features/payment/domain/use_case/get_plans_use_case.dart';
import 'package:tradeverse/features/payment/domain/use_case/verify_payment_use_case.dart';
import 'package:tradeverse/features/payment/presentation/view_model/payment_event.dart';
import 'package:tradeverse/features/payment/presentation/view_model/payment_state.dart';

class PaymentViewModel extends Bloc<PaymentEvent, PaymentState> {
  final GetPlansUseCase _getPlansUseCase;
  final CheckoutUseCase _checkoutUseCase;
  final VerifyPaymentUseCase _verifyPaymentUseCase;

  PaymentViewModel({
    required GetPlansUseCase getPlansUseCase,
    required CheckoutUseCase checkoutUseCase,
    required VerifyPaymentUseCase verifyPaymentUseCase,
  }) : _getPlansUseCase = getPlansUseCase,
       _checkoutUseCase = checkoutUseCase,
       _verifyPaymentUseCase = verifyPaymentUseCase,
       super(const PaymentState()) {
    on<LoadPaymentPlans>(_onLoadPaymentPlans);
    on<TogglePlanDuration>(_onToggleDuration);
    on<SelectPaymentPlan>(_onSelectPlan);
    on<StartCheckout>(_onStartCheckout);
    on<VerifyPayment>(_onVerifyPayment);
  }

  Future<void> _onLoadPaymentPlans(
    LoadPaymentPlans event,
    Emitter<PaymentState> emit,
  ) async {
    emit(state.copyWith(status: PaymentStatus.loading));
    final result = await _getPlansUseCase();

    result.fold(
      (failure) => emit(
        state.copyWith(status: PaymentStatus.failure, message: failure.message),
      ),
      (plans) {
        if (plans.isEmpty) {
          emit(
            state.copyWith(
              status: PaymentStatus.failure,
              message: 'No plans available',
            ),
          );
        } else {
          emit(
            state.copyWith(
              plans: plans,
              selectedPlan: plans.first,
              status: PaymentStatus.success,
            ),
          );
        }
      },
    );
  }

  void _onToggleDuration(TogglePlanDuration event, Emitter<PaymentState> emit) {
    emit(state.copyWith(isYearly: event.isYearly));
  }

  void _onSelectPlan(SelectPaymentPlan event, Emitter<PaymentState> emit) {
    emit(state.copyWith(selectedPlan: event.selectedPlan));
  }

  Future<void> _onStartCheckout(
    StartCheckout event,
    Emitter<PaymentState> emit,
  ) async {
    final selected = state.selectedPlan;
    if (selected == null) return;

    emit(state.copyWith(status: PaymentStatus.loading));

    final result = await _checkoutUseCase(
      CheckoutParams(
        name: selected.name,
        monthlyPrice: selected.monthlyPrice,
        yearlyPrice: selected.yearlyPrice,
        isYearly: state.isYearly,
        email: event.email,
        clientUrl: 'tradeverse://checkout-success',
      ),
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: PaymentStatus.failure,
            message: failure.message,
          ),
        );
      },
      (checkout) {
        emit(
          state.copyWith(
            status: PaymentStatus.success,
            checkoutResponse: checkout,
          ),
        );
      },
    );
  }

  Future<void> _onVerifyPayment(
    VerifyPayment event,
    Emitter<PaymentState> emit,
  ) async {
    print(
      '🟢 PaymentViewModel: _onVerifyPayment received. SessionId: ${event.sessionId}, Email: ${event.email}',
    );
    emit(state.copyWith(status: PaymentStatus.loading));
    print('🟢 PaymentViewModel: Emitted loading status for verification.');

    final result = await _verifyPaymentUseCase(
      VerifyPaymentParams(sessionId: event.sessionId, email: event.email),
    );

    result.fold(
      (failure) {
        print('🔴 PaymentViewModel: Verify payment failed: ${failure.message}');
        emit(
          state.copyWith(
            status: PaymentStatus.failure,
            message: failure.message,
            verifyResult: null,
          ),
        );
        print('🔴 PaymentViewModel: Emitted failure status for verification.');
      },
      (verification) {
        print(
          '✅ PaymentViewModel: Verify payment succeeded. Entity: $verification, success: ${verification.success}',
        );
        emit(
          state.copyWith(
            status: PaymentStatus.success,
            verifyResult: verification,
            message: null,
            checkoutResponse: null,
          ),
        );
        print(
          '✅ PaymentViewModel: Emitted success status with verifyResult.',
        );
      },
    );
  }
}
