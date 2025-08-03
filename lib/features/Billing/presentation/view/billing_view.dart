import 'package:flutter/material.dart';

class BillingView extends StatelessWidget {
  const BillingView({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Billing'), leading: const BackButton()),
    body: const Center(child: Text('Billing Page')),
  );
}
