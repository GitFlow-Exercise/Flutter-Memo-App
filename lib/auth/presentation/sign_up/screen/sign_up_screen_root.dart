import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mongo_ai/auth/presentation/sign_up/controller/sign_up_action.dart';
import 'package:mongo_ai/auth/presentation/sign_up/controller/sign_up_view_model.dart';
import 'package:mongo_ai/auth/presentation/sign_up/screen/sign_up_screen.dart';
import 'package:mongo_ai/core/routing/routes.dart';

class SignUpScreenRoot extends ConsumerWidget {
  const SignUpScreenRoot({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(signUpViewModelProvider);

    return SignUpScreen(
      state: state,
      onAction: (action) => _handleAction(ref, context, action: action),
    );
  }

  void _handleAction(
    WidgetRef ref,
    BuildContext context, {
    required SignUpAction action,
  }) async {
    final viewModel = ref.read(signUpViewModelProvider.notifier);

    switch (action) {
      case OnTapSignIn():
        context.go(Routes.signIn);
      case OnTapOtpSend():
        if (await viewModel.checkEmail()) {
          await viewModel.sendOtp();
        }
    }
  }
}
