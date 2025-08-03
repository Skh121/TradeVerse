class PaymentPlanEntity {
  final String name;
  final double monthlyPrice;
  final double yearlyPrice;
  final double savedAmount;
  final List<PlanFeature> features;

  PaymentPlanEntity({
    required this.name,
    required this.monthlyPrice,
    required this.yearlyPrice,
    required this.savedAmount,
    required this.features,
  });
}

class PlanFeature {
  final String text;
  final bool included;

  PlanFeature({required this.text, required this.included});
}
