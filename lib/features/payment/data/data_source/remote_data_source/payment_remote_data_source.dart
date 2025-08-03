import 'package:tradeverse/app/constant/api/api_endpoint.dart';
import 'package:tradeverse/core/network/api_service.dart';
import 'package:tradeverse/features/payment/data/data_source/payment_data_source.dart';
import 'package:tradeverse/features/payment/data/model/checkout_response_model.dart';
import 'package:tradeverse/features/payment/data/model/payment_api_model.dart';
import 'package:tradeverse/features/payment/data/model/verify_payment_model.dart';
import 'package:tradeverse/features/payment/domain/use_case/checkout_use_case.dart';

class PaymentRemoteDataSource implements IPaymentDataSource {
  final ApiService _apiService;

  PaymentRemoteDataSource(this._apiService);

  @override
  Future<List<PaymentApiModel>> getAllPlans() async {
    try {
      final response = await _apiService.get(ApiEndpoints.plans);
      final data = response.data as List;
      return data
          .map((json) => PaymentApiModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<CheckoutResponseModel> checkoutPlan(CheckoutParams params) async {
    try {
      final body = params.toJson();
      final response = await _apiService.post(
        ApiEndpoints.checkout,
        data: body,
      );
      return CheckoutResponseModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<VerifyPaymentModel> verifyPayment(
    String sessionId,
    String email,
  ) async {
    try {
      final body = {"sessionId": sessionId, "email": email};
      final response = await _apiService.post(
        ApiEndpoints.verifyPayment,
        data: body,
      );
      return VerifyPaymentModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
