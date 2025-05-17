import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongo_ai/landing/presentation/payment_plans/controller/payment_plans_action.dart';
import 'package:mongo_ai/landing/presentation/payment_plans/controller/payment_plans_event.dart';
import 'package:mongo_ai/landing/presentation/payment_plans/controller/payment_plans_view_model.dart';
import 'package:mongo_ai/landing/presentation/payment_plans/screen/payment_plans_screen.dart';

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
    return PaymentPlansScreen(onAction: _handleAction);
  }

  void _handleAction(PaymentPlansAction action) {
    final viewModel = ref.read(paymentPlansViewModelProvider.notifier);

    switch (action) {
      case OnStartClick():
        viewModel.showStartButtonClicked();
        debugPrint('시작하기 버튼 클릭');
      case OnUpgradeClick():
        viewModel.showUpgradeButtonClicked();
        debugPrint('업그레이드 버튼 클릭');
      case OnFreeTrialClick():
        viewModel.showFreeTrial();
        debugPrint('무료로 시작하기 버튼 클릭');
    }
  }
}