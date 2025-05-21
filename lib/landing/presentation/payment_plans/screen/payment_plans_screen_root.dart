import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mongo_ai/core/routing/routes.dart';
import 'package:mongo_ai/create/domain/model/create_complete_params.dart';
import 'package:mongo_ai/landing/domain/enum/landing_header_menu_type.dart';
import 'package:mongo_ai/landing/presentation/landing_shell/controller/landing_shell_view_model.dart';
import 'package:mongo_ai/landing/presentation/payment_plans/controller/payment_plans_action.dart';
import 'package:mongo_ai/landing/presentation/payment_plans/controller/payment_plans_view_model.dart';
import 'package:mongo_ai/landing/presentation/payment_plans/screen/payment_plans_screen.dart';

class PaymentPlansScreenRoot extends ConsumerStatefulWidget {
  final CreateCompleteParams? params;
  const PaymentPlansScreenRoot(this.params, {super.key});

  @override
  ConsumerState<PaymentPlansScreenRoot> createState() =>
      _PaymentPlansScreenRootState();
}

class _PaymentPlansScreenRootState
    extends ConsumerState<PaymentPlansScreenRoot> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final landingShellViewModel = ref.watch(
        landingShellViewModelProvider.notifier,
      );
      ref.watch(paymentPlansViewModelProvider(widget.params));

      landingShellViewModel.setNavigationItem(
        LandingHeaderMenuType.paymentPlans,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return PaymentPlansScreen(onAction: _handleAction);
  }

  void _handleAction(PaymentPlansAction action) {
    final viewModel = ref.read(
      paymentPlansViewModelProvider(widget.params).notifier,
    );

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
      case OnPressedPrivacyPolicies():
        context.go(Routes.privacyPolicies);
    }
  }
}
