import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mongo_ai/auth/presentation/check_otp/controller/check_otp_action.dart';
import 'package:mongo_ai/auth/presentation/check_otp/controller/check_otp_view_model.dart';
import 'package:mongo_ai/auth/presentation/check_otp/screen/check_otp_screen.dart';
import 'package:mongo_ai/core/routing/routes.dart';

class CheckOtpScreenRoot extends ConsumerWidget {
  final String email;

  const CheckOtpScreenRoot({super.key, required this.email});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(checkOtpViewModelProvider(email));

    return Scaffold(
      body: CheckOtpScreen(
        state: state,
        onAction: (action) => _handleAction(ref, context, action: action),
      ),
    );
  }

  void _handleAction(
    WidgetRef ref,
    BuildContext context, {
    required CheckOtpAction action,
  }) {
    final viewModel = ref.read(checkOtpViewModelProvider(email).notifier);

    switch (action) {
      case OnVerifyOtp():
        viewModel.verifyEmailOtp();
        break;
      case OnResendOtp():
        viewModel.resendOtp();
        break;
      case OnBackTap():
        context.go(Routes.signUp);
        break;
    }
  }
}
