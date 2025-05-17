import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongo_ai/landing/presentation/controller/payment_plans_action.dart';
import 'package:mongo_ai/landing/presentation/controller/payment_plans_event.dart';
import 'package:mongo_ai/landing/presentation/controller/payment_plans_view_model.dart';
import 'package:mongo_ai/landing/presentation/screen/payment_plans_screen.dart';

class PaymentPlansScreenRoot extends ConsumerStatefulWidget {
  const PaymentPlansScreenRoot({super.key});

  @override
  ConsumerState<PaymentPlansScreenRoot> createState() => _PaymentPlansScreenRootState();
}

class _PaymentPlansScreenRootState extends ConsumerState<PaymentPlansScreenRoot> {
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = ref.watch(paymentPlansViewModelProvider.notifier);

      _subscription = viewModel.eventStream.listen(_handleEvent);
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _handleEvent(PaymentPlansEvent event) {
    switch (event) {
      case ShowSnackBar(message: final message):
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message))
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(paymentPlansViewModelProvider);

    return Scaffold(
      body: PaymentPlansScreen(state: state, onAction: _handleAction),
    );
  }

  void _handleAction(PaymentPlansAction action) {
    switch (action) {
      case OnTap():
        debugPrint('tapped onTap');
    }
  }
}