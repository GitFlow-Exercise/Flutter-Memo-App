import 'package:flutter/material.dart';
import 'package:mongo_ai/landing/presentation/controller/payment_plans_action.dart';
import 'package:mongo_ai/landing/presentation/controller/payment_plans_state.dart';

class PaymentPlansScreen extends StatefulWidget {
  final PaymentPlansState state;
  final void Function(PaymentPlansAction action) onAction;

  const PaymentPlansScreen({super.key, required this.state, required this.onAction});

  @override
  State<PaymentPlansScreen> createState() => _PaymentPlansScreenState();
}

class _PaymentPlansScreenState extends State<PaymentPlansScreen> {
  @override
  Widget build(BuildContext context) {
    return Placeholder();
  }
}