import 'package:hive_flutter/adapters.dart';
import 'package:tradeverse/features/payment/data/model/payment_hive_model.dart';

class PaymentLocalDataSource {
  final Box<PaymentHiveModel> _paymentBox;

  PaymentLocalDataSource(this._paymentBox);

  Future<List<PaymentHiveModel>> getAllPlans() async {
    return _paymentBox.values.toList();
  }

  Future<void> cachePlans(List<PaymentHiveModel> plans) async {
    await _paymentBox.clear();
    for (var plan in plans) {
      await _paymentBox.add(plan);
    }
  }

  Future<List<PaymentHiveModel>> getCachedPlans() async {
    return _paymentBox.values.toList();
  }
}
