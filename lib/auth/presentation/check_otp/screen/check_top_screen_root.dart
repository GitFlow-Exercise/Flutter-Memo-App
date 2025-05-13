import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongo_ai/auth/presentation/check_otp/controller/check_otp_action.dart';
import 'package:mongo_ai/auth/presentation/check_otp/controller/check_otp_event.dart';
import 'package:mongo_ai/auth/presentation/check_otp/controller/check_otp_view_model.dart';
import 'package:mongo_ai/auth/presentation/check_otp/screen/check_otp_screen.dart';

class CheckOtpScreenRoot extends ConsumerStatefulWidget {
  final String tempUserId;

  const CheckOtpScreenRoot({super.key, required this.tempUserId});

  @override
  ConsumerState<CheckOtpScreenRoot> createState() => _CheckOtpScreenRootState();
}

class _CheckOtpScreenRootState extends ConsumerState<CheckOtpScreenRoot> {
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = ref.watch(
        checkOtpViewModelProvider(widget.tempUserId).notifier,
      );

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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(checkOtpViewModelProvider(widget.tempUserId));

    return Scaffold(
      body: CheckOtpScreen(state: state, onAction: _handleAction),
    );
  }

  void _handleAction(CheckOtpAction action) {
    switch (action) {
      case OnTap():
        debugPrint('tapped onTap');
    }
  }
}
