import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mongo_ai/auth/presentation/sign_up/controller/sign_up_action.dart';
import 'package:mongo_ai/auth/presentation/sign_up/controller/sign_up_event.dart';
import 'package:mongo_ai/auth/presentation/sign_up/controller/sign_up_view_model.dart';
import 'package:mongo_ai/auth/presentation/sign_up/screen/password_sign_up_screen.dart';
import 'package:mongo_ai/auth/presentation/sign_up/screen/sign_up_screen.dart';
import 'package:mongo_ai/core/routing/routes.dart';

class SignUpScreenRoot extends ConsumerStatefulWidget {
  const SignUpScreenRoot({super.key});

  @override
  ConsumerState<SignUpScreenRoot> createState() => _SignUpScreenRootState();
}

class _SignUpScreenRootState extends ConsumerState<SignUpScreenRoot> {
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = ref.watch(signUpViewModelProvider.notifier);

      _subscription = viewModel.eventStream.listen(_handleEvent);
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _handleEvent(SignUpEvent event) {
    switch (event) {
      case ShowSnackBar(message: final message):
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(signUpViewModelProvider);

    return state.isEmailCompleted
        ? PasswordSignupScreen(state: state, onAction: _handleAction)
        : SignUpScreen(state: state, onAction: _handleAction);
  }

  void _handleAction(SignUpAction action) async {
    final viewModel = ref.read(signUpViewModelProvider.notifier);

    switch (action) {
      case OnTapStart():
        if (await viewModel.verifyOtp()) {
          viewModel.isEmailCompleted = true;
        }
      case OnTapTermsOfUse():
        viewModel.toggleTermsOfUse();
      case OnTapSignUp():
        final isPasswordUpdated = await viewModel.resetPassword();
        if (isPasswordUpdated) {
          if (await viewModel.saveUser() && mounted) {
            context.go(Routes.signUpComplete);
          }
        }
      case OnTapSignIn():
        context.go(Routes.signIn);
      case OnTapOtpSend():
        if (await viewModel.checkEmail()) {
          viewModel.sendOtp();
        }
    }
  }
}
