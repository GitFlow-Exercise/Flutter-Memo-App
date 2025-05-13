import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mongo_ai/auth/presentation/check_otp/controller/check_otp_action.dart';
import 'package:mongo_ai/auth/presentation/check_otp/controller/check_otp_event.dart';
import 'package:mongo_ai/auth/presentation/check_otp/controller/check_otp_view_model.dart';
import 'package:mongo_ai/auth/presentation/check_otp/screen/check_otp_screen.dart';
import 'package:mongo_ai/core/routing/routes.dart';

class CheckOtpScreenRoot extends ConsumerStatefulWidget {
  final String email;

  const CheckOtpScreenRoot({super.key, required this.email});

  @override
  ConsumerState<CheckOtpScreenRoot> createState() => _CheckOtpScreenRootState();
}

class _CheckOtpScreenRootState extends ConsumerState<CheckOtpScreenRoot> {
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = ref.watch(checkOtpViewModelProvider.notifier);
      _subscription = viewModel.eventStream.listen(_handleEvent);
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _handleEvent(CheckOtpEvent event) {
    switch (event) {
      case ShowSnackBar(message: final message):
        print(message);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
        break;
      case NavigateToPasswordScreen():
        if (mounted) {
          context.go(Routes.signUpPassword);
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(checkOtpViewModelProvider);

    return Scaffold(
      body: CheckOtpScreen(state: state, onAction: _handleAction),
    );
  }

  void _handleAction(CheckOtpAction action) {
    final viewModel = ref.read(checkOtpViewModelProvider.notifier);

    switch (action) {
      case OnVerifyOtp():
        viewModel.verifyOtp();
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
