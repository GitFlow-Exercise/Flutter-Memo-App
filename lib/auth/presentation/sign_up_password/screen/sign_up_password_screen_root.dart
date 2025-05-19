import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mongo_ai/auth/presentation/sign_up_password/controller/sign_up_password_action.dart';
import 'package:mongo_ai/auth/presentation/sign_up_password/controller/sign_up_password_event.dart';
import 'package:mongo_ai/auth/presentation/sign_up_password/controller/sign_up_password_view_model.dart';
import 'package:mongo_ai/auth/presentation/sign_up_password/screen/sign_up_password_screen.dart';
import 'package:mongo_ai/core/routing/routes.dart';

class SignUpPasswordScreenRoot extends ConsumerStatefulWidget {
  const SignUpPasswordScreenRoot({super.key});

  @override
  ConsumerState<SignUpPasswordScreenRoot> createState() =>
      _SignUpPasswordScreenRootState();
}

class _SignUpPasswordScreenRootState
    extends ConsumerState<SignUpPasswordScreenRoot> {
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = ref.watch(signUpPasswordViewModelProvider.notifier);

      _subscription = viewModel.eventStream.listen(_handleEvent);
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _handleEvent(SignUpPasswordEvent event) {
    switch (event) {
      case ShowSnackBar(message: final message):
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
        break;
      case NavigateToComplete():
        if (mounted) {
          context.go(Routes.signUpComplete);
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(signUpPasswordViewModelProvider);

    return Scaffold(
      body: SignUpPasswordScreen(state: state, onAction: _handleAction),
    );
  }

  void _handleAction(SignUpPasswordAction action) async {
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
