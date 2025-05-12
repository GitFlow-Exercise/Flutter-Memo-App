import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mongo_ai/auth/domain/model/temp_user.dart';
import 'package:mongo_ai/auth/presentation/sign_up_password/controller/sign_up_password_action.dart';
import 'package:mongo_ai/auth/presentation/sign_up_password/controller/sign_up_password_event.dart';
import 'package:mongo_ai/auth/presentation/sign_up_password/controller/sign_up_password_view_model.dart';
import 'package:mongo_ai/auth/presentation/sign_up_password/screen/sign_up_password_screen.dart';
import 'package:mongo_ai/core/routing/routes.dart';

class SignUpPasswordScreenRoot extends ConsumerStatefulWidget {
  final String tempUserId;

  const SignUpPasswordScreenRoot({super.key, required this.tempUserId});

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
      final viewModel = ref.watch(signUpPasswordViewModelProvider(widget.tempUserId).notifier);

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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
        break;
      case NavigateToVerifyOtp(tempUserId: final tempUserId):
        if (mounted) {
          context.go(Routes.checkOtp, extra: tempUserId);
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(signUpPasswordViewModelProvider(widget.tempUserId));

    return Scaffold(
      body: SignUpPasswordScreen(state: state, onAction: _handleAction),
    );
  }

  void _handleAction(SignUpPasswordAction action) async  {
    final viewModel = ref.read(signUpPasswordViewModelProvider(widget.tempUserId).notifier);

    switch (action) {
      case OnTapSendOtp():
        if (await viewModel.successSendOtp() && mounted) {
          context.go(Routes.checkOtp);
        }
        break;
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
    }
  }
}