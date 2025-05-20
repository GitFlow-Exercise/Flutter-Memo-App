import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';
import 'package:mongo_ai/landing/domain/enum/landing_header_menu_type.dart';
import 'package:mongo_ai/landing/presentation/landing_shell/controller/landing_shell_view_model.dart';
import 'package:mongo_ai/landing/presentation/payment_plans/controller/payment_plans_action.dart';
import 'package:mongo_ai/landing/presentation/payment_plans/controller/payment_plans_event.dart';
import 'package:mongo_ai/landing/presentation/payment_plans/controller/payment_plans_view_model.dart';
import 'package:mongo_ai/landing/presentation/payment_plans/screen/payment_plans_screen.dart';

class PaymentPlansScreenRoot extends ConsumerStatefulWidget {
  const PaymentPlansScreenRoot({super.key});

  @override
  ConsumerState<PaymentPlansScreenRoot> createState() =>
      _PaymentPlansScreenRootState();
}

class _PaymentPlansScreenRootState
    extends ConsumerState<PaymentPlansScreenRoot> {
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = ref.watch(paymentPlansViewModelProvider.notifier);
      final landingShellViewModel = ref.watch(
        landingShellViewModelProvider.notifier,
      );

      _subscription = viewModel.eventStream.listen(_handleEvent);

      landingShellViewModel.setNavigationItem(
        LandingHeaderMenuType.paymentPlans,
      );
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _handleEvent(PaymentPlansEvent event) {
    switch (event) {
      case ShowToast(message: final message):
        // 토스트 메시지로 변경
        final overlay = Overlay.of(context);
        final overlayEntry = OverlayEntry(
          builder:
              (context) => Positioned(
                bottom: 50,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      border: Border.all(
                        color: AppColor.primary.withValues(alpha: 0.5),
                      ),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Text(
                      message,
                      style: AppTextStyle.bodyMedium.copyWith(
                        color: AppColor.primary,
                      ),
                    ),
                  ),
                ),
              ),
        );

        overlay.insert(overlayEntry);
        Future.delayed(const Duration(seconds: 3), () {
          overlayEntry.remove();
        });
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
