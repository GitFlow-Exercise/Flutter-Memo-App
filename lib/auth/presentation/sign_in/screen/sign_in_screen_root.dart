import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mongo_ai/auth/presentation/sign_in/controller/sign_in_action.dart';
import 'package:mongo_ai/auth/presentation/sign_in/controller/sign_in_view_model.dart';
import 'package:mongo_ai/auth/presentation/sign_in/screen/sign_in_screen.dart';
import 'package:mongo_ai/core/routing/routes.dart';

class SignInScreenRoot extends ConsumerWidget {
  const SignInScreenRoot({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(signInViewModelProvider);
    return SignInScreen(
      state: state,
      onAction: (action) => _handleAction(action, ref, context),
    );
  }

  void _handleAction(
    SignInAction action,
    WidgetRef ref,
    BuildContext context,
  ) async {
    final viewModel = ref.watch(signInViewModelProvider.notifier);

    switch (action) {
      case OnTapLogin():
        await viewModel.login();
      case OnTapSignUp():
        context.go(Routes.signUp);
      case OnTapGoogleSingIn():
        await viewModel.googleSignIn();
    }
  }
}
