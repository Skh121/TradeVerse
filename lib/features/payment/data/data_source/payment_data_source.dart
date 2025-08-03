import 'package:tradeverse/features/payment/data/model/checkout_response_model.dart';
import 'package:tradeverse/features/payment/data/model/payment_api_model.dart';
import 'package:tradeverse/features/payment/data/model/verify_payment_model.dart';
import 'package:tradeverse/features/payment/domain/use_case/checkout_use_case.dart';

abstract interface class IPaymentDataSource {
  Future<List<PaymentApiModel>> getAllPlans();
  Future<CheckoutResponseModel> checkoutPlan(CheckoutParams params);
  Future<VerifyPaymentModel> verifyPayment(String sessionId, String email);
}
