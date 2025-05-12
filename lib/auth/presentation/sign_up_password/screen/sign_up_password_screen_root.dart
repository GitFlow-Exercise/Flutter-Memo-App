import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongo_ai/auth/presentation/sign_up_password/controller/sign_up_password_action.dart';
import 'package:mongo_ai/auth/presentation/sign_up_password/controller/sign_up_password_event.dart';
import 'package:mongo_ai/auth/presentation/sign_up_password/controller/sign_up_password_view_model.dart';
import 'package:mongo_ai/auth/presentation/sign_up_password/screen/sign_up_password_screen.dart';

class SignUpPasswordScreenRoot extends ConsumerStatefulWidget {
  final SignUpPasswordViewModel viewModel;

  const SignUpPasswordScreenRoot({super.key, required this.viewModel});

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
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(signUpPasswordViewModelProvider);

    return Scaffold(
      body: SignUpPasswordScreen(state: state, onAction: _handleAction),
    );
  }

  void _handleAction(SignUpPasswordAction action) {
    switch (action) {
      case OnTap():
        debugPrint('tapped onTap');
    }
  }
}
