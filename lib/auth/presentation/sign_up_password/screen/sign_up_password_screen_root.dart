import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mongo_ai/auth/presentation/sign_up_password/controller/sign_up_password_action.dart';
import 'package:mongo_ai/auth/presentation/sign_up_password/controller/sign_up_password_view_model.dart';
import 'package:mongo_ai/auth/presentation/sign_up_password/screen/sign_up_password_screen.dart';
import 'package:mongo_ai/core/routing/routes.dart';

class SignUpPasswordScreenRoot extends ConsumerWidget {
  const SignUpPasswordScreenRoot({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(signUpPasswordViewModelProvider);

    return Scaffold(
      body: SignUpPasswordScreen(
        state: state,
        onAction: (action) => _handleAction(ref, context, action: action),
      ),
    );
  }

  void _handleAction(
    WidgetRef ref,
    BuildContext context, {
    required SignUpPasswordAction action,
  }) async {
    final viewModel = ref.read(signUpPasswordViewModelProvider.notifier);

    switch (action) {
      case OnTapCheckPrivacyPolicy():
        viewModel.togglePrivacyPolicy();
        break;
      case OnTapShowPassword():
        viewModel.togglePasswordVisibility();
        break;
      case OnTapShowConfirmPassword():
        viewModel.toggleConfirmPasswordVisibility();
        break;
      case OnTapLogin():
        context.go(Routes.signIn);
        break;
      case SubmitForm():
        viewModel.submitForm();
        break;
    }
  }
}
